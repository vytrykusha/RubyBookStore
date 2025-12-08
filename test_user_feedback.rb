#!/usr/bin/env ruby
require_relative "config/environment"

puts "=" * 60
puts "🔍 Тестування на ваших реальних прикладах"
puts "=" * 60

test_cases = [
  { text: "супер!!", expected: "positive" },
  { text: "нікому не раджу. магазин фуфло.", expected: "negative" },
  { text: "гавно", expected: "negative" }
]

puts "\n📝 Тестування:"
test_cases.each_with_index do |test, idx|
  result = SentimentAnalyzer.analyze(test[:text])
  status = result[:sentiment] == test[:expected] ? "✅" : "❌"

  puts "\n#{idx + 1}. Текст: \"#{test[:text]}\""
  puts "   Очікуване: #{test[:expected].upcase}"
  puts "   Результат: #{result[:sentiment].upcase}"
  puts "   Впевненість: #{(result[:confidence] * 100).round}%"
  puts "   #{status} #{result[:sentiment] == test[:expected] ? 'ПРАВИЛЬНО!' : 'НЕВІРНО!'}"
end

puts "\n" + "=" * 60
