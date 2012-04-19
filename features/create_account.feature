Feature: Create a new account

  As a new user
  I can signup a new account
  or I can authenticate via Facebook and use Facebook profile to register
  
Background: 
  Given the following users exist:
  |name       |password     |credit |email              |
  |Rocky      |countdown    |100    |rocky@houston.com  |
  |Batman     |iLoveJoker   |250    |batman@nowhere.com |
  And I am on the welcome page

Scenario: new user sign up on home page
  When I follow "Sign up"
  Then I should be on the Sign Up page 
  When I fill in "user_name" with "yylolxx" 
  When I fill in "user_email" with "yylolxx@gmail.com"
  When I fill in "user_password" with "12345678"
  When I fill in "user_password_confirmation" with "12345678"
  Then I press "Sign up"
  Then I should be on the home page


Scenario: new user cannot sign up with incorrect format information
  Given I am on the Sign Up page 
  When I fill in "user_name" with "An" 
  When I fill in "user_email" with "an@gmail"
  When I fill in "user_password" with "87654321"
  When I fill in "user_password_confirmation" with "87654321"
  Then I press "Sign up"
  Then I should be on the Sign Up Error page
  Then I should see "Email is invalid"


Scenario: user can log in after sign up
  When I follow "Sign in"
  Then I should be on the Sign In page
  When I fill in "user_email" with "rocky@houston.com"
  When I fill in "user_password" with "countdown"
  Then I press "Sign in"
  Then I should be on the home page
  
Scenario: user cannot log in if password is wrong
  Given I am on the Sign In page
  When I fill in "user_email" with "batman@nowhere.com"
  When I fill in "user_password" with "countdown"
  Then I press "Sign in"
  Then I should be on the Sign In page
  Then I should see "Invalid email or password."
  
  
