require "net/http"
require "json"
require "uri"

class ChatBot
  API_KEY = ENV["GOOGLE_API_KEY"]
  GOOGLE_AI_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent"

  # Словник книг для рекомендацій
  BOOKS_KEYWORDS = {
    fiction: [ "фантастика", "роман", "пригоди", "детектив", "трилер" ],
    history: [ "історія", "біографія", "минуле", "революція" ],
    science: [ "наука", "фізика", "хімія", "біологія", "космос" ],
    fantasy: [ "фентезі", "магія", "дракони", "чарівництво" ],
    children: [ "дитячі", "казки", "русалки", "пригоди" ]
  }

  def self.chat(user_message)
    env_key = API_KEY
    if env_key.present?
      api_response(user_message)
    else
      local_response(user_message)
    end
  rescue StandardError => e
    Rails.logger.error("ChatBot error: #{e.message}")
    local_response(user_message)
  end

  private

  def self.api_response(user_message)
    prompt = build_prompt(user_message)
    response = send_request(prompt)

    if response.is_a?(Net::HTTPSuccess)
      data = JSON.parse(response.body)
      text = data.dig("candidates", 0, "content", "parts", 0, "text")&.strip

      { response: text || "Вибачте, не розумію.", type: "api" }
    else
      local_response(user_message)
    end
  end

  def self.local_response(user_message)
    text = user_message.downcase

    # Визначаємо намір користувача
    intent = detect_intent(text)

    case intent
    when :greeting
      {
        response: "Привіт! 👋 Я книжковий помічник. Можу допомогти у виборі книги. Розкажіть, які книги вам подобаються?",
        type: "local"
      }
    when :book_search
      books = Book.all.sample(3)
      book_list = books.map { |b| "📖 #{b.title} (#{b.category})" }.join("\n")
      {
        response: "Ось кілька популярних книг:\n#{book_list}\n\nВам щось подобається?",
        type: "local"
      }
    when :recommendation
      keyword = extract_category(text)
      books = if keyword
        Book.where("category LIKE ? OR title LIKE ? OR author LIKE ?", "%#{keyword}%", "%#{keyword}%", "%#{keyword}%").limit(3)
      else
        Book.all.sample(3)
      end

      if books.any?
        book_list = books.map { |b| "📖 #{b.title} (#{b.author}) - #{b.category}\n💵 #{b.price}₴" }.join("\n\n")
        { response: "Рекомендую:\n\n#{book_list}\n\nЦікаво?", type: "local" }
      else
        # Fallback: рекомендуємо популярні книги
        books = Book.all.sample(2)
        if books.any?
          book_list = books.map { |b| "📖 #{b.title} (#{b.author})" }.join("\n")
          { response: "На жаль, за цим критеріям книг не знайшли.\nАле можемо запропонувати:\n#{book_list}", type: "local" }
        else
          { response: "На жаль, такі книги не знайшлися. Спробуйте інший жанр.", type: "local" }
        end
      end
    when :help
      {
        response: "Я можу допомогти з:\n- Пошуком книг\n- Рекомендаціями за жанром\n- Інформацією про книги\n\nЩо вас цікавить?",
        type: "local"
      }
    else
      {
        response: "Цікаво! 🤔 Розкажіть більше про те, які книги вам подобаються.",
        type: "local"
      }
    end
  end

  def self.detect_intent(text)
    case text
    when /привіт|привет|hi|hello|hey|як дела|як справи|heyyy/i
      :greeting
    when /покаж|список|всі|які книги|видали б|покажи|всім|подивись/i
      :book_search
    when /рекомендув|пропон|яку.*читати|що.*почитати|цікав.*книг|фентез|істор|наук|дитяч|казк|класик|детектив|трилер|роман|пригод/i
      :recommendation
    when /допомож|як.*користу|що ти вмієш|help|guide|інструк/i
      :help
    else
      :unknown
    end
  end

  def self.extract_category(text)
    # Спеціальні категорії для англійської
    english_categories = {
      "fantasy" => [ "fantasy", "magic", "wizard", "dragon", "witch" ],
      "history" => [ "history", "historical", "biography" ],
      "science" => [ "science", "physics", "chemistry", "biology", "cosmos" ],
      "classic" => [ "classic", "jane eyre", "orwell", "tolstoy", "shakespeare" ]
    }

    # Перевіряємо англійські категорії — повертаємо знайдений ключ (keyword)
    english_categories.each do |_category, keywords|
      keywords.each do |keyword|
        return keyword if text.include?(keyword)
      end
    end

    # Перевіряємо українські категорії — повертаємо знайдений ключ (keyword)
    BOOKS_KEYWORDS.each do |_category, keywords|
      keywords.each do |keyword|
        return keyword if text.include?(keyword)
      end
    end
    nil
  end

  def self.build_prompt(user_message)
    <<~TEXT
      Ти - помічник книжкового магазину. Допомагай користувачам у виборі книг.
      Книги в магазині мають категорії: Fiction, History, Science, Fantasy, Children.

      Користувач каже: "#{user_message}"

      Дай коротку, дружелюбну відповідь (1-2 речення). Рекомендуй книги якщо цікаво.
    TEXT
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
end
