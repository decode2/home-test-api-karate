# Inventory API Test - Karate Framework

This repository contains the SDET technical test solution, implemented using **Java 17** and **Karate DSL**.

## Tech Stack

* **Language:** Java 17 (LTS)
* **Framework:** Karate 1.4.1
* **Build Tool:** Maven

## Prerequisites

* Java 17 or higher
* Maven 3.6+
* Docker (for running the API)

## Environment Setup

### 1. Start the API Server

Pull and run the Docker container:

```bash
docker pull automaticbytes/demo-app
docker run -p 3100:3100 automaticbytes/demo-app
```

**Important:** Before running the tests, ensure the Docker container is freshly started. The tests expect certain items to not exist initially (specifically id "10"). If you've run the tests before, restart the container:

```bash
# Stop any running container
docker stop $(docker ps -q --filter ancestor=automaticbytes/demo-app)

# Start a fresh container
docker run -p 3100:3100 automaticbytes/demo-app
```

**Note for Windows/AMD64 users:** The Docker image targets `linux/arm64` architecture. If you encounter issues, you may need to enable QEMU emulation:

```bash
docker run --privileged --rm tonistiigi/binfmt --install all
```

### 2. Verify API is Running

Verify the API is accessible at: `http://localhost:3100/api`

You can test it manually:
```bash
curl http://localhost:3100/api/inventory
```

## Build and Run Tests

### Build the Project

```bash
mvn clean compile
```

### Run All Tests

```bash
mvn test
```

### Run Tests with Maven Surefire

```bash
mvn surefire:test
```

### Run Specific Test Class

```bash
mvn test -Dtest=InventoryRunner
```

## Test Reports

After running the tests, you can find the reports in:

* **Karate HTML Reports:** `target/karate-reports/karate-summary.html`
* **Surefire Reports:** `target/surefire-reports/`

## Test Scenarios

The test suite covers the following scenarios:

1. **Get all menu items** - Validates inventory listing with at least 9 items and schema validation
2. **Filter by id** - Validates filtering by ID returns correct item data
3. **Add item for non-existent id** - Tests successful item creation
4. **Add item for existent id** - Tests error handling for duplicate IDs
5. **Add item with missing information** - Tests validation for incomplete payloads
6. **Validate recent added item** - Verifies item persistence in inventory

## Project Structure

```
src/test/java/
├── examples/
│   ├── inventory/
│   │   └── inventory.feature    # Gherkin test scenarios
│   └── InventoryRunner.java     # JUnit 5 test runner
└── karate-config.js              # Karate configuration
```

## Configuration

The base URL is configured in `karate-config.js` and defaults to `http://localhost:3100/api`.

You can override the environment using:
```bash
mvn test -Dkarate.env=dev
```
