Feature: Create a new account

  As a new user
  I can signup a new account
  or I can authenticate via Facebook and use Facebook profile to register
  
Background: 
  Given the following users exist:
  |name       |password     |credit |email              |
  |Rocky      |countdown    |100    |rocky@houston.com  |
  |Batman     |shaco        |250    |batman@nowhere.com |
  And I am on the welcome page

Scenario: new user sign up on signup page 
  Given I am on the home page
  When I fill in "username" with "ethan" 
  When I fill in "email" with "yylolxx@gmail.com"
  When I fill in "password" with "222"
  When I fill in "password_confirm" with "222"
  Then I press "Sign Up"
  Then I should be on the signup page
  #Then I should be on the dashboard page

Scenario: new user cannot sign up with incorrect format information
  When I fill in "username" with "Rocky" 
  When I fill in "email" with "rocky@houston"
  When I fill in "password" with "countdown"
  #When I fill in "password_confirm" with "countdown"
  Then I press "Sign Up"
  Then I should be on the signup page
  Then I should see "Email format incorrect."


Scenario: user can log in after sign up
  When I fill in "email" with "rocky@houston.com"
  When I fill in "password" with "countdown"
  Then I press "Log In"
  Then I should be on the dashboard page
  
Scenario: user cannot log in if password is wrong
  When I fill in "email" with "batman@nowhere.com"
  When I fill in "password" with "countdown"
  Then I press "Log In"
  Then I should be on the home page
  Then I should see "Invalid email or password."
  

Scenario: new user authenticate via Facebook
  When I press "Facebook"
  Then I should be on the signup page
  When I fill in "username" with "Rocky" 
  When I fill in "email" with "rocky@houston.com"
  When I fill in "password" with "countdown"
  When I fill in "password_confirm" with "countdown"
  Then I press "Sign Up"
  Then I should be on the signup page
  #Then I should be redirected to the Albums display page
