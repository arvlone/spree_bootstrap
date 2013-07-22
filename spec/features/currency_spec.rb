require 'spec_helper'

feature "Switching currencies in backend" do
  background { create(:base_product, name: "RoR Mug") }

  # Regression test for #2340
  scenario "does not cause current_order to become nil" do
    visit spree.root_path
    click_link "RoR Mug"
    click_button "Add To Cart"
    # Now that we have an order...
    Spree::Config[:currency] = "AUD"
    expect { visit spree.root_path }.not_to raise_error
  end
end
