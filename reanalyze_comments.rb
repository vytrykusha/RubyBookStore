#!/usr/bin/env ruby
require_relative "config/environment"

puts "🔄 Перепроаналізовуємо всі коментарі..."

Comment.find_each do |comment|
  result = SentimentAnalyzer.analyze(comment.content)
  old_sentiment = comment.sentiment
  comment.update(sentiment: result[:sentiment])

  if old_sentiment != result[:sentiment]
    puts "  ✅ ID ##{comment.id}: '#{comment.content.truncate(40)}' - #{old_sentiment} → #{result[:sentiment]}"
  end
end

puts "\n✅ Перепроаналіз завершено!"
puts "\nСтатистика:"
puts "  Позитивних: #{Comment.where(sentiment: 'positive').count}"
puts "  Негативних: #{Comment.where(sentiment: 'negative').count}"
puts "  Нейтральних: #{Comment.where(sentiment: 'neutral').count}"
