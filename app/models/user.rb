class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :conversations, dependent: :destroy

  # 5 profils traduits en français
  CINEMA_PROFILES = {
    "Le spectateur détente" => "Regarde des films pour décompresser après le travail, recherche des choses simples, familières et pas trop longues. Privilégie un choix rapide plutôt qu'un choix parfait et revoit souvent ses favoris.",
    "L'amateur de blockbusters" => "Suit les grandes sorties, franchises et spectacles visuels. Veut voir ce dont tout le monde parle et aime l'action, la science-fiction et les super-héros.",
    "Le cinéphile exigeant" => "Connaît les réalisateurs, regarde des classiques, du cinéma d'auteur et étranger. N'a pas peur des sous-titres, du noir et blanc ou d'un rythme lent.",
    "L'explorateur curieux" => "Pas forcément expert mais curieux. Cherche des pépites méconnues, des films de festival et sort des sentiers battus.",
    "Le spécialiste de genre" => "Fidèle à un genre spécifique (horreur, comédie romantique, thriller, animation) et recherche des pépites moins évidentes au sein de ce genre."
  }.freeze

  GENRES = [
    "Action", "Animation", "Aventure", "Comédie", "Drame",
    "Documentaire", "Expérimental", "Fantastique", "Horreur",
    "Manga / Anime", "Policier", "Romance", "Science-Fiction", "Thriller"
  ].freeze

  AVATARS = ["🎬", "📽️", "🎞️", "🕶️", "🎥"].freeze

  before_save :generate_user_prompt

  private

  def generate_user_prompt
    user_name = name.presence || "L'utilisateur"
    profile_desc = CINEMA_PROFILES[cinema_profile]

    prompt_parts = []
    prompt_parts << "#{user_name} a le profil suivant : #{cinema_profile} (#{profile_desc})." if cinema_profile.present?

    favs = favorite_genres&.compact_blank
    prompt_parts << "Adore : #{favs.join(', ')}." if favs.present?

    dislikes = disliked_genres&.compact_blank
    prompt_parts << "Déteste ou souhaite éviter : #{dislikes.join(', ')}." if dislikes.present?

    self.user_prompt = prompt_parts.join(" ")
  end
end
