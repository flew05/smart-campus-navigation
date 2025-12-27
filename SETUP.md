# Quick Setup

## Prerequisites
- Java 11+
- Maven 3.6+

## Local Development

Build:
```bash
mvn clean package
```

Run:
```bash
java -jar target/smart-campus-navigation-1.0.0-SNAPSHOT.jar
```

Test:
```bash
curl http://localhost:8888/actuator/health
```

## Jenkins Deployment

1. Create GitHub repo and push code
2. In Jenkins: New Item → Name: `ExampleProjectPipeline` → Pipeline
3. Configure:
   - Definition: Pipeline script from SCM
   - SCM: Git
   - Repository URL: your-repo-url
   - Branch: */main
   - Script Path: Jenkinsfile
4. Build Now

## Environment

- Port: 8888
- Database: H2 (in-memory)
- Nexus: http://52.202.161.235:8081
- SonarQube: http://52.202.161.235:9000
- Deployed app: http://52.202.161.235:8888

