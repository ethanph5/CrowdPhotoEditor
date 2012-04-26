Feature: accept some processed photos passed back from the crowd and/or 
directly upload them to facebook
  As an app user
  When I receive a notification
  I can choose to accept some photos and/or upload them to facebook

Background:
  Given I have signed up using name "Bieber",password "password",email "name@email.com"
  Given I have created an album "college"
  Given I have a picture "college_1.png" in the album "college" 
  
  Given I have successfully logged in using email "name@email.com",password "password"

  Given I have selected picture "picture[1]" from album "college"

  When I follow "Done Selection"
  Then I should be on the specify task page
  Then I should see "college_1.png"

  Given I have successfully submitted a task "remove red eye" and number of result "3" for "college_1.png"
  
  Given I see a callback alert
  
  Given I press "Notification"
  Then I should be on notification page
  Then I should see "Remove red eye in college_1.png with 3 results"
  Then I should see "Status: finished"
  When I follow "finished"
  Then I should be on the processed task page
  Then I should see "Here are 3 results for college_1.png"  

  
Scenario: select some photos from the list and press accept
  When I select "college_1_version1.png"
  When I select "college_2_version2.png"
  And I press "Accept"
  
  Then I should be on Albums Creation page
  And I should see a time-stamp as the album name
  And I should see "college_1_version1.png"
  And I should see ""college_1_version2.png"

Scenario: select some photos from the list and press accept and upload to facebook
  When I select "college_1_version1.png"
  When I select "college_1_version2.png"
  And I follow "Accept and upload to facebook"
  
  Then I should be on Albums Creation page on facebook
  And I should see a time-stamp as the album name
  And I should see "college_1_version1.png"
  And I should see "college_1_version2.png"