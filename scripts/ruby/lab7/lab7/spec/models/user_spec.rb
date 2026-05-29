require "rails_helper"

RSpec.describe User, type: :model do

  subject(:user) { build(:user) }

  # ── Валідації (Devise::Validatable) ──────────────────────────────────────

  describe "валідація email" do
    it "є валідним з коректним email" do
      expect(user).to be_valid
    end

    it "не валідний без email" do
      user.email = nil
      expect(user).not_to be_valid
    end

    it "не валідний з дублікатом email" do
      create(:user, email: "same@example.com")
      user.email = "same@example.com"
      expect(user).not_to be_valid
    end
  end

  # ── Асоціації ─────────────────────────────────────────────────────────────

  describe "асоціації" do
    it "has_many books" do
      assoc = User.reflect_on_association(:books)
      expect(assoc.macro).to eq(:has_many)
    end

    it "видаляє книги при видаленні користувача (dependent: :destroy)" do
      user  = create(:user)
      _book = create(:book, user: user)

      expect { user.destroy }.to change(Book, :count).by(-1)
    end

    # Бонус: колаборації
    it "has_many collaborations" do
      assoc = User.reflect_on_association(:collaborations)
      expect(assoc.macro).to eq(:has_many)
    end

    it "has_many collaborated_books through collaborations" do
      assoc = User.reflect_on_association(:collaborated_books)
      expect(assoc.macro).to eq(:has_many)
      expect(assoc.options[:through]).to eq(:collaborations)
    end
  end

end
