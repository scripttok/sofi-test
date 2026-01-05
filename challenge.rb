# ----------------- Implementation (TODO) -----------------
# TODO: Implement the method below.
# ----------------- Color helpers -----------------
def green(t)  = "\e[32m#{t}\e[0m"
def red(t)    = "\e[31m#{t}\e[0m"
def yellow(t) = "\e[33m#{t}\e[0m"
# ----------------- Test helpers -----------------
def normalize(groups)
  groups.map { |g| g.sort }.sort_by { |g| g.first.to_s }
end
def assert_eq(actual, expected, msg = nil)
  if actual != expected
    puts red(":x_vermelho: #{msg}")
    puts red("   Expected: #{expected.inspect}")
    puts red("   Actual:   #{actual.inspect}")
    raise 'Test failed'
  else
    puts green(":marca_de_verificação_branca: #{msg}")
  end
end
def assert_raises(error_class, msg = nil)
  raised = false
  begin
    yield
  rescue => e
    raised = e.is_a?(error_class)
    if raised
      puts green(":marca_de_verificação_branca: #{msg}")
    else
      puts red(":x_vermelho: #{msg}")
      puts red("   Expected #{error_class}, got #{e.class}: #{e.message}")
      raise "Test failed"
    end
  end
  unless raised
    puts red(":x_vermelho: #{msg}")
    puts red("   Expected #{error_class}, but no exception was raised")
    raise "Test failed"
  end
end
# ----------------- Tests -----------------
puts yellow("\nRunning tests for group_by_prefix...\n\n")
begin
  # 1) Basic case (fixed to 'bank' + 'banana' -> 'ba' for n=2)
  words = %w[car cart cat bank banana]
  res = group_by_prefix(words, 2)
  assert_eq(normalize(res), normalize([%w[car cart cat], %w[bank banana]]), "Group by prefix of 2")
  # 2) Ignore words shorter than n
  words = %w[a an ana arbor ar]
  res = group_by_prefix(words, 3)
  assert_eq(normalize(res), normalize([%w[ana], %w[arbor]]), "Ignore words < n")
  # 3) Case-insensitive grouping (adjusted to share 3-letter prefixes)
  words = ["Home", "homerun", "HOST", "hostel"] # 'hom' and 'hos'
  res = group_by_prefix(words, 3)
  assert_eq(normalize(res), normalize([["Home", "homerun"], ["HOST", "hostel"]]), "Case-insensitive / keep originals")
  # 4) Empty list
  assert_eq(group_by_prefix([], 2), [], "Empty list -> []")
  # 5) n = 1 (group by first letter)
  words = %w[ball bank cat car dog dice]
  res = group_by_prefix(words, 1)
  assert_eq(normalize(res), normalize([%w[ball bank], %w[cat car], %w[dog dice]]), "n=1 groups by first letter")
  # 6) n larger than all words -> []
  words = %w[go ruby]
  assert_eq(group_by_prefix(words, 10), [], "n > all lengths -> []")
  # 7) Non-string elements should be ignored
  words = ["car", :house, nil, "cave", 123, "card"]
  res = group_by_prefix(words, 2)
  assert_eq(normalize(res), normalize([%w[car cave card]]), "Ignore non-strings")
  # 8) Validation: n <= 0 raises ArgumentError
  assert_raises(ArgumentError, "n <= 0 should fail") { group_by_prefix(%w[car cat], 0) }
  assert_raises(ArgumentError, "n < 0 should fail")  { group_by_prefix(%w[car cat], -2) }
  # 9) Validation: words not an Array raises ArgumentError
  assert_raises(ArgumentError, "words not Array should fail") { group_by_prefix("car", 2) }
  puts green("\n:confete_e_serpentina: All tests passed successfully!\n")
rescue NotImplementedError => e
  puts yellow(":atenção:  #{e.message}")
  puts yellow("   Hint: create a Hash keyed by prefix = word[0, n].downcase,")
  puts yellow("   push each valid word into that bucket, and return hash.values")
  puts yellow("   (ignore non-strings and words shorter than n; validate args).")
end
