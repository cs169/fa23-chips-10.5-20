Feature: County Map Interaction
  As a user
  I want to click on a county in the state map
  And be taken to the search page for that county

  Background:
    Given the following states exist:
      | symbol | name       | fips_code | is_territory | lat_min      | lat_max      | long_min    | long_max     |
      | CA     | California | 06        | 0            | -124.409591  | -114.131211  | 32.534156   | 42.009518    |
    And the following counties exist:
      | name        | state | fips_code |
      | Los Angeles | CA    | 06037     |
    And I am on the state map page for "California"



  Scenario: Clicking on a county takes the user to the search page
    When I click on "Los Angeles" county in the map
    Then I should be on the search page for "Los Angeles, CA"
    And I should see representatives for "Los Angeles"
