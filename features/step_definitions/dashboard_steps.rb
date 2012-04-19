Given /the following users exist/ do |users_table|
  users_table.hashes.each do |user|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    User.create!(user)
  end
end

Given /the following pictures exist/ do |pictures_table|
  pictures_table.hashes.each do |picture|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Picture.create!(picture)
  end
end

Given /the following albums exist/ do |albums_table|
  albums_table.hashes.each do |album|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Album.create!(album)
  end
end

#Given /^(?:|I )have signed in using "([^"]*)" and "([^"]*)"/ do |email, passwd|
  
#end


Then /^(?:|I )should see number "([^"]*)" in "([^"]*)"/ do |num, box_name|
  str = page.body
  if ((str =~ /<td><label(.*)name="#{box_name}"(.*)>#{num}<\/label><\/td>/) == nil)
    assert false, "There is no specified quantity for results"
  end  
end  

Then /^(?:|I )should see "([^"]*)" in "([^"]*)"/ do |task, box_name|
  str = page.body
  if ((str =~ /<td><label(.*)name="#{box_name}"(.*)>#{task}<\/label><\/td>/) == nil)
    assert false, "There is no specified task for results"
  end  
end

Given /^(?:|I )have signed up using name "([^"]*)",password "([^"]*)",email "([^"]*)"/ do |name,pwd,email|
  @user = User.create!(:name => name, :password => pwd, :email => email)
end  

Given /^(?:|I )have created an album "([^"]*)"/ do |albumName|
  @album = Album.create!(:name => albumName, :user_id => @user.id)
end

Given /^(?:|I )have a picture "([^"]*)" in the album "([^"]*)"/ do |picName,albumName|
  Picture.create!(:name => picName, :internal_link => "/photoStorage/bieber.png", :user_id => @user.id, :album_id => Album.find_by_name(albumName).id)
end

Given /^(?:|I )have successfully logged in using email "([^"]*)",password "([^"]*)"/ do |email,pwd|
  step %Q{I am on the Sign In page}
  step %Q{I fill in "user_email" with "#{email}"}
  step %Q{I fill in "user_password" with "#{pwd}"}
  step %Q{I press "Sign in"}  
  step %Q{I am on the home page}
end

Given /^(?:|I )have selected picture "([^"]*)" from album "([^"]*)"/ do |picture_name,album_name|
  step %Q{I follow "#{album_name}"}
  #step %Q{I am on the select photo page}
  step %Q{I check "#{picture_name}"}
  step %Q{I press "Continue"}
  #step %Q{I am on the dashboard page}
end