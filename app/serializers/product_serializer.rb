class ProductSerializer < ActiveModel::Serializer
  embed :ids, include: true
  
  attributes :id, :name, :code, :description

  has_many :product_categories
end
