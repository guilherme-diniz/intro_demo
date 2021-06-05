class Array
  def to_serialized_offer(label)
    map do |item|
      Offer.new(id: item['id'], price: item['price'],
                company: item['request_company']['name']).serialize(label)
    end
  end

  def sort_by_price(ascending)
    sort do |a, b|
      ascending ? a['price'] - b['price'] : b['price'] - a['price']
    end
  end
end
