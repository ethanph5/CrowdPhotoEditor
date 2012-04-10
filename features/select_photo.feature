Feature: Select photo from existing album or Upload a new photo
  As a app user
  I can select the photo from my existing album on the app's page or on Facebook
  I can upload a new photo

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

  And I am on the homepage page

Scenario: select the existing photo
  When I select the "College" Album
  Then I should be on the photo page of College Album
  Then I should see "college_1.png"
  Then I should see "college_2.png"
  Then I should see "college_3.png"
  Then I should see "college_4.png"
  When I select "college_1.png"
  When I select "college_2.png"
  Then I press "Continue"
  Then I should be on the homepage page
  
Scenario: Upload a new photo and add to an existing album  
  When I press "Upload"
  Then I should be on Upload Photo page
  When I follow "add to an existing album"
  Then I should be on Select an album page
  When I select the "Vacation" from the drop down list
  When I press "Select Photos from your computer"
  Then I see a pop-up window
  And I upload the file "hawaii.png"
  
  Then I should be on Select Photo page
  And I should see "Vacation"  
  And I should see "hawaii.png"
  
Scenario: Upload a new photo to a new album
  When I press "Upload"
  Then I should be on Upload Photo page
  When I fill in "New Album Name" with "Graduation Commencement"
  When I press "Select Photos from your computer"
  Then I see a pop-up window
  And I upload the file "commencement.png"
  
  Then I should be on Select Photo page
  And I should see "Graduation Commencement"  
  And I should see "commencement.png"
    
