require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    
    #set student variable to all .student-card entries
    student = doc.css(".student-card")
    array = []
    #iterate over student to isolate 3 attributes:  name, location, url
    student.each do |student_page|
      result = {}
      result[:name] = student_page.css(".student-name").text
      result[:location] = student_page.css(".student-location").text
      result[:profile_url] = student_page.css("a").attr("href").value
      array << result
      #binding.pry
    end
    array
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))

    social = doc.css(".vitals-container").css(".social-icon-container").css("a")
    quote = doc.css(".vitals-container").css(".vitals-text-container")
    bio = doc.css(".details-container").css(".bio-block")#.css("p").text
    #binding.pry
   
    info = {}    

      social.each do |media|
        if media.attr("href").include?("twitter")
          info[:twitter] = media.attr("href")
        elsif media.attr("href").include?("linkedin")
          info[:linkedin] = media.attr("href")
        elsif media.attr("href").include?("github")
          info[:github] = media.attr("href")
        elsif media.attr("href").include?("http://")
          info[:blog] = media.attr("href")
        end
      end

      quote.each do |media|
        if media.css(".profile-quote").text
          info[:profile_quote] = media.css(".profile-quote").text
        end
      end

      bio.each do |media|
        if media.css("p").text
          info[:bio] = media.css("p").text
        end
      end
      info
  end

end


# def get_page
#   #examine this
#   doc = Nokogiri::HTML(open("http://learn-co-curriculum.github.io/site-for-scraping/courses")) 
# end

# def get_courses
#   #takes the doc from above and checks all css .post classes
#   self.get_page.css(".post")
# end

# def make_courses
#   #iterates over the .post classes
#   self.get_courses.each do |post|
#     course = Course.new
#     #examine the second use of .css here
#     course.title = post.css("h2").text
#     course.schedule = post.css(".date").text
#     course.description = post.css("p").text
#   end


# def create_project_hash
# html = File.read('fixtures/kickstarter.html')
# kickstarter = Nokogiri::HTML(html)

# projects = {}

# #iterate
# kickstarter.css("li.project.grid_4").each do |project|
#   title = project.css("h2.bbcard_name strong a").text
#   projects[title.to_sym] = {
#     :image_link => project.css("div.project-thumbnail a img").attribute("src").value,
#     :description => project.css("p.bbcard_blurb").text,
#     :location => project.css("ul.project-meta span.location-name").text,
#     :percent_funded => project.css("ul.project-stats li.first.funded strong").text.gsub("%","").to_i
#   }
#    #binding.pry
# end

# #binding.pry
# projects
# end
