Feature: Specify the number of result
  As an app user
  After I selected the photos
  I can specify the number of result I will receive

Background:

  Given I have signed up using name "Bieber",password "password",email "name@email.com"
  Given I have created an album "college"
  Given I have a picture "college_1.png" in the album "college" 
  
  Given I have successfully logged in using email "name@email.com",password "password"

  Given I have selected picture "college_1.png" from album "college"

  When I press "Done selection"
  Then I should be on the specify task page
  Then I should see "college_1.png"
  
Scenario: Go back to select more photos before sepcifying the tasks and number of results I want
  When I press "Go Back to Select Photo"
  Then I should be on the dashboard page
  
Scenario: Sepcify the tasks and edit the tasks
  When I fill in "task box 1" with "remove red eye"
  And I fill in "result box 1" with "10"

  When I press "Task Review"
  Then I should be on the review task page
  And I should see "college_1.png"
  And I should see "remove red eye" in "task box 1"
  And I should see number "10" in "result box 1"

  When I press "Edit"
  Then I should be on the specify task page
  
Scenario: Specify the task and number of results I want
  When I fill in "task box 1" with "remove red eye"
  And I fill in "result box 1" with "10"

  When I press "Task Review"
  Then I should be on reviewTask
  And I should see "college_1.png"

  And I should see "remove red eye" in "task box 1"
  And I should see number "10" in "result box 1"
  
  When I press "Submit"
  Then I should be on the dashboard page
  Then I should see "Task(s) submitted"
  
