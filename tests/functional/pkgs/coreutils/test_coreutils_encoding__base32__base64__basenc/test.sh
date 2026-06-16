#!/bin/sh -eux
# Functional test: coreutils - Encoding--base32--base64--basenc

. "../setup.sh"

echo "=== Test 14: Encoding (base32, base64, basenc) ==="

# 14.1 base32
rlRun 'echo "hello" | base32' 0 "base32 encode"
rlRun 'echo "hello" | base32 | base32 -d' 0 "base32 -d decode"

# 14.2 base64
rlRun 'echo "hello" | base64' 0 "base64 encode"
rlRun 'echo "hello" | base64 | base64 -d' 0 "base64 -d decode"

# 14.3 basenc
rlRun 'echo "hello" | basenc --base64' 0 "basenc --base64 encode"

# ===================================================================

. "../teardown.sh"
echo "All coreutils Encoding--base32--base64--basenc tests passed!"
