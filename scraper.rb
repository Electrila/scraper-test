require 'open-uri'
require 'nokogiri'

html = Nokogiri::HTML(open("https://platinumgod.co.uk/"))

# Repentance Items
repentance_items = []
html.at(".repentanceitems-container").css("li.textbox").each do |item |
    item_name = item.css("a span p.item-title").text
    item_id = item.css("a span p.r-itemid").text.sub(/^ItemID: /, "")
    pickup_text = item.css("a span p.pickup").text.gsub("\"", "")
    quality = item.css("a span p.quality").text.sub(/^Quality: /, "")
    use = item.css(".quality ~ p:not(.tags)").map { |row| row.text }

    item_type = item.css("a span ul")
    item.css("a span ul").each.map do |child|
        item_type = child.css("p")[0].text.sub(/^Type: /, "")
        if child.css("p")[1].text.match "Recharge time"
            recharge_time = child.css("p")[1].text.sub(/^Recharge time: /, "")
            item_pool = child.css("p")[2].text.sub(/^Item Pool: /, "").gsub(/,\s*$/m, "").split(", ")
        else
            recharge_time = "N/A"
            item_pool = child.css("p")[1].text.sub(/^Item Pool: /, "").gsub(/,\s*$/m, "").split(", ")
        end
        repentance_items << {name: item_name, item_id: item_id, pickup_text: pickup_text, quality: quality, use: use, item_type: item_type, recharge_time: recharge_time, item_pool: item_pool}
    end
end


# Repentance Trinkets
#repentance_trinkets = []
#html.at(".repentanceitems-container").css("li.textbox").each do |trinket|
#    trinket_name = trinket.css("a span p.item-title").text
#    puts trinket_name
#end





# Prints each item's name as a numbered list
#repentance_items.each_with_index do |item_hash, index|
#    puts "#{index + 1}. #{item_hash[:name]}"
#end

# Prints each item's attributes
user_choice = 1
puts "#{repentance_items[user_choice - 1][:name]}"
puts "Item ID: #{repentance_items[user_choice - 1][:item_id]}"
puts "Pickup Text: #{repentance_items[user_choice - 1][:pickup_text]}"
puts "Quality: #{repentance_items[user_choice - 1][:quality]}"
puts "Use:"
repentance_items[user_choice][:use].each { |use| puts use }
puts "Item Type: #{repentance_items[user_choice - 1][:item_type]}"
puts "Recharge Time: #{repentance_items[user_choice - 1][:recharge_time]}"
puts "Item Pool(s):"
repentance_items[user_choice][:item_pool].each { |pool| puts pool }