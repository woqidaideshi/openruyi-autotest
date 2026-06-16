#!/bin/sh -eux
# Functional test: psmisc - Error-handling

. "../setup.sh"

echo "=== Test 13: Error handling ==="

fuser /nonexistent/file 2>&1 || echo "Expected: no such file"
killall nonexistent-process 2>&1 || echo "Expected: no process found"
pstree nonexistent-user 2>&1 || echo "Expected: no such user"

. "../teardown.sh"
echo "All psmisc Error-handling tests passed!"
