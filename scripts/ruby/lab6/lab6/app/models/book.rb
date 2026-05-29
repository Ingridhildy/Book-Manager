class Book < ApplicationRecord
  # ── Асоціації ──────────────────────────────────────────────────────────────

  # Частина 1: belongs_to замість рядкового поля genre
  belongs_to :genre, optional: true

  # Частина 2: has_many авторів (з Лабораторної №5)
  has_many :authors, dependent: :destroy

  # Частина 3: many-to-many з тегами через проміжну таблицю
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  # ── Enum статусу ───────────────────────────────────────────────────────────

  enum :status, { want_to_read: 0, reading: 1, read: 2 }

  # ── Валідації ──────────────────────────────────────────────────────────────

  # Частина 4: валідації основної моделі
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

  # Кастомна валідація: дата публікації не може бути у майбутньому
  validate :published_date_not_in_future

  private

  def published_date_not_in_future
    return unless published_date.present?

    if published_date > Date.today
      errors.add(:published_date, "не може бути у майбутньому")
    end
  end
end
