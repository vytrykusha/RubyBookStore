require "net/http"
require "json"
require "uri"

class SentimentAnalyzer
  API_KEY = ENV["GOOGLE_API_KEY"]

  # URL для Google Generative AI API
  GOOGLE_AI_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent"

  # Позитивні ключові слова
  POSITIVE_KEYWORDS = [
    "добре", "чудово", "супер", "відмінно", "прекрасно", "гарно", "дивовижно",
    "подобається", "люблю", "рекомендую", "класно", "екселент", "неймовірно",
    "благодарю", "спасибо", "молодець", "спектакль", "шедевр", "вау", "wow",
    "awesome", "amazing", "great", "excellent", "wonderful", "beautiful", "love",
    "крутой", "потрібно", "таке", "бувати", "рад", "задоволений", "вартар"
  ].freeze

  # Негативні ключові слова (розширений список)
  NEGATIVE_KEYWORDS = [
    # Українська мова - основні терміни
    "погано", "жахливо", "не подобається", "ненавиджу", "скучно", "нудно",
    "гірше", "гавно", "розчаруюча", "не рекомендую", "жах", "беда",
    "сором", "дрегель", "огидно", "жадне", "не варто", "мотлох",
    "фуфло", "фуфлось", "фуфла", "лажа", "хлам", "дрібництво",
    "гавнюка", "гідність", "піді", "ср", "лажавина", "кисло",
    "жалко", "жаль", "сумно", "смерть", "тоскно", "беспросветно",
    "паршиво", "отвратительно", "мерзко", "гадко", "отвратно",
    "кошмарно", "ужасно", "страшно", "видно", "очень плохо",
    "ни в коем случае", "никому не советую", "не нужно",
    # Англійська мова
    "horrible", "awful", "bad", "terrible", "hate", "disgusting", "boring",
    "worst", "hate", "crap", "trash", "garbage", "sucks", "sucked",
    "pathetic", "pathetically", "poor", "poor quality", "low quality",
    "waste", "waste of", "waste of time", "disappointed", "disappointing",
    "don't recommend", "would not recommend", "avoid", "don't buy",
    "не советую", "не рекомендую", "избегайте", "не買", "не буду",
    "раздевать", "раздевает", "не грянул", "вонь", "гадина"
  ].freeze

  # Аналізує тональність тексту
  # Повертає хеш: { sentiment: 'positive'|'negative'|'neutral', confidence: Float }
  def self.analyze(text)
    # Якщо API ключ налаштований - використовуємо API, інакше локальний аналіз
    if API_KEY.present?
      analyze_with_api(text)
    else
      analyze_locally(text)
    end
  end

  private

  def self.analyze_with_api(text)
    begin
      # Промпт для аналізу тональності
      prompt = <<~TEXT
        Проаналізуй тональність наступного тексту. Відповідь повинна бути ТІЛЬКИ одним словом з трьох варіантів:
        - "positive" (позитивна)
        - "negative" (негативна)#{'  '}
        - "neutral" (нейтральна)

        Текст: "#{text}"

        Відповідь:
      TEXT

      response = send_request(prompt)

      if response.is_a?(Net::HTTPSuccess)
        sentiment_text = extract_sentiment(response.body)
        { sentiment: sentiment_text, confidence: 0.8 }
      else
        # Якщо API повернув помилку - переходимо на локальний аналіз
        analyze_locally(text)
      end
    rescue StandardError => e
      Rails.logger.error("SentimentAnalyzer API error: #{e.message}")
      # При помилці - повертаємось на локальний аналіз
      analyze_locally(text)
    end
  end

  def self.analyze_locally(text)
    text_lower = text.downcase.strip

    # Лічимо відповідання ключевих слів
    positive_count = POSITIVE_KEYWORDS.count { |keyword| text_lower.include?(keyword) }
    negative_count = NEGATIVE_KEYWORDS.count { |keyword| text_lower.include?(keyword) }

    # Додатково перевіряємо за регулярними виразами для словоформ
    # Негативні патерни
    negative_patterns = [
      /\bне\s+(?:подоб|рад|хоч|гайд|буд)\w*/i,        # не подобається, не радо
      /\b(?:гавно|гавн|гавнюк)\w*/i,                  # гавно, гавнюка
      /\b(?:фуфл|лаж|хлам|дріб|кис)\w*/i,             # фуфло, лажа, хлам
      /\b(?:отврат|кошмар|жах|смерт|тоск)\w*/i,       # отвратно, кошмарно
      /\bніком[уи].*(?:не|ні).*(?:рад|совет|бер)\w*/i, # нікому не раджу
      /\bніком[уи]\b.*\bне\b.*\b(?:рад|совет|бер)\b/i, # нікому не раджу (альтернатива)
      /\b(?:не советую|не рекомендую)\b/i,
      /\bне.*советую/i,                                # не радо + варіації
      /\bне.*рекомендую/i,
      /\b(?:очень\s+)?(?:плохо|гадко|мерзко|вонь)\w*/i,
      /\b(?:раздева|раздев|гадина)\w*/i,
      /(?:!!!|!!|……|\.\.\.)\s*(?:плохо|гавно|фуфло|лажа|хлам)/i,  # емоційні символи + лайки
      /\bмагазин\s+(?:фуфл|лаж|хлам|срача)/i          # магазин фуфло/лажа тощо
    ]

    # Перевіряємо негативні патерни
    negative_patterns.each do |pattern|
      negative_count += 2 if text_lower =~ pattern  # Даємо більший вес регулярним виразам
    end

    # Позитивні патерни
    positive_patterns = [
      /\bсупер\b/i,
      /\b(?:дуже|дуже\s+)?(?:подобається|подобаєтеся)\b/i,
      /\blove\b/i,
      /\b(?:люблю|люблять|люблю+)\w*/i,
      /(?:!!!|!!|\!\!\!)/  # Позитивні вигуки (але меньше негативних)
    ]

    positive_patterns.each do |pattern|
      positive_count += 1 if text_lower =~ pattern
    end

    # Визначаємо тональність
    if negative_count > positive_count && negative_count > 0
      { sentiment: "negative", confidence: [ 0.5 + (negative_count * 0.1), 0.95 ].min, method: "local" }
    elsif positive_count > negative_count && positive_count > 0
      { sentiment: "positive", confidence: [ 0.5 + (positive_count * 0.1), 0.95 ].min, method: "local" }
    else
      { sentiment: "neutral", confidence: 0.5, method: "local" }
    end
  end

  def self.send_request(prompt)
    uri = URI("#{GOOGLE_AI_URL}?key=#{API_KEY}")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.read_timeout = 10

    request = Net::HTTP::Post.new(uri.request_uri)
    request["Content-Type"] = "application/json"

    body = {
      contents: [
        {
          parts: [
            { text: prompt }
          ]
        }
      ]
    }

    request.body = body.to_json

    http.request(request)
  end

  def self.extract_sentiment(response_body)
    data = JSON.parse(response_body)

    # Вилучити текст з відповіді
    text = data.dig("candidates", 0, "content", "parts", 0, "text")&.downcase&.strip

    # Визначити тональність за текстом
    case text
    when /positive|позитивн/i
      "positive"
    when /negative|негативн/i
      "negative"
    else
      "neutral"
    end
  rescue => e
    Rails.logger.error("Extract sentiment error: #{e.message}")
    "neutral"
  end
end
