Feature: Inventory API Automation Scenarios

  Background:
    * url baseUrl

  # Requirement 1: Get all menu items & Validate Data Contract
  Scenario: Validate inventory listing schema and minimum size
    Given path 'inventory'
    When method get
    Then status 200
    # Validate array size using JS expression
    And assert response.data.length >= 9
    # Validate schema for each item inside the data array
    And match each response.data == 
    """
    { 
      id: '#string', 
      name: '#string', 
      price: '#string', 
      image: '#string' 
    }
    """

  # Requirement 2: Filter by id
  Scenario: Validate filtering logic returns specific item
    Given path 'inventory/filter'
    And param id = '3'
    When method get
    Then status 200
    # API returns a single object { ... }
    # Validate all required fields: id, name, price, image
    And match response.id == '3'
    And match response.name == 'Baked Rolls x 8'
    And match response.price == '#string'
    And match response.image == '#string'

  # Requirement 3: Add item for non existent id
  Scenario: Add a new item successfully with id 10
    * def newItem =
    """
    {
      "id": "10",
      "name": "Hawaiian",
      "image": "hawaiian.png",
      "price": "$14"
    }
    """
    
    # Create the item with id 10
    Given path 'inventory/add'
    And request newItem
    When method post
    Then status 200

  # Requirement 4: Add item for existent id
  Scenario: Validate error response when adding a duplicate ID
    * def payload = 
    """
    {
      "id": "10",
      "name": "Hawaiian",
      "image": "hawaiian.png",
      "price": "$14"
    }
    """
    
    # Try to add item with id 10 again (should already exist from Requirement 3)
    Given path 'inventory/add'
    And request payload
    When method post
    Then status 400

  # Requirement 5: Error handling for invalid payload
  Scenario: Validate error when mandatory fields are missing
    * def invalidPayload = { "name": "Invalid Item", "price": "$0" }
    Given path 'inventory/add'
    # Payload missing 'id' field
    And request invalidPayload
    When method post
    Then status 400
    And match response contains "Not all requirements are met"

  # Requirement 6: Validate recent added item is present in the inventory
  Scenario: Verify item added in step 3 is present with correct data
    * def expectedItem = { id: "10", name: "Hawaiian", image: "hawaiian.png", price: "$14" }
    Given path 'inventory'
    When method get
    Then status 200
    # Validate that the item with id "10" is present with correct data
    And match response.data contains deep expectedItem