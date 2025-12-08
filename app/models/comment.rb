class Comment < ApplicationRecord
  belongs_to :book
  validates :content, presence: true

  before_save :analyze_sentiment, if: :content_changed?

  enum sentiment: { positive: "positive", negative: "negative", neutral: "neutral" }, _default: "neutral"

  private

  def analyze_sentiment
    result = SentimentAnalyzer.analyze(content)
    self.sentiment = result[:sentiment]
  end
end
