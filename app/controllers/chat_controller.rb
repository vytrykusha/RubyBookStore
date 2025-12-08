class ChatController < ApplicationController
  def index
    @messages = session[:chat_messages] || []
  end

  def send_message
    user_message = params[:message]&.strip

    if user_message.blank?
      return render json: { error: "Повідомлення не може бути пустим" }, status: :unprocessable_entity
    end

    # Зберігаємо повідомлення користувача
    messages = session[:chat_messages] || []
    messages << { role: "user", content: user_message }

    # Отримуємо відповідь від ChatBot
    bot_response = ChatBot.chat(user_message)
    messages << { role: "bot", content: bot_response[:response], type: bot_response[:type] }

    # Зберігаємо історію в сесію (максимум 10 повідомлень для зменшення розміру)
    session[:chat_messages] = messages.last(10)

    render json: {
      message: bot_response[:response],
      type: bot_response[:type],
      timestamp: Time.current.strftime("%H:%M")
    }
  end

  def clear
    session[:chat_messages] = nil
    render json: { status: "ok" }
  end
end
