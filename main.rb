require 'curb'
require 'nokogiri'
#Dobavit input ssilki wwesti (dannie s konsoli)
# Putsi pobolshe
require_relative 'Checker'
require_relative 'FileWriter'

link_category = 'https://www.petsonic.com/snacks-huesos-para-perros/'

count_pages = checkCountPages(link_category)

list_links = []

for i in 1..count_pages
  i == 1 ? http_page = Curl.get(link_category) : http_page = Curl.get(link_category + "/?p="+ "#{i}")
  current_page = Nokogiri::HTML(http_page.body_str)
  current_page.xpath('//a[@class="product_img_link product-list-category-img"]/@href').each do |current_link|
    list_links << current_link
  end
end

puts list_links.length

data = []

list_links.each do |current_link|
  puts "___111___"
  current_http = Curl.get(current_link)
  current_page = Nokogiri::HTML(current_http.body_str)

  product_name = current_page.xpath('//div/h1').text
  product_img = current_page.xpath('//div/span/img/@src')
  list_price_weight = current_page.xpath('//fieldset//ul/li')
  j = 0
  list_price_weight.each do |current_price_weight|
    product_pack = current_price_weight.xpath('//span[@class="radio_label"]')[j].text
    product_price = current_price_weight.xpath('//span[@class="price_comb"]')[j].text
    current_data = ["#{product_name} - #{product_pack}", product_price, product_img]
    data << current_data
    j = j.next
  end
end

saveDataToFile(data)
