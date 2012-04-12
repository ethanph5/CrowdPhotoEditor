Given /the following users exist/ do |users_table|
  users_table.hashes.each do |user|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    User.create!(user)
  end
  #assert false, "Unimplmemented"
end


Then /I should see "(.*)" is already filled with "(.*)"/ do |field, username|
  regexp = Regexp.new ".*#{field}.*#{username}"
  page.body =~ regexp
end
