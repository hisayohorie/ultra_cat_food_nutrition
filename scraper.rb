# This is a template for a Ruby scraper on morph.io (https://morph.io)
# including some code snippets below that you should find helpful

require 'scraperwiki'
require 'mechanize'

agent = Mechanize.new
#
# # Read in a page
base_url = "http://performatrin.com/products-selector/"
base_page = agent.get(base_url)

product_urls = base_page.at("#products-listed").search("a").map {|a| a.attributes["href"].value }
cat_product_urls = product_urls.select {|url| url.include? "cat"}
cat_product_urls.each do |url|
  product_name = url.split("/").last.gsub("-", "_")
  page = agent.get(url)
  page.at("#analysis_content").search('tr').each do |tr|
    key = tr.search('th').text
    value = tr.search('td').text
    info = {
      nutrition: key,
      value: value
    }
    ScraperWiki.save_sqlite([:nutrition], info,table_name=product_name)
  end
end

# # Find somehing on the page using css selectors
# p page.at('div.content')
#
# # Write out to the sqlite database using scraperwiki library
# ScraperWiki.save_sqlite(["name"], {"name" => "susan", "occupation" => "software developer"})
#
# # An arbitrary query against the database
# ScraperWiki.select("* from data where 'name'='peter'")

# You don't have to do things with the Mechanize or ScraperWiki libraries.
# You can use whatever gems you want: https://morph.io/documentation/ruby
# All that matters is that your final data is written to an SQLite database
# called "data.sqlite" in the current working directory which has at least a table
# called "data".
