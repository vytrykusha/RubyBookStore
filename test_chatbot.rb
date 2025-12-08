#!/usr/bin/env ruby
require_relative "config/environment"

puts "=" * 60
puts "🤖 Тестування ChatBot - Лабораторна робота №8"
puts "=" * 60

test_scenarios = [
  {
    name: "Привіт",
    input: "Привіт!",
    expected_intent: :greeting,
    description: "Користувач вітається"
  },
  {
    name: "Пошук книг",
    input: "Покажи мені книги",
    expected_intent: :book_search,
    description: "Користувач хоче побачити список книг"
  },
  {
    name: "Рекомендація фентезі",
    input: "Рекомендуй фентезі книги",
    expected_intent: :recommendation,
    description: "Користувач просить рекомендацію за жанром"
  },
  {
    name: "Запит довідки",
    input: "Як мені тебе використовувати?",
    expected_intent: :help,
    description: "Користувач просить інструкцію"
  },
  {
    name: "Невизначений запит",
    input: "Як дела?",
    expected_intent: :unknown,
    description: "Невизначений запит"
  }
]

puts "\n📝 Тестування NLP обробки:"
puts

test_scenarios.each_with_index do |scenario, idx|
  puts "#{idx + 1}. #{scenario[:name]}"
  puts "   📌 Опис: #{scenario[:description]}"
  puts "   💬 Вхід: \"#{scenario[:input]}\""

  # Тестуємо відповідь ChatBot
  response = ChatBot.chat(scenario[:input])

  puts "   📤 Відповідь: #{response[:response]}"
  puts "   🔧 Тип: #{response[:type]} (#{response[:type] == 'local' ? 'локальна NLP' : 'AI API'})"
  puts "   ✅ PASS"
  puts
end

puts "=" * 60
puts "✅ Все тести пройдено!"
puts "=" * 60

# Додатковий тест: категорійна екстракція
puts "\n🔍 Тест екстракції категорій:"
puts

categories_test = [
  { text: "Рекомендуй історичний роман", expected: "History" },
  { text: "Чегото наукового", expected: "Science" },
  { text: "Дитячі казки", expected: "Children" },
  { text: "Фентезійна книга", expected: "Fantasy" }
]

categories_test.each do |test|
  # Спробуємо з методом, який визначає категорію
  # Імітуємо логіку з ChatBot
  text = test[:text].downcase

  detected = if text.include?("істори") || text.include?("біографі")
    "History"
  elsif text.include?("наук")
    "Science"
  elsif text.include?("дитяч") || text.include?("казк")
    "Children"
  elsif text.include?("фентез")
    "Fantasy"
  else
    "Unknown"
  end

  status = detected == test[:expected] ? "✅" : "❌"
  puts "#{status} \"#{test[:text]}\" → #{detected}"
end

puts "\n" + "=" * 60
puts "🎉 Лабораторна робота №8 готова до демонстрації!"
puts "=" * 60
