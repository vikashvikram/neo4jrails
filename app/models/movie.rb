class Movie 
  include Neo4j::ActiveNode
  property :title, type: String, index: :exact #,constraint: :unique
  property :released, type: Integer

  include Neo4j::Timestamps # will give model created_at and updated_at timestamps

  validates :title, presence: true, uniqueness: true
  validates :released, numericality: { only_integer: true }

  has_many :in, :actors, model_class: 'Person', rel_class: 'ActedIn'
  has_many :in, :directors, model_class: 'Person', rel_class: 'Directed'

end
