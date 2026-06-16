#!/bin/sh -eux
# Functional test: psmisc - pstree-with-options

. "../setup.sh"

echo "=== Test 6: pstree with options ==="

# Show PIDs
pstree -p | head -10

# Show numeric sort
pstree -n | head -10

# Compact tree
pstree -c | head -10

# Highlight current process
pstree -h | head -10

# Show full details
pstree -a | head -10

# Show only one user's processes
pstree root | head -10

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All psmisc pstree-with-options tests passed!"
