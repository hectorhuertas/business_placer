require 'rails_helper'

RSpec.describe "Authorization", type: :feature do
  context "guest visits main page" do
    it "is redirected to login page" do
      visit root_path

      expect(current_path).to eq(login_path)
      expect(page).to_not have_content "Logout"
    end
  end

  context "user visits main page" do
    it "sees the page" do
      user = User.create(name: "Peter")
      allow_any_instance_of(ApplicationController)
        .to receive(:current_user)
        .and_return(user)

      visit root_path

      expect(current_path).to eq(root_path)
      expect(page).to have_content "Logout"
    end
  end
end
