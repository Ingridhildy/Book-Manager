class Book < ApplicationRecord
  # ── Асоціації ──────────────────────────────────────────────────────────────

  belongs_to :user
  belongs_to :genre, optional: true

  has_many :authors,   dependent: :destroy
  has_many :taggings,  dependent: :destroy
  has_many :tags,      through: :taggings

  # Бонус: колаборатори
  has_many :collaborations, dependent: :destroy
  has_many :collaborators,  through: :collaborations, source: :user

  # ── Enum ───────────────────────────────────────────────────────────────────

  enum :status, { want_to_read: 0, reading: 1, read: 2 }

  # ── Scopes (з Лабораторної №5) ─────────────────────────────────────────────

  scope :read_books,      -> { where(status: :read) }
  scope :planned,         -> { where(status: :want_to_read) }
  scope :highly_rated,    -> { where("rating >= ?", 8) }
  scope :recent_5_years,  -> { where("published_date >= ?", 5.years.ago) }

  # ── Валідації ──────────────────────────────────────────────────────────────

  validates :title,          presence: true,
                             length: { minimum: 3, maximum: 200 }

  validates :pages,          numericality: { only_integer: true,
                                             greater_than: 0,
                                             less_than_or_equal_to: 10_000 },
                             allow_nil: true

  validates :rating,         numericality: { greater_than_or_equal_to: 0,
                                             less_than_or_equal_to: 10 },
                             allow_nil: true

  validates :status,         presence: true
  validates :published_date, presence: true

  validate :published_date_not_in_future

  private

  def published_date_not_in_future
    return unless published_date.present?

    if published_date > Date.today
      errors.add(:published_date, "не може бути у майбутньому")
    end
  end
end
