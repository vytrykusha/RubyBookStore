require "net/http"
require "base64"
require "json"
require "digest"

env_path = File.join(Dir.pwd, ".env")
if File.exist?(env_path)
  File.foreach(env_path) do |line|
    next if line.strip.start_with?("#") || line.strip.empty?
    k, v = line.strip.split("=", 2)
    next unless k && v
    ENV[k] = v.strip.gsub(/^"|"$/, "") if ENV[k].nil? || ENV[k].empty?
  end
end

class LiqPayService
  MERCHANT_ID = ENV["LIQPAY_MERCHANT_ID"].present? ? ENV["LIQPAY_MERCHANT_ID"] : "sandbox_i97330390448"
  PRIVATE_KEY = ENV["LIQPAY_PRIVATE_KEY"].present? ? ENV["LIQPAY_PRIVATE_KEY"] : "test_private_key"
  API_URL = "https://www.liqpay.ua/api/checkout"

  def self.create_invoice(order)
    data = {
      version: "3",
      public_key: MERCHANT_ID,
      amount: (order.total_price).round(2).to_s,
      currency: "UAH",
      description: "BookStore Order ##{order.id}",
      order_id: order.id.to_s,
      result_url: "http://localhost:3000/orders/#{order.id}",
      server_url: "http://localhost:3000/payments/liqpay/notify",
      language: "uk"
    }

    signature = generate_signature(data)

    {
      data: encode_data(data),
      signature: signature,
      action: API_URL
    }
  end

  def self.verify_notification(data_encoded, signature_received)
    data = decode_data(data_encoded)
    signature = generate_signature(data)

    signature == signature_received
  end

  def self.process_payment(data_encoded)
    data = JSON.parse(Base64.decode64(data_encoded))

    order = Order.find(data["order_id"])

    case data["status"]
    when "success"
      order.update(payment_status: "completed", status: "confirmed")
      { success: true, message: "Платіж успішний" }
    when "failure"
      order.update(payment_status: "failed")
      { success: false, message: "Платіж відхилено" }
    when "error"
      order.update(payment_status: "error")
      { success: false, message: "латежу" }
    else
      { success: false, message: "Невідомий статус" }
    end
  end

  private

  def self.generate_signature(data)
    data_encoded = Base64.strict_encode64(JSON.generate(data))
    signature_string = PRIVATE_KEY + data_encoded + PRIVATE_KEY
    Base64.strict_encode64(Digest::SHA1.digest(signature_string))
  end

  def self.encode_data(data)
    Base64.strict_encode64(JSON.generate(data))
  end

  def self.decode_data(data_encoded)
    JSON.parse(Base64.decode64(data_encoded))
  end
end
