Feature: Specify the number of result
  As a app user
  After I selected the photos
  I can specify the number of result I will receive

Background: I already authenticate via Facebook and can see the photos on Facebook
  Given the following albums and photos exist:
  | Album        | Photo               | 
  | College      | college_1.png       |
  | College      | college_2.png       |
  | College      | college_3.png       |
  | College      | college_4.png       |
  | Vacation     | vacation_1.png      |
  | Vacation     | vacation_2.png      |
  | Vacation     | vacation_3.png      |
  | Vacation     | vacation_4.png      |

  And I am on the dashboard page and I selected college_1.png and vacation_2.png
  And I should see "2 photos selected"
  When I press "Done Selection"
  Then I should be on SPECIFY TASK page
  Then I should see "college_1.png"
  And I should see "vacation_2.png"
  
Scenario: Go back to select more photos before sepcifying the tasks and number of results I want
  When I press "Go Back to Select Photo"
  Then I should be on My Albums page
  And I should see "2 photos selected"

Scenario: Sepcify the task and number of results I want
  When I check "remove red eye" for "college_1.png"
  When I enter "10" in the result box for "college_1.png"
  When I check "blur" for "vacation_2.png"
  When I enter "10" in the result box for "vacation_2.png"
  
  When I press "Task Review"
  Then I should be on REVIEW TASK page
  Then I should see "college_1.png"
  And I should see "vacation_2.png"
  And I should see "remove red eye" option for "college_1.png"
  And I should see "10" in the result box for "college_1.png"
  And I should see "blur" option for "vacation_2.png"
  And I should see "10" in the result box for "vacation_2.png"
  
  When I press "Submit"
  Then I should see "Task is submitted."
  And I should be on home page
  
Scenario: Sepcify the tasks and edit the tasks
  When I check "remove red eye" for "college_1.png"
  When I enter "10" in the result box for "college_1.png"
  When I check "blur" for "vacation_2.png"
  When I enter "10" in the result box for "vacation_2.png"
  
  When I press "Task Review"
  Then I should be on REVIEW TASK page
  When I press "Edit"
  Then I should be on SPECIFY TASK page
  
  Then I should see "college_1.png"
  And I should see "vacation_2.png"
  And I should see "remove red eye" option for "college_1.png"
  And I should see "10" in the result box for "college_1.png"
  And I should see "blur" option for "vacation_2.png"
  And I should see "10" in the result box for "vacation_2.png"
  


