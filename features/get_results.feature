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
  
  Given I follow "Inbox(0)"
  Then I should be on the get result page
  
Scenario: Accepting some photos from the list by pressing accept
  #When I press "Accept"
  Then I should be on the get result page
  
  When I press "Back to Dashboard"
  Then I should be on the dashboard page
  
Scenario: Rejecting some photos from the list by pressing reject
  #When I press "Reject"
  Then I should be on the get result page
  
  When I press "Back to Dashboard"
  Then I should be on the dashboard page
