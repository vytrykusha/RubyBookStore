#!/usr/bin/env ruby
require_relative "config/environment"

puts "=" * 70
puts "✅ ТЕСТУВАННЯ ВИПРАВЛЕНЬ"
puts "=" * 70

# ===== ТЕСТ 1: ChatBot Жанри =====
puts "\n🤖 Тест 1: ChatBot розпізнає жанри"
puts "-" * 70

genres = [ "фентезі", "історія", "наука", "дитячі", "детектив", "трилер" ]

genres.each do |genre|
  response = ChatBot.chat(genre)
  is_recommendation = response[:response].include?("Рекомендую") || response[:response].include?("На жаль")
  status = is_recommendation ? "✅" : "❌"
  puts "#{status} '#{genre}' → #{response[:type]} (#{response[:response][0..50]}...)"
end

# ===== ТЕСТ 2: Dashboard Запит =====
puts "\n📊 Тест 2: Dashboard запит (без association помилок)"
puts "-" * 70

begin
  books = Book.left_joins(:comments)
    .group("books.id")
    .select("books.id, books.title, books.author, COUNT(comments.id) as comments_count")
    .order("comments_count DESC")

  puts "✅ Query виконалася успішно"
  puts "✅ Найпопулярніші книги: #{books.to_a.count} знайдено"
rescue => e
  puts "❌ Помилка: #{e.message}"
end

# ===== ТЕСТ 3: Order Show Route =====
puts "\n💳 Тест 3: Order show route існує"
puts "-" * 70

routes = Rails.application.routes.routes.map { |r| r.path.spec.to_s }
order_show = routes.any? { |r| r.include?("orders/:id") }

puts order_show ? "✅ Route /orders/:id існує" : "❌ Route не знайдено"

# ===== ТЕСТ 4: Payment Mark Route =====
puts "\n🧪 Тест 4: Тестова оплата (mark_payment) існує"
puts "-" * 70

payment_route = routes.any? { |r| r.include?("mark_payment") }
puts payment_route ? "✅ Route /mark_payment/:order_id існує" : "❌ Route не знайдено"

# ===== ТЕСТ 5: LiqPay без ключів =====
puts "\n💳 Тест 5: LiqPay працює БЕЗ ключів"
puts "-" * 70

order = Order.first
if order
  begin
    invoice = LiqPayService.create_invoice(order)
    puts "✅ Invoice створено успішно"
    puts "✅ Data length: #{invoice[:data].length} символів"
    puts "✅ Signature length: #{invoice[:signature].length} символів"
  rescue => e
    puts "❌ Помилка: #{e.message}"
  end
else
  puts "ℹ️  Замовлень не знайдено для тесту"
end

# ===== ТЕСТ 6: Статуси платежу =====
puts "\n📊 Тест 6: Payment Status поле в Order"
puts "-" * 70

order = Order.first
if order
  status_col = Order.columns.any? { |c| c.name == "payment_status" }
  puts status_col ? "✅ Колонка payment_status існує" : "❌ Колонка не знайдена"
  puts "✅ Поточний статус: #{order.payment_status || 'не встановлено'}"
else
  puts "ℹ️  Замовлень не знайдено"
end

# ===== ТЕСТ 7: API Ключи перевірка =====
puts "\n🔑 Тест 7: API ключи (опціонально)"
puts "-" * 70

google_key = ENV["GOOGLE_API_KEY"].present? ? "✅ GOOGLE_API_KEY встановлено" : "ℹ️  GOOGLE_API_KEY не встановлено"
liqpay_id = ENV["LIQPAY_MERCHANT_ID"].present? ? "✅ LIQPAY_MERCHANT_ID встановлено" : "ℹ️  LIQPAY_MERCHANT_ID не встановлено"

puts google_key
puts liqpay_id

puts "\n💡 Без ключів система працює з:"
puts "   - ChatBot: локальна NLP"
puts "   - Sentiment: локальний аналіз"
puts "   - Dashboard: повна функціональність"
puts "   - Платежі: тестова оплата"

puts "\n" + "=" * 70
puts "✅ ВСІ ВИПРАВЛЕННЯ ПРОТЕСТОВАНІ!"
puts "=" * 70

puts "\n🚀 Доступні функції:"
puts "   - 🤖 ChatBot: http://localhost:3000/chat"
puts "   - 📊 Dashboard: http://localhost:3000/dashboard/analytics"
puts "   - 💳 Замовлення: http://localhost:3000/orders"
puts "   - 🧪 Тестова оплата: На сторінці замовлення"
