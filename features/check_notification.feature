Feature: check notification for a specific query 
  As an app user
  When I receive a notification
  I can check the processed photo passed back from the crowd

Background: I already sent out query1 to remove red-eyes in picture wild_party.png with 5 versions and got a notification for query 1
  
Scenario: Check processed Query 1 
  Given I am on notification page 
  Then I should see "query 1 is processed"
  When I follow "query 1 is processed"
  Then I should be on Processed Query 1 page
  And I should see wild_party_1.png
  And I should see wild_party_2.png
  And I should see wild_party_3.png
  And I should see wild_party_4.png
  And I should see wild_party_5.png
	

Scenario: Go back to dashboard and handle the notification later
  Given I am on notification page 
  Then I should see "query 1 is processed"
  When I press "back"
  Then I should be on dashboard page
  And I should see notification for Query 1