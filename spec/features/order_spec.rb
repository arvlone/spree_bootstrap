require 'spec_helper'

feature "orders" do
  given(:order) { OrderWalkthrough.up_to(:complete) }
  given(:user) { create(:user) }

  background do
    order.update_attribute(:user_id, user.id)
    order.shipments.destroy_all
    Spree::OrdersController.any_instance.stub(try_spree_current_user: user)
  end

  it "can visit an order" do
    # Regression test for current_user call on orders/show
    expect { visit spree.order_path(order) }.not_to raise_error
  end

  scenario "should display line item price" do
    # Regression test for #2772
    line_item = order.line_items.first
    line_item.target_shipment = create(:shipment)
    line_item.price = 19.00
    line_item.save!

    visit spree.order_path(order)

    # Tests view spree/shared/_order_details
    within "td.price" do
      page.should have_content "19.00"
    end
  end

  scenario "should have credit card info if paid with credit card" do
    create(:payment, order: order)
    visit spree.order_path(order)
    within ".payment-info" do
      page.should have_content "Ending in 1111"
    end
  end

  scenario "should have payment method name visible if not paid with credit card" do
    create(:check_payment, order: order)
    visit spree.order_path(order)
    within ".payment-info" do
      page.should have_content "Check"
    end
  end

  # Regression test for #2282
  context "can support a credit card with blank information" do
    background do
      credit_card = create(:credit_card)
      credit_card.update_column(:cc_type, "")
      payment = order.payments.first
      payment.source = credit_card
      payment.save!
    end

    scenario do
      visit spree.order_path(order)
      within ".payment-info" do
        expect { find("img") }.to raise_error
      end
    end
  end
end
