#!/bin/bash
echo "Testing new wait logic..."
response_code=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 --max-time 10 http://localhost:5000 || echo "000")
echo "Response code: $response_code"
if [ "$response_code" -eq "401" ] || [ "$response_code" -eq "200" ] || [ "$response_code" -eq "403" ]; then
  echo "✅ Application is ready! (HTTP $response_code)"
else
  echo "❌ Application not ready (HTTP $response_code)"
fi
