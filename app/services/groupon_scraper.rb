# frozen_string_literal: true
class GrouponScraper
  def self.save_nearby_massages(url, distance, current_user)
    doc = Nokogiri::HTML(open(url))
    links = get_nearby_massage_links(doc, distance)
    links.each do |link|
      massage = create_massage_from_link(link)
      current_user.massages << massage unless current_user.massages.include? massage
      massage.users << current_user unless massage.users.include? current_user
    end
  end

  private_class_method

  def self.get_nearby_massage_links(doc, distance)
    # offset of 1 to reject duplicate featured deal url
    doc.css(".card-ui a")[1..-1].each_with_object([]) do |card, links|
      links << card["href"] if within_distance?(card, distance)
    end
  end

  def self.within_distance?(card, distance)
    dist_str = card.ancestors("#pull-cards").at_css(".cui-location-distance").text
    format_dist_str(dist_str) <= distance.to_f
  end

  def self.format_dist_str(str)
    str.strip[/\d.\d/, 0].to_f
  end

  def self.create_massage_from_link(link)
    doc = Nokogiri::HTML(open(link))
    attrs = massage_attrs(doc, link)
    Massage.create(attrs)
  end

  def self.massage_attrs(doc, link)
    {
      address: address(link),
      title: title(doc),
      rating: rating(doc),
      rating_count: rating_count(doc),
      fine_print: fine_print(doc),
      merchant_profile: merchant_profile(doc)
    }
  end

  def self.address(link)
    driver = Selenium::WebDriver.for :chrome
    driver.get link
    wait = Selenium::WebDriver::Wait.new(timeout: 10)
    # close promotion if it pops up
    driver.find_element(id: "nothx").click
    # handle browser inconsistencies
    begin
      address = driver.find_element(class: "address").text
    rescue Selenium::WebDriver::Error::NoSuchElementError
      wait.until { driver.find_element(class: "address-content") }
      address = driver.find_element(class: "address-content").text
    end
    driver.quit
    address
  end

  def self.title(doc)
    doc.at_css("#deal-title").text.strip
  end

  def self.rating(doc)
    return unless doc.css(".product-reviews-rating li")
    star_count = 0
    doc.css(".product-reviews-rating li").each do |star|
      star_count += 1 if star.css(".full-star").present?
      star_count += 0.5 if star.css(".half-star").present?
    end
    star_count
  end

  def self.rating_count(doc)
    return 0 unless doc.at_css(".star-rating-text")
    doc.at_css(".star-rating-text").text.gsub(/\D+/, "")
  end

  def self.fine_print(doc)
    doc.at_css(".fine-print span").text + " " + doc.at_css(".fine-print span:nth-of-type(2)").text
  end

  def self.merchant_profile(doc)
    return unless doc.at_css(".merchant-profile p:nth-of-type(2)")
    doc.at_css(".merchant-profile p:nth-of-type(2)").text
  end
end
