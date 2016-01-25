class Person 
  include Neo4j::ActiveNode
  property :name, type: String, index: :exact
  property :born, type: Integer

  include Neo4j::Timestamps # will give model created_at and updated_at timestamps

  validates :name, presence: true, uniqueness: true
  validates :born, numericality: { only_integer: true, allow_nil: true }

  # by default classname is used as label
  # self.mapped_label_name = 'Actor'
  # for multiple labels use inheritance

  has_many :out, :acted_in, model_class: 'Movie', rel_class: 'ActedIn'
  has_many :out, :directed, model_class: 'Movie', rel_class: 'Directed'

end
