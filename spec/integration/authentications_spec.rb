require 'rails_helper'

RSpec.describe "Authentication", type: :feature do
  describe "guest login" do
    it "login using google" do
      visit root_path
      expect(User.count).to eq(0)

      click_on "Login with Google"

      expect(User.count).to eq(1)
      expect(current_path).to eq(placer_path)
      expect(page).to have_content "Logout"
    end
  end

  describe "guest logout" do
    it "returns to login page" do
      visit root_path
      click_on "Login with Google"

      click_on "Logout"
      expect(current_path).to eq(root_path)
    end
  end
end
