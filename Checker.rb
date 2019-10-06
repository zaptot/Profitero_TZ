def checkCountPages(link_category)
  http = Curl.get(link_category)
  category_page = Nokogiri::HTML(http.body_str)

  count_links = category_page.xpath('//span[@class="heading-counter"]').text.to_i

  (count_links % 25).zero? ? count_pages = (count_links / 25) : count_pages = (count_links / 25).next
  return count_pages
end
