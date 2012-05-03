Feature: check notification for a specific result of a task sumitted previously 
  As an app user
  When I receive a notification
  I can check the processed photo passed back from the crowd

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
   
Scenario: Check task status
  Given I follow "Inbox(0)"
  Then I should be on the get result page

Scenario: Go back to dashboard and handle the notification later
  Given I am on the get result page 
  When I press "Back to Dashboard"
  Then I should be on the dashboard page
