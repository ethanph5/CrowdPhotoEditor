Feature: accept some processed photos passed back from the crowd and/or 
directly upload them to facebook
  As a app user
  When I receive a notification
  I can choose to accept some photos and/or upload them to facebook

Background: I already get a notification for query 1 (remove red-eye for wild_party.png with 5 versions) and can see different versions of wild_party.png  Given the following versions of wild_party.png exist:
  | Photo               | 
  | wild_party_1.png    |
  | wild_party_2.png    |
  | wild_party_3.png    |
  | wild_party_4.png    |
  | wild_party_5.png    |

  And I am on the Processed Query 1 page
  
Scenario: select some photos from the list and press accept
  When I select "wild_party_1.png"
  When I select "wild_party_2.png"
  And I press "Accept"
  
  Then I should be on Albums Creation page
  And I should see a time-stamp as the album name
  And I should see "wild_party_1.png"
  And I should see "wild_party_2.png"

Scenario: select some photos from the list and press accept and upload to facebook
  When I select "wild_party_1.png"
  When I select "wild_party_2.png"
  And I press "Accept and upload to facebook"
  
  Then I should be on Albums Creation page on facebook
  And I should see a time-stamp as the album name
  And I should see "wild_party_1.png"
  And I should see "wild_party_2.png"