class CurrencyConverter
  # Converts USD to UAH using ENV['USD_TO_UAH_RATE'] or a sensible default
  def self.usd_to_uah(amount)
    return 0.0 if amount.nil?
    rate = (ENV["USD_TO_UAH_RATE"] || ENV["USD_TO_UAH"] || "40.0").to_f
    (amount.to_f * rate).round(2)
  end

  def self.uahto_usd(amount)
    return 0.0 if amount.nil?
    rate = (ENV["USD_TO_UAH_RATE"] || ENV["USD_TO_UAH"] || "40.0").to_f
    (amount.to_f / rate).round(2)
  end
end
