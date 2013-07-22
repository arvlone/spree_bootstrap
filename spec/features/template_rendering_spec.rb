require 'spec_helper'

feature "Template rendering" do
  after do
    Capybara.ignore_hidden_elements = true
  end

  background do
    Capybara.ignore_hidden_elements = false
  end

  context "with layout option set to 'application' in the configuration" do
    background do
      @app_layout = Rails.root.join('app/views/layouts', 'application.html.erb')
      File.open(@app_layout, 'w') do |app_layout|
        app_layout.puts "<html>I am the application layout</html>"
      end
      Spree::Config.set(layout: 'application')
    end

    scenario "should render application layout" do
      visit spree.root_path
      page.should_not have_content("Spree Demo Site")
      page.should have_content("I am the application layout")
    end

    after do
      FileUtils.rm(@app_layout)
    end
  end

  context "without any layout option" do
    scenario "should render default layout" do
      visit spree.root_path
      page.should_not have_content("I am the application layout")
      page.should have_content("Spree Demo Site")
    end
  end
end
