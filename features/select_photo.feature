Feature: Select photo from existing album or Upload a new photo
  As a app user
  I can select the photo from my existing album on the app's page or on Facebook
  I can upload a new photo

Background: I already authenticate via CrowdPhotoEditor and can see the pictures on index
  Given the following pictures exist:
  | name        	| internal_link  				| user_id 	|album_id	|
  | college_1.png   | /photoStorage/college_1.png   | 1		  	|1			|
  | college_2.png   | /photoStorage/college_2.png   | 1		  	|1			|
  | college_3.png   | /photoStorage/college_3.png   | 1			|1			|
  | college_4.png   | /photoStorage/college_4.png   | 1			|1			|
  | vacation_1.png  | /photoStorage/vacation_1.png  | 2			|2			|
  | vacation_2.png  | /photoStorage/vacation_2.png  | 2			|2			|
  | vacation_3.png  | /photoStorage/vacation_3.png  | 2			|2			|
  | vacation_4.png  | /photoStorage/vacation_4.png  | 2			|2			|
  
  Given the following albums exist:
  | name      |  user_id 	|
  | college   |  1		  	|
  | college   |  1		  	|
  | college   |  1			|
  | college   |  1			|
  | vacation  |  2			|
  | vacation  |  2			|
  | vacation  |  2			|
  | vacation  |  2			|  

  And I am on index

Scenario: select the existing photo
  When I follow "college"
  Then I should be on selectPhoto
  Then I should see "college_1.png"
  Then I should see "college_2.png"
  Then I should see "college_3.png"
  Then I should see "college_4.png"
  When I check "college_1.png"
  When I check "college_2.png"
  Then I press "Continue"
  Then I should be on index
  
Scenario: Upload a new photo and add to an existing album  
  When I press "Upload"
  Then I should be on uploadPhotoToNew
  When I follow "add to an existing album"
  Then I should be on selectAlbum
  When I select the "college" from "album_id"
  When I press "selectPhotoButton"

  When I attach the file "college_5.png" to "selectPhotoButton"
  
  Then I should be on selectPhoto
  And I should see "college"  
  And I should see "college_5.png"
  
Scenario: Upload a new photo to a new album
  When I press "Upload"
  Then I should be on uploadPhotoToNew
  When I fill in "albumName" with "Graduation Commencement"
  When I press "selectPhotoButton"

  When I attach the file "sather.png" to "selectPhotoButton"
  
  Then I should be on selectPhoto
  And I should see "Graduation Commencement"  
  And I should see "sather.png"
