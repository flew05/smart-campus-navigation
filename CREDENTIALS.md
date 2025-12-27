# Deployment Credentials

## Jenkins
- URL: http://54.237.222.37:8080
- User: admin
- Password: jGntpecvcs6wQxS1
- Job: ExampleProjectPipeline

## Nexus
- URL: http://54.237.222.37:8081
- User: developer
- Password: rwPTHw

## SonarQube
- URL: http://54.237.222.37:9000
- User: developer
- Password: rwPTHw

## Application
- URL: http://54.237.222.37:8888

---

**Note:** All credentials are configured in:
- `Jenkinsfile` (environment section)
- `pom.xml` (distributionManagement and repositories)
- `settings.xml` (servers and mirrors)

