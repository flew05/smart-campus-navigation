# Jenkins Setup Instructions

Complete guide to configure Jenkins for Smart Campus Navigation System CI/CD pipeline.

## 📋 Prerequisites

- Jenkins running at: http://52.202.161.235:8080
- Admin access: admin / q5eLOvPfkXrj8eZw
- Nexus running at: http://52.202.161.235:8081
- SonarQube running at: http://52.202.161.235:9000

## 🔧 Step 1: Install Required Plugins

1. **Login to Jenkins**
   - Navigate to: http://52.202.161.235:8080
   - Username: `admin`
   - Password: `q5eLOvPfkXrj8eZw`

2. **Go to Plugin Manager**
   - Click `Manage Jenkins` → `Manage Plugins`
   - Click `Available` tab

3. **Install the following plugins:**
   - [ ] Pipeline
   - [ ] Pipeline: Stage View
   - [ ] Git
   - [ ] Maven Integration
   - [ ] SonarQube Scanner
   - [ ] JaCoCo
   - [ ] JUnit
   - [ ] Nexus Artifact Uploader
   - [ ] Config File Provider
   - [ ] Credentials Binding
   - [ ] HTTP Request
   - [ ] Email Extension

4. **Install and Restart**
   - Check `Restart Jenkins when installation is complete`
   - Wait for Jenkins to restart

## 🛠️ Step 2: Configure Global Tools

### Maven Configuration

1. **Go to Global Tool Configuration**
   - `Manage Jenkins` → `Global Tool Configuration`

2. **Configure Maven**
   - Scroll to `Maven` section
   - Click `Add Maven`
   - **Name**: `Maven-3.8.1`
   - **Version**: Select `3.8.1` (or latest)
   - Check `Install automatically`
   - Click `Save`

### JDK Configuration

1. **In Global Tool Configuration**
   - Scroll to `JDK` section
   - Click `Add JDK`
   - **Name**: `JDK-11`
   - **JAVA_HOME**: `/usr/lib/jvm/java-11-openjdk-amd64` (or your JDK path)
   - Or check `Install automatically` and select JDK 11
   - Click `Save`

### Git Configuration

1. **In Global Tool Configuration**
   - Scroll to `Git` section
   - Usually auto-detected
   - If not, click `Add Git`
   - **Name**: `Default`
   - **Path to Git executable**: `git` (or full path)
   - Click `Save`

## 🔐 Step 3: Configure Credentials

### Nexus Credentials

1. **Go to Credentials**
   - `Manage Jenkins` → `Manage Credentials`
   - Click `(global)` domain
   - Click `Add Credentials`

2. **Add Nexus Credentials**
   - **Kind**: `Username with password`
   - **Scope**: `Global`
   - **Username**: `developer`
   - **Password**: `rwPTHw`
   - **ID**: `nexus-credentials`
   - **Description**: `Nexus Repository Manager`
   - Click `Create`

### SonarQube Token (Optional - if using token authentication)

1. **Generate token in SonarQube**
   - Login to SonarQube: http://52.202.161.235:9000
   - Go to `My Account` → `Security` → `Generate Tokens`
   - Name: `jenkins-token`
   - Click `Generate`
   - **Copy the token**

2. **Add to Jenkins**
   - `Manage Jenkins` → `Manage Credentials`
   - Click `Add Credentials`
   - **Kind**: `Secret text`
   - **Scope**: `Global`
   - **Secret**: [paste token]
   - **ID**: `sonar-token`
   - **Description**: `SonarQube Authentication Token`
   - Click `Create`

## 🔍 Step 4: Configure SonarQube

1. **Go to Configure System**
   - `Manage Jenkins` → `Configure System`

2. **Find SonarQube servers section**
   - Scroll to `SonarQube servers`
   - Check `Environment variables` → `Enable injection of SonarQube server configuration`

3. **Add SonarQube Server**
   - Click `Add SonarQube`
   - **Name**: `SonarQube`
   - **Server URL**: `http://52.202.161.235:9000`
   - **Server authentication token**: Select `sonar-token` (if created) or leave empty
   - Click `Save`

## 📦 Step 5: Configure Maven Settings

1. **Go to Managed files**
   - `Manage Jenkins` → `Managed files`

2. **Add Maven settings**
   - Click `Add a new Config`
   - Select `Global Maven settings.xml`
   - **ID**: `maven-settings`
   - **Name**: `Maven Settings with Nexus`

3. **Content**: Copy from `settings.xml` file in project

4. **Click Submit**

## 🚀 Step 6: Create Pipeline Job

1. **Create New Item**
   - From Jenkins dashboard, click `New Item`
   - **Name**: `ExampleProjectPipeline`
   - Select `Pipeline`
   - Click `OK`

2. **General Configuration**
   - **Description**: `Smart Campus Navigation System CI/CD Pipeline`
   - Check `Discard old builds`
     - **Days to keep builds**: 30
     - **Max # of builds to keep**: 10

3. **Build Triggers** (Optional)
   - Check `Poll SCM` for automatic builds
   - **Schedule**: `H/5 * * * *` (every 5 minutes)
   - Or check `GitHub hook trigger` if using GitHub

