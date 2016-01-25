# How to set up a typical neo4j based rails app

* `rails new app_name -m http://neo4jrb.io/neo4j/neo4j.rb -O`

* `cd app_name`

* `rake neo4j:install[community-latest]` //installs neo4j-community version

* `rake neo4j:start` or `rake neo4j:start[ENVIRONMENT]` or `neo4j:config[ENVIRONMENT,PORT]` //starts neo4j databse server

* `rails g scaffold Person name:string born:integer` // a sample scaffold command

* `rails s` // to start server. access application on localhost:3000/people

* `rake neo4j:shell[development]` // similar to rails dbconsole

* `rails c` // to access rails console

# How to setup rails app with this repo

* `rake neo4j:install[community-latest]`

* `rake neo4j:start[development]`

* `rails s`

* You cab populate `db/seeds.rb` to pupolate some data to play around with sample queries given below


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