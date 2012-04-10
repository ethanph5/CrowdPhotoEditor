Given /the following pictures exist/ do |pictures_table|
  pictures_table.hashes.each do |picture|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Picture.create!(picture)
  end
end

Given /Given the following albums exist/ do |albums_table|
  albums_table.hashes.each do |album|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Album.create!(album)
  end
end



When /^(?:|I )select the "([^"]*)" Album$/ do |link|
  click_link(link)
end

When /^(?:|I )select the "([^"]*)" album$/ do |value|
  select(value)
end

When /^(?:|I )select "(.*)"$/ do |value|
  list = value.split(",")
  list.each do |item|
    select(item)
  end
end

When /^(?:|I )select the "([^"]*)" from the drop down list$/ do |value|
  choose(value)
end