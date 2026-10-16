class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :conversations, dependent: :destroy

  # Liste des 5 profils avec leurs descriptions de référence
  CINEMA_PROFILES = {
    "The Casual Relaxer" => "watches to unwind after work and wants something easy, familiar and not too long. Values a quick decision over a perfect pick, and often rewatches favorites.",
    "The Blockbuster Fan" => "follows big releases, franchises and spectacle. Wants what everyone is talking about and likes action, sci-fi and superhero films.",
    "The Cinephile" => "knows directors, watches classics, auteur and foreign films, and doesn't mind subtitles, slow pacing or black and white. Hardest to satisfy because already seen the obvious picks.",
    "The Explorer" => "curious and eager for hidden gems, festival films and anything off the beaten track.",
    "The Genre Specialist" => "loyal to specific genres and needs recommendations that are less obvious within them."
  }.freeze

  # Liste standard des genres de films
  GENRES = [
    "Action", "Animation", "Aventure", "Comédie", "Drame",
    "Documentaire", "Expérimental", "Fantastique", "Horreur",
    "Manga / Anime", "Policier", "Romance", "Science-Fiction", "Thriller"
  ].freeze

  # Avatars disponibles (émojis cinéma simples)
  AVATARS = ["🍿", "🎬", "📽️", "🎞️", "🕶️", "🎥"].freeze

  before_save :generate_user_prompt

  private

  # Construction automatique de la synthèse profil pour Chaplin
  def generate_user_prompt
    user_name = name.presence || "L'utilisateur"
    profile_desc = CINEMA_PROFILES[cinema_profile]

    prompt_parts = []
    prompt_parts << "#{user_name} is #{cinema_profile} (#{profile_desc})." if cinema_profile.present?

    favs = favorite_genres&.compact_blank
    prompt_parts << "He/She loves #{favs.join(', ')}." if favs.present?

    dislikes = disliked_genres&.compact_blank
    prompt_parts << "He/She dislikes/hates #{dislikes.join(', ')}." if dislikes.present?

    self.user_prompt = prompt_parts.join(" ")
  end
end
