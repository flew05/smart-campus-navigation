#!/bin/bash

# =====================================================
# Smart Campus Navigation - API Testing Script
# =====================================================

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
BASE_URL="${1:-http://localhost:8888}"
API_URL="${BASE_URL}/api/navigation"

echo -e "${BLUE}=============================================${NC}"
echo -e "${BLUE}  Smart Campus Navigation - API Tests${NC}"
echo -e "${BLUE}  Testing URL: ${BASE_URL}${NC}"
echo -e "${BLUE}=============================================${NC}"
echo

# Function to test endpoint
test_endpoint() {
    local method=$1
    local endpoint=$2
    local data=$3
    local description=$4
    
    echo -e "${YELLOW}Testing: ${description}${NC}"
    echo -e "${BLUE}${method} ${endpoint}${NC}"
    
    if [ -z "$data" ]; then
        response=$(curl -s -w "\n%{http_code}" -X ${method} "${endpoint}")
    else
        response=$(curl -s -w "\n%{http_code}" -X ${method} "${endpoint}" \
            -H "Content-Type: application/json" \
            -d "${data}")
    fi
    
    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')
    
    if [ "$http_code" -ge 200 ] && [ "$http_code" -lt 300 ]; then
        echo -e "${GREEN}✓ Success (HTTP ${http_code})${NC}"
        echo "$body" | python -m json.tool 2>/dev/null || echo "$body"
    else
        echo -e "${RED}✗ Failed (HTTP ${http_code})${NC}"
        echo "$body"
    fi
    
    echo
}

# Test 1: Welcome endpoint
test_endpoint "GET" "${API_URL}/" "" "Welcome Message"

# Test 2: Health check
test_endpoint "GET" "${API_URL}/health" "" "Health Check"

# Test 3: Actuator health
test_endpoint "GET" "${BASE_URL}/actuator/health" "" "Actuator Health"

# Test 4: Calculate route
route_request='{
    "from": "Building A - Main Entrance",
    "to": "Building B - Room 201",
    "userId": "student123",
    "accessibilityRequired": false
}'
test_endpoint "POST" "${API_URL}/route" "$route_request" "Calculate Route"

# Test 5: Calculate route with accessibility
accessible_route='{
    "from": "Library",
    "to": "Computer Science Department",
    "userId": "professor456",
    "accessibilityRequired": true
}'
test_endpoint "POST" "${API_URL}/route" "$accessible_route" "Calculate Accessible Route"

# Test 6: Get user location
test_endpoint "GET" "${API_URL}/location/student123" "" "Get User Location"

# Test 7: Check room availability
test_endpoint "GET" "${API_URL}/room/room101/availability" "" "Check Room Availability (room101)"

# Test 8: Check another room
test_endpoint "GET" "${API_URL}/room/auditorium-main/availability" "" "Check Room Availability (auditorium)"

# Summary
echo -e "${BLUE}=============================================${NC}"
echo -e "${GREEN}  API Testing Complete!${NC}"
echo -e "${BLUE}=============================================${NC}"
echo
echo -e "You can also test manually:"
echo -e "  ${YELLOW}curl ${API_URL}/${NC}"
echo -e "  ${YELLOW}curl ${BASE_URL}/actuator/health${NC}"
echo
echo -e "View in browser:"
echo -e "  ${YELLOW}${BASE_URL}/api/navigation/${NC}"
echo -e "  ${YELLOW}${BASE_URL}/actuator/health${NC}"
echo

