# Sakuramochi

Sakuramochi is a minimal active record extensions for Rails3.

## Installation

```ruby
gem 'sakuramochi'
# gem 'sakuramochi', :git => 'git://github.com/mashiro/sakuramochi.git'
```

## Getting started

```ruby
User.where(:name_contains => 'ai')
# => "SELECT \"users\".* FROM \"users\"  WHERE (\"users\".\"name\" LIKE '%ai%')"

User.where(:name_contains_any => ['ru', 'ai'])
# => "SELECT \"users\".* FROM \"users\"  WHERE ((\"users\".\"name\" LIKE '%ru%' OR \"users\".\"name\" LIKE '%ai%'))"

User.where(:name_contains_all => ['ru', 'ai'])
# => "SELECT \"users\".* FROM \"users\"  WHERE ((\"users\".\"name\" LIKE '%ru%' AND \"users\".\"name\" LIKE '%ai%'))"
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
    :validator => proc { |v| true || v.is_a?(Enumerable) && v.to_a.size == 2 }
end

User.where(:name_eq_amamiya => 'rizumu')
# => "SELECT \"users\".* FROM \"users\"  WHERE \"users\".\"name\" = 'amamiya rizumu'"

User.where(:name_surrounds_with => ["ama", "umu"])
# => "SELECT \"users\".* FROM \"users\"  WHERE (\"users\".\"name\" LIKE 'ama%umu')"
```

## Copyright

Copyright (c) 2011 mashiro

