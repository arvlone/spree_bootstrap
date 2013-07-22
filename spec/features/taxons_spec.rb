require 'spec_helper'

feature "Viewing products" do
  given!(:taxonomy) { create(:taxonomy, name: "Category") }
  given!(:super_clothing) { taxonomy.root.children.create(name: "Super Clothing") }
  given!(:t_shirts) { super_clothing.children.create(name: "T-Shirts") }
  given!(:xxl) { t_shirts.children.create(name: "XXL") }
  given!(:product) do
    product = create(:product, name: "Superman T-Shirt")
    product.taxons << t_shirts
  end
  given(:metas) { { meta_description: 'Brand new Ruby on Rails TShirts', meta_title: "Ruby On Rails TShirt", meta_keywords: "ror, tshirt, ruby" } }

  # Regression test for #1796
  scenario "can see a taxon's products, even if that taxon has child taxons" do
    visit "/t/category/super-clothing/t-shirts"
    page.should have_content("Superman T-Shirt")
  end

  scenario "shouldn't show nested taxons with a search" do
    visit "/t/category/super-clothing?keywords=shirt"
    page.should have_content("Superman T-Shirt")
    page.should_not have_selector("div[data-hook='taxon_children']")
  end

  context "meta tags and title" do
    after do
      Capybara.ignore_hidden_elements = true
    end

    background do
      Capybara.ignore_hidden_elements = false
    end

    scenario "displays metas" do
      t_shirts.update_attributes metas
      visit "/t/category/super-clothing/t-shirts"
      page.should have_meta(:description, "Brand new Ruby on Rails TShirts")
      page.should have_meta(:keywords, "ror, tshirt, ruby")
    end

    scenario "display title if set" do
      t_shirts.update_attributes metas
      visit "/t/category/super-clothing/t-shirts"
      page.should have_title("Ruby On Rails TShirt")
    end

    scenario "display title from taxon root and taxon name" do
      visit '/t/category/super-clothing/t-shirts'
      page.should have_title('Category - T-Shirts - Spree Demo Site')
    end

    # Regression test for #2814
    scenario "doesn't use meta_title as heading on page" do
      t_shirts.update_attributes metas
      visit '/t/category/super-clothing/t-shirts'
      within("h1.taxon-title") do
        page.should have_content(t_shirts.name)
      end
    end
  end

  context "taxon pages" do
    include_context "custom products"

    background do
      visit spree.root_path
    end

    scenario "should be able to visit brand Ruby on Rails" do
      within(:css, '#taxonomies') { click_link "Ruby on Rails" }

      page.all("ul.product-listing li").size.should == 7
      tmp = page.all("ul.product-listing li a").map(&:text).flatten.compact
      tmp.delete("")
      array = ["Ruby on Rails Bag",
       "Ruby on Rails Baseball Jersey",
       "Ruby on Rails Jr. Spaghetti",
       "Ruby on Rails Mug",
       "Ruby on Rails Ringer T-Shirt",
       "Ruby on Rails Stein",
       "Ruby on Rails Tote"]
      tmp.sort!.should == array
    end

    scenario "should be able to visit brand Ruby" do
      within(:css, "#taxonomies") { click_link "Ruby" }

      page.all("ul.product-listing li").size.should == 1
      tmp = page.all("ul.product-listing li a").map(&:text).flatten.compact
      tmp.delete("")
      tmp.sort!.should == ["Ruby Baseball Jersey"]
    end

    scenario "should be able to visit brand Apache" do
      within(:css, "#taxonomies") { click_link "Apache" }

      page.all("ul.product-listing li").size.should == 1
      tmp = page.all("ul.product-listing li a").map(&:text).flatten.compact
      tmp.delete("")
      tmp.sort!.should == ["Apache Baseball Jersey"]
    end

    scenario "should be able to visit category Clothing" do
      click_link "Clothing"

      page.all("ul.product-listing li").size.should == 5
      tmp = page.all("ul.product-listing li a").map(&:text).flatten.compact
      tmp.delete("")
      tmp.sort!.should == ["Apache Baseball Jersey",
     "Ruby Baseball Jersey",
     "Ruby on Rails Baseball Jersey",
     "Ruby on Rails Jr. Spaghetti",
     "Ruby on Rails Ringer T-Shirt"]
    end

    scenario "should be able to visit category Mugs" do
      click_link "Mugs"

      page.all("ul.product-listing li").size.should == 2
      tmp = page.all("ul.product-listing li a").map(&:text).flatten.compact
      tmp.delete("")
      tmp.sort!.should == ["Ruby on Rails Mug", "Ruby on Rails Stein"]
    end

    scenario "should be able to visit category Bags" do
      click_link "Bags"

      page.all("ul.product-listing li").size.should == 2
      tmp = page.all("ul.product-listing li a").map(&:text).flatten.compact
      tmp.delete("")
      tmp.sort!.should == ["Ruby on Rails Bag", "Ruby on Rails Tote"]
    end
  end
end
