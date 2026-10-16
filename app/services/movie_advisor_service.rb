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

    cards = JSON.parse(content)

    # 3. Persistance en base de données : on crée le nouveau message associé à la conversation.
    # sender: "AI" permet à la vue conversations/show d'identifier et d'afficher le message de Chaplin.
      @conversation.messages.create!(
      sender: "AI",
      content: cards["user_response"]
      )

    cards
  end

  private

  # Méthode privée chargée de construire le contexte envoyé à l'IA.
  # Elle assemble la consigne de départ (system prompt) et tous les messages échangés.
  def build_messages
    # Récupération des critères initiaux choisis par l'utilisateur
    criteria = @conversation.criteria

    # compact_blank retire les chaînes vides, join rassemble le tableau en une phrase lisible.
    audiance = criteria&.audiance&.compact_blank&.join(", ")
    ambiance = criteria&.ambiance&.compact_blank&.join(", ")
    duree = criteria&.duree&.compact_blank&.join(", ")
    popularite = criteria&.popularite&.compact_blank&.join(", ")
    # genres_text = criteria&.genres&.compact_blank&.join(", ")

    # Prompt système : instructions données à l'IA sur son rôle et son format de réponse.
    system_prompt = <<~PROMPT
      Tu es Chaplin, un assistant cinéma chaleureux et passionné.
      Ton rôle est de recommander les films idéaux selon les préférences de l'utilisateur.

      Critères initiaux de l'utilisateur :
      - Audience : #{audiance.presence || 'Non précisé'}
      - Ambiance : #{ambiance.presence || 'Non précisé'}
      - Duree : #{duree.presence || 'Non précisé'}
      - Popularite : #{popularite.presence || 'Non précisé'}

      Consignes :
      1. Suggère 4 films pertinents avec une brève explication accrocheuse (1-2 phrases par film) expliquant pourquoi ce choix correspond exactement à la demande.
      2. Reste concis, engageant, et pose une question ouverte pour relancer l'échange si l'utilisateur souhaite affiner.
      3. Rédige en français avec des emojis cinéma bien dosés.

    Réponds uniquement avec un JSON valide

    Le champ "user_response" doit contenir un texte naturel destiné à l'utilisateur.

    Le champ "movies" doit contenir exactement 4 films.

    Format attendu :

    {
        "user_response": "texte à afficher dans la conversation",
        "movies": [
          {
            "title": "Film 1",
            "year": 2010
          },
          {
            "title": "Film 2",
            "year": 2014
          },
          {
            "title": "Film 3",
            "year": 2016
          },
          {
            "title": "Film 4",
            "year": 2017
          }
        ]
      }

  Ne renvoie aucun texte avant ou après ce JSON.
  PROMPT

  # On initialise le tableau avec le message de rôle "system"
    messages = [{ role: "system", content: system_prompt }]

    # On ajoute l'historique des échanges dans l'ordre chronologique
    # pour que l'IA se souvienne de la discussion en cours.
    @conversation.messages.order(:created_at).each do |msg|
      # OpenAI attend le rôle "assistant" pour l'IA ou "user" pour l'utilisateur
      role = ["AI", "assistant"].include?(msg.sender) ? "assistant" : "user"
      messages << { role: role, content: msg.content }
    end

    # On retourne le tableau complet prêt pour l'API
    messages
  end
end
