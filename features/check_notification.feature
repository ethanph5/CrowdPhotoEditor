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
  
  Given I see a callback alert #not yet implemented (depend on crowd workers?)
  
  
Scenario: Check task status
  Given I press "Notification"
  Then I should be on notification page
  Then I should see "Remove red eye in college_1.png with 3 results"
  Then I should see "Status: finished"
  When I follow "finished"
  Then I should be on the processed task page
  Then I should see "Here are 3 results for college_1.png"
	

Scenario: Go back to dashboard and handle the notification later
  Given I am on notification page 
  Then I should see "Remove red eye in college_1.png with 3 results"
  Then I should see "Status: finished"
  When I press "back"
  Then I should be on dashboard page
  And I should see a callback alert