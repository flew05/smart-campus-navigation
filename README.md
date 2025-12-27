# Smart Campus Navigation System

Smart Campus Navigation System for University - A comprehensive navigation solution with CI/CD pipeline.

## 🚀 Features

- **Route Calculation**: Calculate optimal routes between campus locations
- **Room Availability**: Check real-time room availability
- **User Location Tracking**: Track and retrieve user locations
- **Accessibility Support**: Routes optimized for accessibility requirements
- **Health Monitoring**: Built-in health checks and monitoring

## 🏗️ Architecture

- **Backend**: Spring Boot 2.7.17
- **Database**: H2 (in-memory for development)
- **Build Tool**: Maven 3.8+
- **Java Version**: 11

## 📋 Prerequisites

- Java 11 or higher
- Maven 3.8 or higher
- Git

## 🔧 CI/CD Infrastructure

### Jenkins
- **URL**: http://52.202.161.235:8080
- **User**: admin
- **Pipeline**: ExampleProjectPipeline

### Nexus
- **URL**: http://52.202.161.235:8081
- **User**: developer
- **Repositories**: maven-releases, maven-snapshots, maven-public

### SonarQube
- **URL**: http://52.202.161.235:9000
- **User**: developer
- **Analysis**: Code quality and security scanning

### Application
- **URL**: http://52.202.161.235:8888
- **Health**: http://52.202.161.235:8888/actuator/health

## 🏃 Quick Start

### Local Development

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd Project\ 1
   ```

2. **Build the project**
   ```bash
   mvn clean package
   ```

3. **Run the application**
   ```bash
   java -jar target/smart-campus-navigation-1.0.0-SNAPSHOT.jar
   ```

4. **Access the application**
   - Application: http://localhost:8888
   - Health Check: http://localhost:8888/actuator/health
   - API: http://localhost:8888/api/navigation/

### Using Deployment Script

```bash
# Make script executable
chmod +x deploy.sh

# Full deployment
./deploy.sh deploy

# Other commands
./deploy.sh build    # Build project
./deploy.sh start    # Start application
./deploy.sh stop     # Stop application
./deploy.sh restart  # Restart application
./deploy.sh logs     # Show logs
./deploy.sh status   # Check status
```

### Using Docker

```bash
# Build and run with Docker Compose
docker-compose up -d

# Check status
docker-compose ps

# View logs
docker-compose logs -f

# Stop
docker-compose down
```

## 📡 API Endpoints

### Navigation API

- **GET** `/api/navigation/` - Welcome message
- **POST** `/api/navigation/route` - Calculate route
- **GET** `/api/navigation/location/{userId}` - Get user location
- **GET** `/api/navigation/room/{roomId}/availability` - Check room availability
- **GET** `/api/navigation/health` - Health check

### Example: Calculate Route

```bash
curl -X POST http://localhost:8888/api/navigation/route \
  -H "Content-Type: application/json" \
  -d '{
    "from": "Building A",
    "to": "Building B",
    "userId": "user123",
    "accessibilityRequired": false
  }'
```

## 🔄 CI/CD Pipeline

The Jenkins pipeline includes the following stages:

1. **Checkout** - Get source code from repository
2. **Build** - Compile the application
3. **Unit Tests** - Run JUnit tests with JaCoCo coverage
4. **SonarQube Analysis** - Code quality analysis
5. **Quality Gate** - Verify code quality standards
6. **Package** - Create JAR artifact
7. **Deploy to Nexus** - Upload artifact to Nexus repository
8. **Deploy Application** - Deploy to application server
9. **Health Check** - Verify deployment success

## 🧪 Testing

### Run all tests
```bash
mvn test
```

### Run with coverage report
```bash
mvn clean test jacoco:report
```

### View coverage report
Open `target/site/jacoco/index.html` in browser

## 📊 Code Quality

### Run SonarQube analysis locally
```bash
mvn clean verify sonar:sonar \
  -Dsonar.projectKey=smart-campus-navigation \
  -Dsonar.host.url=http://52.202.161.235:9000 \
  -Dsonar.login=developer \
  -Dsonar.password=rwPTHw
```

## 🔐 Configuration

### Maven Settings

Copy `settings.xml` to `~/.m2/settings.xml` to configure Nexus authentication and mirrors.

### Application Properties

Configuration file: `src/main/resources/application.properties`

Key properties:
- `server.port` - Application port (default: 8888)
- `spring.datasource.url` - Database URL
- `management.endpoints.web.exposure.include` - Actuator endpoints

## 📁 Project Structure

```
Project 1/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/smartcampus/navigation/
│   │   │       ├── SmartCampusNavigationApplication.java
│   │   │       ├── controller/
│   │   │       ├── service/
│   │   │       └── dto/
│   │   └── resources/
│   │       └── application.properties
│   └── test/
│       └── java/
│           └── com/smartcampus/navigation/
├── pom.xml
├── Jenkinsfile
├── Dockerfile
├── docker-compose.yml
├── deploy.sh
├── settings.xml
├── sonar-project.properties
└── README.md
```

## 🐛 Troubleshooting

### Application won't start
1. Check if port 8888 is already in use: `netstat -an | grep 8888`
2. Check logs: `tail -f application.log`
3. Verify Java version: `java -version`

### Build fails
1. Clean Maven cache: `mvn clean`
2. Update dependencies: `mvn dependency:purge-local-repository`
3. Check Maven settings: `~/.m2/settings.xml`

### Tests fail
1. Check test logs: `target/surefire-reports/`
2. Run specific test: `mvn test -Dtest=TestClassName`

## 📝 Development Workflow

1. Create feature branch: `git checkout -b feature/your-feature`
2. Make changes and commit: `git commit -m "Description"`
3. Push to repository: `git push origin feature/your-feature`
4. Jenkins automatically triggers build and deployment
5. Monitor pipeline progress in Jenkins UI

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📄 License

This project is licensed under the MIT License.

## 👥 Team

Smart Campus Navigation System Development Team

## 📞 Support

For support and questions, please contact the development team.

---

**Built with ❤️ for University Campus Navigation**

