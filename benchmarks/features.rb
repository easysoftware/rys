FEATURES_COUNT = 10_000
LEVELS_COUNT = 5
TEST_COUNT = 10

all_keys = []


# =============================================================================
# Easy::Feature.add

puts ">> Testing: Easy::Feature.add"

t = Time.now
1.upto(FEATURES_COUNT) do |i|
  key = (["key_#{i}"] * LEVELS_COUNT).join('.')
  all_keys << key

  Easy::Feature.add(key) do
    rand > 0.5
  end
end
t = Time.now - t

puts "   #{all_keys.size} keys added in #{t.round(2)}s"
puts


# =============================================================================
# Easy::Feature.active?

puts ">> Testing: Easy::Feature.active?"

t = Time.now
TEST_COUNT.times do
  all_keys.each do |key|
    Easy::Feature.active?(key)
  end
end
t = Time.now - t

puts "   #{TEST_COUNT * all_keys.size} active? was done in #{t.round(2)}s"
