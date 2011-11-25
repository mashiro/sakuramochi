RSpec::Matchers.define :be_match_all do |expected|
  match do |actuals|
    actuals.all? { |actual| !!(actual =~ expected) }
  end
end
