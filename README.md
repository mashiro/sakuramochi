# Sakuramochi
[![Build Status](https://secure.travis-ci.org/mashiro/sakuramochi.png)](http://travis-ci.org/mashiro/sakuramochi)
[![Dependency Status](https://gemnasium.com/mashiro/sakuramochi.png)](https://gemnasium.com/mashiro/sakuramochi)

Sakuramochi is a minimal extensions for Active Record 3.

This is similar to the ar-extensions gem.

## Installation

```ruby
gem 'sakuramochi'
# gem 'sakuramochi', :git => 'git://github.com/mashiro/sakuramochi.git'
```

## Getting started

```ruby
User.where(:name_contains => 'ai')
# => "SELECT "users".* FROM "users"  WHERE ("users"."name" LIKE '%ai%')"

User.where(:name_contains_any => ['ru', 'ai'])
# => "SELECT "users".* FROM "users"  WHERE (("users"."name" LIKE '%ru%' OR "users"."name" LIKE '%ai%'))"

User.where(:name_contains_all => ['ru', 'ai'])
# => "SELECT "users".* FROM "users"  WHERE (("users"."name" LIKE '%ru%' AND "users"."name" LIKE '%ai%'))"
```

## Predicates

* contains
* starts_with, start_with
* ends_with, end_with
* in
* eq, equal, equals
* gt
* gte, gteq
* lt
* lte, lteq

## Conditions
```
expression = term {("and"|"or") term}
term = ["not"] factor
factor = array | hash | "(" expression ")"
```

``` ruby
User.where([{:name_contains => 'harune'}, :and, {:name_contains => 'aira'}]) 
# => "SELECT "users".* FROM "users"  WHERE (("users"."name" LIKE '%harune%') AND ("users"."name" LIKE '%aira%'))"

User.where([:not, {:name_end_with => "mion"}])
# => SELECT "users".* FROM "users" WHERE (NOT (("users"."name" LIKE '%mion')))

User.where([:not, :'(', {:name_contains => 'aira'}, :or, {:name_contains => 'rizumu'}, :')', :and, {:age_gte => 14}])
# => SELECT "users".* FROM "users" WHERE (NOT ((("users"."name" LIKE '%aira%') OR ("users"."name" LIKE '%rizumu%'))) AND ("users"."age" >= 14))
```

## Configration

```ruby
Sakuramochi.configure do |config|
  # simple
  config.add :eq_amamiya,
    :arel_predicate => :eq,
    :converter => proc { |v| "amamiya #{v}" }

  # advanced
  config.add :surrounds_with, :surrounds_with_alias,
    :arel_predicate => :matches,
    :grouping => true,
    :expand => false,
    :converter => proc { |v| "#{v.first}%#{v.last}" },
    :validator => proc { |v| v.is_a?(Enumerable) && v.to_a.size == 2 }
end

User.where(:name_eq_amamiya => 'rizumu')
# => "SELECT "users".* FROM "users"  WHERE "users"."name" = 'amamiya rizumu'"

User.where(:name_surrounds_with => ["ama", "umu"])
# => "SELECT "users".* FROM "users"  WHERE ("users"."name" LIKE 'ama%umu')"
```

## Copyright

Copyright (c) 2011 mashiro
