Feature: Specify the task to perform on a particular photo
  As an app user
  I can specify tasks by doing one of the following:
  1.select the queries from the most popular query list (globally popular)
  2.select the queries from my previous task list
  3.create a new task by specifying the task title and optionally a description to the task
   
Background: I have already selected the photo "commencement.png". Now I want to specify the tasks for that photo.
 I've sent out multiple tasks before.
 Given the following selected photos exist:
 |photo             |
 |commencement.png  |
   
 Given the following system default tasks exist:
 | Query            | 
 | Remove red eyes  |
 | Sharpen          |
 | Soften           |
 | Emboss           |
 | Posterize        |
 
 Given the following user's previous tasks exist:
 | Query                                  |
 | add President Obama to this photo      | 
 | Remove pimples from the faces          |
 | Sharpen and colorize this old picture  |
 | Crop this image                        |
 | Change the color of my car to blue     |
 
Scenario: click a link to specify tasks performed on the photo 
  Given I am on Specify Task page
  Then I should see "commencement.png"
  When I follow "click here to specify task for commencement.png"
  Then I should be on Pick Tasks From Lists Or Create A New One page
  
  And I should see "Hot Queries Others are Making:"
  And I should see "Remove red eyes"
  And I should see "Sharpen"
  And I should see "Soften"     		
  And I should see "Emboss"      		
  And I should see "Posterize"
  
  And I should see "Your Previous Queries:"
  And I should see "add President Obama to this photo"
  And I should see "Remove pimples from the faces"
  And I should see "Sharpen and colorize this old picture"     		
  And I should see "Crop this image"      		
  And I should see "Change the color of my car to blue"
  
Scenario: select the queries from the most popular query list
  Given I am on Pick Tasks From Lists Or Create A New One page
  When I check "Remove red eyes"
  And I check "Sharpen"
  Then I press "Select the checked hot queries"
  Then I should be on Specify Task page
  And I should see "Remove red eyes"
  And I should see "Sharpen" 
  
Scenario: select the queries from my previous task list  
  Given I am on Pick Tasks From Lists Or Create A New One page
  When I check "add President Obama to this photo"
  And I check "Change the color of my car to blue"
  Then I press "Select the checked past queries"
  Then I should be on Specify Task page
  And I should see "add President Obama to this photo"
  And I should see "Change the color of my car to blue"

Scenario: create a new task by specifying the task title and optionally a description to the task
  Given I am on Pick Tasks From Lists Or Create A New One page
  When I fill in "New Query Title" with "whiten my teeth in this picture"
  When I fill in "New Query Description" with "I'm the second one from the left."
  And I press "Make this new query"
  Then I should be on Specify Task page
  And I should see "whiten my teeth in this picture"
  
