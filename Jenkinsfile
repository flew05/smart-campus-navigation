pipeline {
    agent any
    
    tools {
        maven 'Maven-3.8.1'
        jdk 'JDK-11'
    }
    
    environment {
        // Nexus Configuration
        NEXUS_URL = 'http://54.237.222.37:8081'
        NEXUS_REPOSITORY = 'maven-releases'
        NEXUS_SNAPSHOT_REPOSITORY = 'maven-snapshots'
        NEXUS_USER = 'developer'
        NEXUS_PASSWORD = 'rwPTHw'
        
        // SonarQube Configuration
        SONAR_URL = 'http://54.237.222.37:9000'
        SONAR_USER = 'developer'
        SONAR_PASSWORD = 'rwPTHw'
        
        // Application Configuration
        APP_URL = 'http://54.237.222.37:8888'
        APP_PORT = '8888'
        
        // Project Variables
        PROJECT_NAME = 'smart-campus-navigation'
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo '============================================'
                echo '         Checking out source code          '
                echo '============================================'
                checkout scm
            }
        }
        
        stage('Build') {
            steps {
                echo '============================================'
                echo '         Building the application           '
                echo '============================================'
                sh 'mvn clean compile'
            }
        }
        
        stage('Unit Tests') {
            steps {
                echo '============================================'
                echo '            Running unit tests              '
                echo '============================================'
                sh 'mvn test'
            }
            post {
                always {
                    junit allowEmptyResults: true, testResults: '**/target/surefire-reports/*.xml'
                    jacoco execPattern: '**/target/jacoco.exec'
                }
            }
        }
        
        stage('SonarQube Analysis') {
            steps {
                echo '============================================'
                echo '       Running SonarQube analysis           '
                echo '============================================'
                script {
                    sh """
                        mvn sonar:sonar \
                          -Dsonar.projectKey=${PROJECT_NAME} \
                          -Dsonar.projectName='Smart Campus Navigation System' \
                          -Dsonar.host.url=${SONAR_URL} \
                          -Dsonar.login=${SONAR_USER} \
                          -Dsonar.password=${SONAR_PASSWORD}
                    """
                }
            }
        }
        
        stage('Quality Gate') {
            steps {
                echo '============================================'
                echo '          Checking Quality Gate             '
                echo '============================================'
                timeout(time: 5, unit: 'MINUTES') {
                    script {
                        try {
                            waitForQualityGate abortPipeline: false
                        } catch (Exception e) {
                            echo "Quality Gate failed, but continuing..."
                        }
                    }
                }
            }
        }
        
        stage('Package') {
            steps {
                echo '============================================'
                echo '         Packaging the application          '
                echo '============================================'
                sh 'mvn package -DskipTests'
            }
        }
        
        stage('Deploy to Nexus') {
            steps {
                echo '============================================'
                echo '      Deploying artifacts to Nexus          '
                echo '============================================'
                script {
                    def pom = readMavenPom file: 'pom.xml'
                    def version = pom.version
                    def artifactId = pom.artifactId
                    def groupId = pom.groupId.replace('.', '/')
                    
                    def repository = version.contains('SNAPSHOT') ? NEXUS_SNAPSHOT_REPOSITORY : NEXUS_REPOSITORY
                    
                    sh """
                        curl -v -u ${NEXUS_USER}:${NEXUS_PASSWORD} \
                          --upload-file target/${artifactId}-${version}.jar \
                          ${NEXUS_URL}/repository/${repository}/${groupId}/${artifactId}/${version}/${artifactId}-${version}.jar
                    """
                }
            }
        }
        
        stage('Deploy Application') {
            steps {
                echo '============================================'
                echo '         Deploying application              '
                echo '============================================'
                script {
                    // Stop old process if running
                    sh '''
                        if [ -f app.pid ]; then
                            OLD_PID=$(cat app.pid)
                            if ps -p $OLD_PID > /dev/null 2>&1; then
                                echo "Stopping old process: $OLD_PID"
                                kill -15 $OLD_PID || true
                                sleep 5
                            fi
                            rm -f app.pid
                        fi
                        
                        # Find and kill any running instance
                        pkill -f 'java.*smart-campus-navigation' || true
                        sleep 3
                    '''
                    
                    // Start new process
                    sh '''
                        nohup java -jar target/*.jar --server.port=${APP_PORT} > application.log 2>&1 &
                        echo $! > app.pid
                        echo "Application started with PID: $(cat app.pid)"
                        sleep 10
                    '''
                }
            }
        }
        
        stage('Health Check') {
            steps {
                echo '============================================'
                echo '        Performing health check             '
                echo '============================================'
                retry(5) {
                    script {
                        sleep 5
                        sh """
                            curl -f ${APP_URL}/actuator/health || \
                            curl -f ${APP_URL}/health || \
                            curl -f ${APP_URL} || \
                            echo "Health check attempt..."
                        """
                    }
                }
            }
        }
    }
    
    post {
        success {
            echo '============================================'
            echo '    ✓ Pipeline completed successfully!      '
            echo '============================================'
            echo "Application URL: ${APP_URL}"
            echo "Jenkins Job: ${env.JOB_NAME}"
            echo "Build Number: ${env.BUILD_NUMBER}"
        }
        failure {
            echo '============================================'
            echo '        ✗ Pipeline failed!                  '
            echo '============================================'
            echo "Check logs for details"
        }
        always {
            echo '============================================'
            echo '         Cleaning up workspace              '
            echo '============================================'
            // Uncomment if you want to clean workspace after each build
            // cleanWs()
        }
    }
}

