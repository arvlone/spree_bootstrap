require 'spec_helper'

feature "Cart" do
  scenario "shows cart icon on non-cart pages" do
    visit spree.root_path
    expect { find("li#link-to-cart a") }.not_to raise_error
  end

  scenario "hides cart icon on cart page" do
    visit spree.cart_path
    expect { find("li#link-to-cart a") }.to raise_error
  end

  scenario "prevents double clicking the remove button on cart", js: true do
    @product = create(:product, name: "RoR Mug")

    visit spree.root_path
    click_link "RoR Mug"
    click_button "add-to-cart-button"

    # prevent form submit to verify button is disabled
    page.execute_script("$('#update-cart').submit(function(){return false;})")

    page.should_not have_selector("button#update-button[disabled]")
    page.find(:css, ".delete img").click
    page.should have_selector("button#update-button[disabled]")
  end

  # Regression test for #2006
  scenario "does not error out with a 404 when GET'ing to /orders/populate" do
    visit "/orders/populate"
    within(".error") do
      page.should have_content(Spree.t(:populate_get_error))
    end
  end

  scenario "allows you to remove an item from the cart", js: true do
    create(:product, name: "RoR Mug")
    visit spree.root_path
    click_link "RoR Mug"
    click_button "add-to-cart-button"
    within("#line_items") do
      click_link "delete_line_item_1"
    end
    page.should_not have_content("Line items quantity must be an integer")
  end

  # regression for #2276
  context "product contains variants but no option values" do
    given(:variant) { create(:variant) }
    given(:product) { variant.product }

    background { variant.option_values.destroy_all }

    scenario "still adds product to cart" do
      visit spree.product_path(product)
      click_button "add-to-cart-button"

      visit spree.cart_path
      page.should have_content(product.name)
    end
  end
end
