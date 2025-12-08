#!/usr/bin/env ruby
# test_sentiment.rb - Простий тест для перевірки системи аналізу тональності

# Завантажимо Rails
require_relative 'config/environment'

puts "=" * 60
puts "🤖 Тест системи аналізу тональності коментарів"
puts "=" * 60

# Тестові коментарі
test_comments = [
  { text: "Чудова книга! Мені дуже сподобалась. Рекомендую всім!", expected: "positive" },
  { text: "Жахливо. Не подобається взагалі. Не рекомендую.", expected: "negative" },
  { text: "Це книга про історію. Має 200 сторінок.", expected: "neutral" },
  { text: "Супер! Дивовижна робота автора! 😊", expected: "positive" },
  { text: "Скучна і нудна. Бачив гірше.", expected: "negative" }
]

puts "\n📝 Тестування аналізу тональності:\n"

test_comments.each_with_index do |test, index|
  puts "#{index + 1}. Текст: \"#{test[:text]}\""

  result = SentimentAnalyzer.analyze(test[:text])

  puts "   Результат: #{result[:sentiment].upcase}"
  puts "   Впевненість: #{(result[:confidence] * 100).round(0)}%"
  puts "   Метод: #{result[:method] || 'API'}"

  if result[:sentiment] == test[:expected]
    puts "   ✅ ПРАВИЛЬНО!"
  else
    puts "   ⚠️  Очікувалось: #{test[:expected]}"
  end
  puts
end

puts "=" * 60
puts "✅ Тест завершено!"
puts "=" * 60
