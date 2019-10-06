require 'curb'
require 'nokogiri'

require_relative 'Checker'
require_relative 'FileWriter'

puts 'Input link, example: https://www.petsonic.com/snacks-huesos-para-perros/'
link_category = gets.chomp

puts 'Input file name, example: test'
file_name = gets.chomp + '.csv'

puts 'Receiveng count of pages and products'
count_pages = checkCountPages(link_category)
puts 'Count of pages is ' + count_pages.to_s
list_links = []

puts '===== Links parsing from all pages ====='
for i in 1..count_pages
  puts 'Page ' + i.to_s + ' is parsing'
  i == 1 ? http_page = Curl.get(link_category) : http_page = Curl.get(link_category + '/?p='+ "#{i}")
  current_page = Nokogiri::HTML(http_page.body_str)
  current_page.xpath('//a[@class="product_img_link product-list-category-img"]/@href').each do |current_link|
    list_links << current_link
  end
end
puts "All pages parsed(#{list_links.length}) links"
count_products = list_links.length
data = []
now_parsed_links = 0
puts '===== Parsing info from all links ====='
list_links.each do |current_link|
  puts '===== Get product page ====='
  puts "Link: #{current_link}"
  current_http = Curl.get(current_link)
  current_page = Nokogiri::HTML(current_http.body_str)
  puts 'Parsing data from page'
  product_name = current_page.xpath('//div/h1').text
  product_img = current_page.xpath('//div/span/img/@src')
  list_price_weight = current_page.xpath('//fieldset//ul/li')
  j = 0
  list_price_weight.each do |current_price_weight|
    product_pack = current_price_weight.xpath('//span[@class="radio_label"]')[j].text
    product_price = current_price_weight.xpath('//span[@class="price_comb"]')[j].text
    current_data = ["#{product_name} - #{product_pack}", product_price, product_img]
    puts 'Writing data to list'
    data << current_data
    puts 'Written successfully'
    j = j.next
  end
  now_parsed_links = now_parsed_links.next
  puts "_____ Parsed " + (100 * now_parsed_links / count_products).to_s + "% of products _____"
end

saveDataToFile(data, file_name)

puts 'Work completed successfully'