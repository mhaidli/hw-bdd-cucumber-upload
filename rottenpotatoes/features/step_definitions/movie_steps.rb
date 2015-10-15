# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
    #movies_table.add(movie)
  end
  #fail "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

# Inspiration for Code Below
# https://robots.thoughtbot.com/use-capybara-on-any-html-fragment-or-page
Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  entire_string = page.body
  if entire_string.include?(e1) & entire_string.include?(e2)
    entire_string.index(e1).should <= entire_string.index(e2) 
  else
    fail "One or both movies not found in table"
  end
  
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  if (uncheck)
    rating_list.split(/\, /).each do |box|
      full_name = "ratings_" + box
      uncheck(full_name)
    end
  else
    rating_list.split(/\, /).each do |box|
      full_name = "ratings_" + box
      check(full_name)
      # Technically we are supposed to use the pre-defined step definition "When I check box"
      # but for some reason that method kept giving errors. We think it may be broken.
    end
  end
end

#Given /^(?:I) check the following ratings:"([^"]*)"$/ do |boxTB|
#  boxTB.split(/\W+/).each do |box|
#    check(box)
#  end
#end

Then /I should see all the movies/ do 
  # Make sure that all the movies in the app are visible in the table
  value = Movie.all.count
  expect(page).to have_xpath(".//tr", :count => value + 1)
end

# Inspiration for the above problem obtained From 
# http://stackoverflow.com/questions/6083219/activerecord-size-vs-count
# http://stackoverflow.com/questions/26397018/how-to-count-the-number-of-rows-in-the-tables-rspec-capybara

# Once more, we were supposed to use row.should == value, but it we found it to be error-prone and buggy.
# This method works a lot better.