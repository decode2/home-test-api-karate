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
    And match response.id == '3'
    And match response.name == 'Baked Rolls x 8'
    And match response.price == '#present'

  # Requirement 3 & 6: Add Item (E2E Test)
  Scenario: Add a new item successfully and verify persistence
    # Generate a unique ID for this specific scenario execution
    * def uniqueId = uuid()
    * def newItem =
    """
    {
      "id": "#(uniqueId)",
      "name": "Java 17 Special",
      "image": "java_logo.png",
      "price": "$50"
    }
    """
    
    # 1. Create the item
    Given path 'inventory/add'
    And request newItem
    When method post
    Then status 200

    # 2. Verify it exists in the list (Regression)
    Given path 'inventory'
    When method get
    Then status 200
    # Search inside the 'data' array
    And match response.data contains deep { "id": "#(uniqueId)", "name": "Java 17 Special" }

  # Requirement 4: Error handling for duplicates
  Scenario: Validate error response when adding a duplicate ID
    * def fixedId = '9999'
    * def payload = { "id": fixedId, "name": "Duplicate", "image": "dup.png", "price": "$5" }
    
    # Pre-condition: Ensure item exists (Happy Path)
    # We ignore 400 here because it might already exist from a previous run
    Given path 'inventory/add'
    And request payload
    When method post
    
    # Test: Try to add the same item again
    Given path 'inventory/add'
    And request payload
    When method post
    Then status 400

  # Requirement 5: Error handling for invalid payload
  Scenario: Validate error when mandatory fields are missing
    Given path 'inventory/add'
    # Payload missing 'id' field
    And request { "name": "Invalid Item", "price": "$0" }
    When method post
    Then status 400
    And match response contains "Not all requirements are met"