# Smart Campus Navigation System

A Spring Boot application for campus navigation with REST API.

## About

This project provides a REST API for navigating around a university campus. Users can search for locations, calculate routes, and check room availability.

## Technologies

- Java 11
- Spring Boot 2.7.17
- Maven
- H2 Database
- JUnit 5

## Build and Run

### Requirements
- Java 11 or higher
- Maven 3.6+

### Build
```bash
mvn clean package
```

### Run
```bash
java -jar target/smart-campus-navigation-1.0.0-SNAPSHOT.jar
```

The application will start on port 8888.

## API Endpoints

### Health Check
```
GET /actuator/health
```

### Navigation API
```
GET /api/navigation/
```
Returns welcome message

```
POST /api/navigation/route
Content-Type: application/json

{
  "from": "Building A",
  "to": "Building B",
  "userId": "user123",
  "accessibilityRequired": false
}
```
Calculates route between two locations

```
GET /api/navigation/location/{locationId}
```
Gets location details

```
GET /api/navigation/room/{roomId}/availability
```
Checks room availability

## Testing

Run tests:
```bash
mvn test
```

## Docker

Build image:
```bash
docker build -t smart-campus-navigation .
```

Run container:
```bash
docker-compose up
```

## CI/CD

The project includes:
- Jenkinsfile for CI/CD pipeline
- SonarQube configuration
- Nexus deployment setup

## Configuration

Application settings are in `src/main/resources/application.properties`

Default configuration:
- Port: 8888
- Database: H2 (in-memory)
- Context path: /

## Project Structure

```
src/
├── main/
│   ├── java/com/smartcampus/navigation/
│   │   ├── SmartCampusNavigationApplication.java
│   │   ├── controller/
│   │   │   └── NavigationController.java
│   │   ├── service/
│   │   │   └── NavigationService.java
│   │   └── dto/
│   │       ├── RouteRequest.java
│   │       └── RouteResponse.java
│   └── resources/
│       └── application.properties
└── test/
    └── java/com/smartcampus/navigation/
        ├── SmartCampusNavigationApplicationTests.java
        ├── controller/
        │   └── NavigationControllerTest.java
        └── service/
            └── NavigationServiceTest.java
```

## Notes

This is a course project for DevOps/CI-CD practice.

## License

MIT
