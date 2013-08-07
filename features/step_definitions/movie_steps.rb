# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    @movie = Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  flunk "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  ratings = rating_list.split(", ")
  if uncheck.nil?
    ratings.each do |rating|
      check("ratings_" + rating)
    end
  else
    ratings.each do |rating|
      uncheck("ratings_" + rating)
    end
  end
end

When /I press (.*)/ do |button|
  click_button(button)
end

# Add a declarative step here for checking boxes and seeing movies.

Then /^I should see all of the movies$/ do
  # Rows grabs all of the <tr> tags under the table with ID Movie minus one for the header
  rows = page.all("table#movies tr").size - 1
  # Compare rows to all of the movies in the movies database
  rows.should == Movie.connection.select_all("SELECT COUNT(*) FROM movies")[0]["COUNT(*)"]
end

Then /^(?:|I )should see "([^"]*)"$/ do |text|
    if page.respond_to? :should
          page.should have_content(text)
        else
          assert page.has_content?(text)
        end
  end

Then /^(?:|I )should see \/([^\/]*)\/$/ do |regexp|
    regexp = Regexp.new(regexp)

    if page.respond_to? :should
          page.should have_xpath('//*', :text => regexp)
        else
          assert page.has_xpath?('//*', :text => regexp)
        end
  end

Then /^(?:|I )should not see "([^"]*)"$/ do |text|
    if page.respond_to? :should
          page.should have_no_content(text)
        else
          assert page.has_no_content?(text)
        end
  end

Then /^(?:|I )should not see \/([^\/]*)\/$/ do |regexp|
    regexp = Regexp.new(regexp)

    if page.respond_to? :should
          page.should have_no_xpath('//*', :text => regexp)
        else
          assert page.has_no_xpath?('//*', :text => regexp)
        end
  end
