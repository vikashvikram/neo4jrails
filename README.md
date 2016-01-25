* `rails new neo4japp -m http://neo4jrb.io/neo4j/neo4j.rb -O`

* `cd neo4japp`

* `rake neo4j:install[community-latest]` //installs neo4j-community version

* `rake neo4j:start` or `rake neo4j:start[ENVIRONMENT]` or `neo4j:config[ENVIRONMENT,PORT]`

* `rails g scaffold Person name:string born:integer`

* `rails g scaffold Movie title:string released:integer`

* `rails s`

localhost:3000/people => MATCH (n:`Person`) RETURN n

app/models/person.rb

uses active node instead of active record to provide ORM

add validations and index

include Neo4j::Timestamps # will give model created_at and updated_at timestamps

make relationships

# sample queries

### directors along with actor names they have worked with

`match (n:Person) -[:DIRECTED]-> () <-[:ACTED_IN]- (a:Person) return n.name, collect(distinct a.name);`

or 

`Person.query_as(:p).match("p -[:DIRECTED]-> () <-[:ACTED_IN]- (a:Person)").return("p.name, collect(distinct a.name)").to_a`

### list of actors with number of times shah rukh khan have worked with

`match (n:Person) -[:ACTED_IN]-> () <-[:ACTED_IN]- (a:Person) where n.name = 'Shah rukh Khan' and not a.name = 'Shah rukh Khan'
return a.name, count(a.name);`

or

`Person.query_as(:p).match("p -[:ACTED_IN]-> () <-[:ACTED_IN]- (a:Person)").where("p.name = 'Shah rukh Khan' and not a.name = 'Shah rukh Khan'").return("a.name, count(a.name)").to_a`

### list all the directors with whom your peers have worked with but you have not

`match (a:Person) -[:ACTED_IN]-> () <-[:ACTED_IN]- (b:Person), (b:Person) -[:ACTED_IN]-> () <-[:DIRECTED]- (c:Person)
where not a.name = b.name and not (a:Person) -[:ACTED_IN]-> () <-[:DIRECTED]- (c:Person) return a.name, collect(distinct c.name);`

or 

`Person.query_as(:a).match("a -[:ACTED_IN]-> () <-[:ACTED_IN]- (b:Person), (b:Person) -[:ACTED_IN]-> () <-[:DIRECTED]- (c:Person)").where("not a.name = b.name and not (a:Person) -[:ACTED_IN]-> () <-[:DIRECTED]- (c:Person)").return("a.name, collect(distinct c.name)").to_a`

### suggest shah rukh khan which directors he should work with

`match (a:Person) -[:ACTED_IN]-> () <-[:ACTED_IN]- (b:Person), (b:Person) -[:ACTED_IN]-> () <-[:DIRECTED]- (c:Person)
where not a.name = b.name and not (a:Person) -[:ACTED_IN]-> () <-[:DIRECTED]- (c:Person)  and a.name = 'Shah rukh Khan' return c.name, count(c.name);`

or

`Person.query_as(:a).match("a -[:ACTED_IN]-> () <-[:ACTED_IN]- (b:Person), (b:Person) -[:ACTED_IN]-> () <-[:DIRECTED]- (c:Person)").where("not a.name = b.name and not (a:Person) -[:ACTED_IN]-> () <-[:DIRECTED]- (c:Person)  and a.name = 'Shah rukh Khan'").return("c.name, count(c.name)").order("count(c.name) desc").to_a`