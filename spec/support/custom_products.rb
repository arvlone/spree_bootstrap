shared_context "custom products" do
  before do
    taxonomy = create(:taxonomy, name: 'Categories')
    root = taxonomy.root
    clothing_taxon = create(:taxon, name: 'Clothing', parent_id: root.id)
    bags_taxon = create(:taxon, name: 'Bags', parent_id: root.id)
    mugs_taxon = create(:taxon, name: 'Mugs', parent_id: root.id)

    taxonomy = create(:taxonomy, name: 'Brands')
    root = taxonomy.root
    apache_taxon = create(:taxon, name: 'Apache', parent_id: root.id)
    rails_taxon = create(:taxon, name: 'Ruby on Rails', parent_id: root.id)
    ruby_taxon = create(:taxon, name: 'Ruby', parent_id: root.id)

    create(:custom_product, name: 'Ruby on Rails Ringer T-Shirt', price: '19.99', taxons: [rails_taxon, clothing_taxon])
    create(:custom_product, name: 'Ruby on Rails Mug', price: '15.99', taxons: [rails_taxon, mugs_taxon])
    create(:custom_product, name: 'Ruby on Rails Tote', price: '15.99', taxons: [rails_taxon, bags_taxon])
    create(:custom_product, name: 'Ruby on Rails Bag', price: '22.99', taxons: [rails_taxon, bags_taxon])
    create(:custom_product, name: 'Ruby on Rails Baseball Jersey', price: '19.99', taxons: [rails_taxon, clothing_taxon])
    create(:custom_product, name: 'Ruby on Rails Stein', price: '16.99', taxons: [rails_taxon, mugs_taxon])
    create(:custom_product, name: 'Ruby on Rails Jr. Spaghetti', price: '19.99', taxons: [rails_taxon, clothing_taxon])
    create(:custom_product, name: 'Ruby Baseball Jersey', price: '19.99', taxons: [ruby_taxon, clothing_taxon])
    create(:custom_product, name: 'Apache Baseball Jersey', price: '19.99', taxons: [apache_taxon, clothing_taxon])
  end
end
