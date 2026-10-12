# Service Object dédié à l'interaction avec l'API OpenAI.
# En isolant la logique ici, on évite d'alourdir nos contrôleurs Rails ("Skinny Controllers").
class MovieAdvisorService
  # Le constructeur prend en paramètre l'instance de conversation concernée.
  # On initialise également le client OpenAI qui utilisera automatiquement la clé API configurée.
  def initialize(conversation)
    @conversation = conversation
    @client = OpenAI::Client.new
  end

  # Méthode principale exécutée pour générer et enregistrer la réponse de l'IA.
  def call
    # 1. Envoi de la requête à l'API OpenAI avec le modèle de chat
    response = @client.chat(
      parameters: {
        model: "gpt-4o-mini",     # Modèle léger, rapide et économique
        messages: build_messages, # Tableau contenant le prompt système et l'historique
        temperature: 0.7          # Créativité de la réponse (entre 0.0 et 1.0)
      }
    )

    # 2. Extraction du texte de la réponse depuis la structure JSON retournée par OpenAI
    # dig permet de naviguer de manière sécurisée dans les clés sans risquer d'erreur si une clé manque.
    content = response.dig("choices", 0, "message", "content")

    # Sécurité : si la réponse est vide pour une raison quelconque, on s'arrête ici.
    return if content.blank?

    # 3. Persistance en base de données : on crée le nouveau message associé à la conversation.
    # sender: "assistant" permet d'identifier visuellement qui parle dans l'interface de chat.
    @conversation.messages.create!(
      sender: "assistant",
      content: content
    )
  end

  private

  # Méthode privée chargée de construire le contexte envoyé à l'IA.
  # Elle assemble la consigne de départ (system prompt) et tous les messages échangés.
  def build_messages
    # Récupération des critères initiaux choisis par l'utilisateur
    criteria = @conversation.criteria

    # compact_blank retire les chaînes vides, join rassemble le tableau en une phrase lisible.
    genres_text = criteria&.genres&.compact_blank&.join(", ")

    # Prompt système : instructions données à l'IA sur son rôle et son format de réponse.
    system_prompt = <<~PROMPT
      Tu es Movie Match, un assistant expert en cinéma chaleureux et passionné.
      Ton rôle est de recommander les films idéaux selon les préférences de l'utilisateur.

      Critères initiaux de l'utilisateur :
      - Genres : #{genres_text.presence || 'Non précisé'}
      - Mots-clés : #{criteria&.keywords.presence || 'Non précisé'}
      - Humeur / Envie : #{criteria&.prompt.presence || 'Non précisé'}

      Consignes :
      1. Suggère 2 ou 3 films pertinents avec une brève explication accrocheuse (1-2 phrases par film) expliquant pourquoi ce choix correspond exactement à la demande.
      2. Reste concis, engageant, et pose une question ouverte pour relancer l'échange si l'utilisateur souhaite affiner.
      3. Rédige en français avec des emojis cinéma bien dosés.
    PROMPT

    # On initialise le tableau avec le message de rôle "system"
    messages = [{ role: "system", content: system_prompt }]

    # On ajoute l'historique des échanges dans l'ordre chronologique
    # pour que l'IA se souvienne de la discussion en cours.
    @conversation.messages.order(:created_at).each do |msg|
      # OpenAI attend le rôle "assistant" ou "user"
      role = msg.sender == "assistant" ? "assistant" : "user"
      messages << { role: role, content: msg.content }
    end

    # On retourne le tableau complet prêt pour l'API
    messages
  end
end
