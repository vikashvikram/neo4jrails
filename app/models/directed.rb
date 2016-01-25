class Directed
  include Neo4j::ActiveRel

  from_class 'Person'
  to_class 'Movie'
  type 'DIRECTED'
end