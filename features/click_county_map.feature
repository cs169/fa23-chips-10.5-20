Feature: County Map Functionality For Getting Representatives
  Scenario: Clicking on Del Norte County to get the representatives
    Given that I am on state CA on map
    When I click on Del Norte County
    Then I should see Jeff Harris, Katherine Micks, Clinton Schaad, Alissia Northrup, Garrett Scott, Jennifer Perry, Barbara Lopez in the list of representatives