4. **Pipeline Configuration**

   **Option A: Pipeline from SCM (Recommended)**
   - **Definition**: `Pipeline script from SCM`
   - **SCM**: `Git`
   - **Repository URL**: [Your Git repository URL]
   - **Credentials**: [Add Git credentials if private repo]
   - **Branch**: `*/main` or `*/master`
   - **Script Path**: `Jenkinsfile`

   **Option B: Pipeline Script (Direct)**
   - **Definition**: `Pipeline script`
   - Copy content from `Jenkinsfile` and paste into script window

5. **Click Save**

## ✅ Step 7: Test Pipeline

1. **Run Build**
   - Click `Build Now`
   - Watch build progress in `Build History`

2. **View Console Output**
   - Click on build number (e.g., #1)
   - Click `Console Output`
   - Monitor build progress

3. **Check Stage View**
   - Return to job page
   - View stage progression
   - Identify any failures

## 🔧 Step 8: Configure Nexus (if needed)

### Create Repositories in Nexus

1. **Login to Nexus**
   - URL: http://52.202.161.235:8081
   - Username: `developer`
   - Password: `rwPTHw`

2. **Create Maven Repositories** (if not exist)

   **Maven Releases:**
   - Click `Server administration` (gear icon)
   - Click `Repositories` → `Create repository`
   - Select `maven2 (hosted)`
   - **Name**: `maven-releases`
   - **Version policy**: `Release`
   - **Layout policy**: `Strict`
   - Click `Create repository`

   **Maven Snapshots:**
   - Click `Create repository`
   - Select `maven2 (hosted)`
   - **Name**: `maven-snapshots`
   - **Version policy**: `Snapshot`
   - **Layout policy**: `Strict`
   - Click `Create repository`

   **Maven Public (Group):**
   - Click `Create repository`
   - Select `maven2 (group)`
   - **Name**: `maven-public`
   - **Member repositories**: Add all repositories
     - maven-releases
     - maven-snapshots
     - maven-central (proxy)
   - Click `Create repository`

## 🎯 Step 9: Create SonarQube Project

1. **Login to SonarQube**
   - URL: http://52.202.161.235:9000
   - Username: `developer`
   - Password: `rwPTHw`

2. **Create Project**
   - Click `+` → `Create new project`
   - **Project key**: `smart-campus-navigation`
   - **Display name**: `Smart Campus Navigation System`
   - Click `Set Up`

3. **Configure Analysis**
   - Select `With Jenkins`
   - Follow instructions or use configuration from `sonar-project.properties`

## 🧪 Step 10: Verify Full Pipeline

### Check Each Stage:

1. **✅ Checkout**: Source code retrieved
2. **✅ Build**: Compilation successful
3. **✅ Unit Tests**: Tests passing
4. **✅ SonarQube Analysis**: Code analyzed
5. **✅ Quality Gate**: Quality standards met
6. **✅ Package**: JAR created
7. **✅ Deploy to Nexus**: Artifact uploaded
8. **✅ Deploy Application**: App deployed
9. **✅ Health Check**: App is healthy

### Verify Deployments:

- **Application**: http://52.202.161.235:8888
- **Health Check**: http://52.202.161.235:8888/actuator/health
- **Nexus Artifact**: Check in Nexus UI → Browse → maven-releases
- **SonarQube Report**: Check in SonarQube UI → Projects

## 🐛 Troubleshooting

### Common Issues:

**1. Maven not found**
- Verify Maven installation in Global Tool Configuration
- Check Maven name matches Jenkinsfile (`Maven-3.8.1`)

**2. SonarQube analysis fails**
- Check SonarQube server configuration
- Verify network connectivity: `curl http://52.202.161.235:9000`
- Check credentials

**3. Nexus upload fails**
- Verify credentials are correct
- Check repository names in pom.xml match Nexus
- Verify curl command can reach Nexus

**4. Application deployment fails**
- Check if port 8888 is available
- Verify JAR file was created
- Check application.log for errors

**5. Health check timeout**
- Increase timeout in Jenkinsfile
- Check if application started: `ps aux | grep java`
- Check application logs

## 📊 Monitoring and Maintenance

### View Build History
- Jenkins dashboard → Select job → Build History

### View Test Results
- Build page → Test Results

### View Code Coverage
- Build page → JaCoCo Report

### View SonarQube Report
- Build page → SonarQube link
- Or directly in SonarQube UI

### Clean Workspace
- Uncomment `cleanWs()` in Jenkinsfile post section

## 🔄 Optional Enhancements

### Email Notifications

Add to Jenkinsfile `post` section:

```groovy
post {
    success {
        emailext (
            subject: "✅ Build Success: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
            body: "Build successful!",
            to: "team@example.com"
        )
    }
    failure {
        emailext (
            subject: "❌ Build Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
            body: "Build failed! Check console output.",
            to: "team@example.com"
        )
    }
}
```

### Slack Notifications

Install Slack Notification plugin and configure webhook.

### Build Parameters

Add parameters to pipeline for flexibility:

```groovy
parameters {
    choice(name: 'ENVIRONMENT', choices: ['dev', 'staging', 'prod'])
    booleanParam(name: 'SKIP_TESTS', defaultValue: false)
}
```

---

## ✅ Setup Complete!

Your Jenkins CI/CD pipeline is now configured and ready to use!

**Next Steps:**
1. Push code to Git repository
2. Jenkins will automatically build
3. Monitor build progress
4. Check deployed application
5. Review code quality in SonarQube

For questions or issues, refer to this guide or check Jenkins documentation.

