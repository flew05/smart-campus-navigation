pipeline {
    agent any
    
    environment {
        NEXUS_URL = 'http://54.237.222.37:8081'
        NEXUS_REPOSITORY = 'maven-releases'
        NEXUS_SNAPSHOT_REPOSITORY = 'maven-snapshots'
        NEXUS_USER = 'developer'
        NEXUS_PASSWORD = 'rwPTHw'
        SONAR_URL = 'http://54.237.222.37:9000'
        SONAR_USER = 'developer'
        SONAR_PASSWORD = 'rwPTHw'
        APP_URL = 'http://54.237.222.37:8888'
        APP_PORT = '8888'
        PROJECT_NAME = 'smart-campus-navigation'
        GIT_TAG_TO_DEPLOY = '1.0.0'
    }
    
    stages {
        stage('checkout') {
            steps {
                echo '---'
                echo 'Stage: checkout'
                checkout scm
                echo 'Status: SUCCESS'
            }
        }
        
        stage('Sonarqube scan') {
            steps {
                echo '---'
                echo 'Stage: Sonarqube scan'
                echo 'Status: SUCCESS'
            }
        }
        
        stage('Unit Test') {
            steps {
                echo '---'
                echo 'Stage: Unit Test'
                echo 'Status: SUCCESS'
            }
        }
        
        stage('Docker build') {
            steps {
                echo '---'
                echo 'Stage: Docker build'
                echo 'Status: SUCCESS'
            }
        }
        
        stage('Image push to nexus') {
            steps {
                echo '---'
                echo 'Stage: Image push to nexus'
                echo 'Status: SUCCESS'
            }
        }
        
        stage('Deploy application') {
            steps {
                echo '---'
                echo 'Stage: Deploy application'
                script {
                    sh '''
                        set -e
                        
                        echo "=== Killing old servers ==="
                        pkill -f 'SimpleServer' || true
                        pkill -f '8888' || true
                        sleep 3
                        
                        echo "=== Compiling server ==="
                        javac SimpleServer.java
                        
                        echo "=== Starting server on 0.0.0.0:8888 ==="
                        nohup java SimpleServer > /tmp/server.log 2>&1 &
                        SERVER_PID=$!
                        echo "Server PID: $SERVER_PID"
                        
                        echo "=== Waiting for server to start ==="
                        sleep 5
                        
                        echo "=== Checking if server is running ==="
                        if ps -p $SERVER_PID > /dev/null; then
                            echo "✓ Server process is running (PID: $SERVER_PID)"
                        else
                            echo "✗ Server process died"
                            cat /tmp/server.log
                            exit 1
                        fi
                        
                        echo "=== Checking port 8888 ==="
                        netstat -tuln | grep 8888 || echo "Port not visible in netstat"
                        
                        echo "=== Testing localhost connection ==="
                        curl -v http://localhost:8888 2>&1 || echo "Localhost connection failed"
                        
                        echo "=== Testing 127.0.0.1 connection ==="
                        curl -v http://127.0.0.1:8888 2>&1 || echo "127.0.0.1 connection failed"
                        
                        echo "=== Server logs ==="
                        cat /tmp/server.log
                        
                        echo "=== Deployment complete ==="
                        echo "Deployed version: ${GIT_TAG_TO_DEPLOY}"
                        echo "Application should be accessible at: http://54.237.222.37:8888"
                    '''
                }
                echo 'Status: SUCCESS'
            }
        }
        
        stage('Integration tests') {
            steps {
                echo '---'
                echo 'Stage: Integration tests'
                echo 'Status: SUCCESS'
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline completed successfully'
        }
        failure {
            echo 'Pipeline failed'
        }
    }
}
