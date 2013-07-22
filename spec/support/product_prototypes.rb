shared_context "product prototype" do
  def build_option_type_with_values(name, values)
    ot = create(:option_type, name: name)
    values.each do |val|
      ot.option_values.create({name: val.downcase, presentation: val}, without_protection: true)
    end
    ot
  end

  given(:product_attributes) do
    attributes_for(:base_product)
  end

  given(:prototype) do
    size = build_option_type_with_values("size", %w(Small Medium Large))
    create(:prototype, name: "Size", option_types: [size])
  end

  given(:option_values_hash) do
    hash = {}
    prototype.option_types.each do |i|
      hash[i.id.to_s] = i.option_value_ids
    end
    hash
  end
end
