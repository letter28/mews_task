require 'nokogiri'
require 'httparty'
require 'table_print'

class ExchangeRateProvider
  def get_exchange_rates
    rates = []
    url = "https://www.cnb.cz/en/financial-markets/foreign-exchange-market/central-bank-exchange-rate-fixing/central-bank-exchange-rate-fixing/index.html"
    response = HTTParty.get(url)
    doc = Nokogiri::HTML(response) unless response.body.nil? || response.body.empty?

    if doc
      # Dynamically get the number of currencies in the table
      no_of_currencies = doc.css('table tbody tr').count

      # Get the date for which the rates are valid
      date = doc.css('div.dynapps-exrates div:nth-child(6) p').text.to_s

      for n in 1..no_of_currencies
        amount = doc.css("table tbody tr:nth-child(#{n}) td:nth-child(3)").text.to_s
        code = doc.css("table tbody tr:nth-child(#{n}) td:nth-child(4)").text.to_s
        rate = doc.css("table tbody tr:nth-child(#{n}) td:nth-child(5)").text.to_s

        rates << {amount: amount, currency_code: code, rate: rate}
      end
    end
  
    return rates, date
  end
end

erp = ExchangeRateProvider.new
rates, date = erp.get_exchange_rates
tp rates
puts('-------------------------------')
puts ("BASE CURRENCY: CZK")
puts date