#!/bin/bash

set -e

# =====================================================
# Smart Campus Navigation System - Deployment Script
# =====================================================

echo "============================================="
echo "  Smart Campus Navigation - Deployment"
echo "============================================="

# Variables
APP_NAME="smart-campus-navigation"
JAR_PATTERN="target/${APP_NAME}-*.jar"
APP_PORT=8888
PID_FILE="app.pid"
LOG_FILE="application.log"
HEALTH_ENDPOINT="http://localhost:${APP_PORT}/actuator/health"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function: Print colored message
print_msg() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function: Stop running application
stop_app() {
    print_msg "$YELLOW" "Stopping application..."
    
    if [ -f "$PID_FILE" ]; then
        PID=$(cat $PID_FILE)
        if ps -p $PID > /dev/null 2>&1; then
            kill -15 $PID
            print_msg "$GREEN" "✓ Application stopped (PID: $PID)"
            rm -f $PID_FILE
        else
            print_msg "$YELLOW" "Application not running (PID file exists but process not found)"
            rm -f $PID_FILE
        fi
    else
        print_msg "$YELLOW" "PID file not found, checking for running processes..."
        RUNNING_PID=$(ps aux | grep 'java.*smart-campus-navigation' | grep -v grep | awk '{print $2}')
        if [ ! -z "$RUNNING_PID" ]; then
            kill -15 $RUNNING_PID
            print_msg "$GREEN" "✓ Stopped running process (PID: $RUNNING_PID)"
        else
            print_msg "$YELLOW" "No running application found"
        fi
    fi
    
    sleep 3
}

# Function: Start application
start_app() {
    print_msg "$YELLOW" "Starting application..."
    
    # Find JAR file
    JAR_FILE=$(ls $JAR_PATTERN 2>/dev/null | head -n 1)
    
    if [ -z "$JAR_FILE" ]; then
        print_msg "$RED" "✗ JAR file not found! Please build the project first."
        print_msg "$YELLOW" "Run: mvn clean package"
        exit 1
    fi
    
    print_msg "$GREEN" "Found JAR: $JAR_FILE"
    
    # Start application
    nohup java -jar "$JAR_FILE" > "$LOG_FILE" 2>&1 &
    echo $! > $PID_FILE
    
    print_msg "$GREEN" "✓ Application started (PID: $(cat $PID_FILE))"
}

# Function: Health check
health_check() {
    print_msg "$YELLOW" "Performing health check..."
    
    local max_attempts=15
    local attempt=0
    local wait_time=5
    
    while [ $attempt -lt $max_attempts ]; do
        sleep $wait_time
        
        if curl -sf "$HEALTH_ENDPOINT" > /dev/null 2>&1; then
            print_msg "$GREEN" "✓ Application is healthy!"
            print_msg "$GREEN" "✓ Health endpoint: $HEALTH_ENDPOINT"
            return 0
        fi
        
        attempt=$((attempt + 1))
        print_msg "$YELLOW" "Waiting for application to start... ($attempt/$max_attempts)"
    done
    
    print_msg "$RED" "✗ Health check failed after $max_attempts attempts!"
    print_msg "$YELLOW" "Check $LOG_FILE for details"
    return 1
}

# Function: Show logs
show_logs() {
    if [ -f "$LOG_FILE" ]; then
        print_msg "$YELLOW" "\n=== Last 20 lines of log ==="
        tail -n 20 "$LOG_FILE"
    fi
}

# Function: Build project
build_project() {
    print_msg "$YELLOW" "Building project..."
    
    if ! command -v mvn &> /dev/null; then
        print_msg "$RED" "✗ Maven not found! Please install Maven."
        exit 1
    fi
    
    mvn clean package -DskipTests
    
    if [ $? -eq 0 ]; then
        print_msg "$GREEN" "✓ Build successful"
    else
        print_msg "$RED" "✗ Build failed"
        exit 1
    fi
}

# Main deployment flow
main() {
    print_msg "$GREEN" "Starting deployment process..."
    echo
    
    # Parse command line arguments
    case "${1:-deploy}" in
        build)
            build_project
            ;;
        start)
            start_app
            health_check
            ;;
        stop)
            stop_app
            ;;
        restart)
            stop_app
            start_app
            health_check
            ;;
        deploy)
            # Full deployment
            stop_app
            echo
            
            # Check if JAR exists, if not build
            if [ ! -f $(ls $JAR_PATTERN 2>/dev/null | head -n 1) ]; then
                print_msg "$YELLOW" "JAR file not found, building project..."
                build_project
                echo
            fi
            
            start_app
            echo
            
            if health_check; then
                echo
                print_msg "$GREEN" "============================================="
                print_msg "$GREEN" "  ✓ Deployment completed successfully!"
                print_msg "$GREEN" "============================================="
                print_msg "$GREEN" "Application URL: http://localhost:$APP_PORT"
                print_msg "$GREEN" "Health Check: $HEALTH_ENDPOINT"
                print_msg "$GREEN" "API Documentation: http://localhost:$APP_PORT/api/navigation/"
                print_msg "$GREEN" "============================================="
                exit 0
            else
                echo
                print_msg "$RED" "============================================="
                print_msg "$RED" "  ✗ Deployment failed!"
                print_msg "$RED" "============================================="
                show_logs
                stop_app
                exit 1
            fi
            ;;
        logs)
            show_logs
            ;;
        status)
            if [ -f "$PID_FILE" ]; then
                PID=$(cat $PID_FILE)
                if ps -p $PID > /dev/null 2>&1; then
                    print_msg "$GREEN" "✓ Application is running (PID: $PID)"
                    curl -s "$HEALTH_ENDPOINT" | json_pp 2>/dev/null || curl -s "$HEALTH_ENDPOINT"
                else
                    print_msg "$RED" "✗ Application is not running"
                fi
            else
                print_msg "$RED" "✗ Application is not running"
            fi
            ;;
        *)
            print_msg "$YELLOW" "Usage: $0 {build|start|stop|restart|deploy|logs|status}"
            print_msg "$YELLOW" "  build   - Build the project"
            print_msg "$YELLOW" "  start   - Start the application"
            print_msg "$YELLOW" "  stop    - Stop the application"
            print_msg "$YELLOW" "  restart - Restart the application"
            print_msg "$YELLOW" "  deploy  - Full deployment (stop, build if needed, start)"
            print_msg "$YELLOW" "  logs    - Show application logs"
            print_msg "$YELLOW" "  status  - Check application status"
            exit 1
            ;;
    esac
}

# Run main function
main "$@"

