require 'spec_helper'

feature "setting locale" do
  background do
    I18n.locale = I18n.default_locale
    I18n.backend.store_translations(:fr,
     spree: {
       cart: "Panier",
       shopping_cart: "Panier"
    })
    Spree::Frontend::Config[:locale] = :fr
  end

  after do
    I18n.locale = I18n.default_locale
    Spree::Frontend::Config[:locale] = :en
  end

  scenario "should be in french" do
    visit spree.root_path
    click_link "Panier"
    page.should have_content("Panier")
  end
end
