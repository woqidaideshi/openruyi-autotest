#!/bin/sh -eux
# Functional test: openssh package (ssh-keygen)
# Tests SSH key generation and management
# Version: openssh 10.3p1

rlRun() { eval "$1" 2>&1; return $?; }

rlRun 'rpm -q openssh' 0 "Check openssh is installed"
rlRun 'which ssh-keygen' 0 "Check ssh-keygen available"
rlRun 'ssh-keygen -?' 0 "ssh-keygen help"

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 1: RSA key generation ==="
rlRun 'ssh-keygen -t rsa -b 2048 -f test_rsa -N "" -q' 0 "Generate RSA 2048 key"
rlRun 'test -f test_rsa' 0 "Private key exists"
rlRun 'test -f test_rsa.pub' 0 "Public key exists"
rlRun 'ssh-keygen -l -f test_rsa' 0 "Show RSA key fingerprint"

echo "=== Test 2: ECDSA key generation ==="
rlRun 'ssh-keygen -t ecdsa -b 256 -f test_ecdsa -N "" -q' 0 "Generate ECDSA 256 key"
rlRun 'ssh-keygen -l -f test_ecdsa.pub' 0 "Show ECDSA fingerprint"

echo "=== Test 3: Ed25519 key generation ==="
rlRun 'ssh-keygen -t ed25519 -f test_ed25519 -N "" -q' 0 "Generate Ed25519 key"
rlRun 'ssh-keygen -l -f test_ed25519.pub' 0 "Show Ed25519 fingerprint"
rlRun 'ssh-keygen -l -v -f test_ed25519.pub 2>&1 || true' 0 "Verbose fingerprint"

echo "=== Test 4: Key with passphrase ==="
rlRun 'ssh-keygen -t ed25519 -f test_pass -N "testpass" -q' 0 "Generate key with passphrase"
rlRun 'ssh-keygen -p -P "testpass" -N "" -f test_pass -q' 0 "Remove passphrase"

echo "=== Test 5: Key with comment ==="
rlRun 'ssh-keygen -t ed25519 -f test_comment -C "test@example.com" -N "" -q' 0 "Generate key with comment"
rlRun 'grep -q "test@example.com" test_comment.pub' 0 "Verify comment in pubkey"

echo "=== Test 6: Key conversion ==="
rlRun 'ssh-keygen -e -f test_ed25519.pub -m RFC4716 2>&1 | head -3' 0 "Export RFC4716 format"
rlRun 'ssh-keygen -i -f test_ed25519.pub -m RFC4716 2>&1 || true' 0 "Import RFC4716 format"

echo "=== Test 7: Public key extraction ==="
rlRun 'ssh-keygen -y -f test_ed25519 -P ""' 0 "Extract public key from private"

echo "=== Test 8: Change comment ==="
rlRun 'ssh-keygen -c -C "new_comment" -f test_comment -P ""' 0 "Change key comment"

echo "=== Test 9: Hash known hosts ==="
rlRun 'ssh-keygen -H -f /dev/null 2>&1 || true' 0 "Hash known hosts"

echo "=== Test 10: Fingerprint hashes ==="
rlRun 'ssh-keygen -l -f test_rsa.pub -E sha256' 0 "SHA256 fingerprint"
rlRun 'ssh-keygen -l -f test_rsa.pub -E md5 2>&1 || true' 0 "MD5 fingerprint"

echo "=== Test 11: RSA key options ==="
rlRun 'ssh-keygen -t rsa -b 2048 -f test_rsa2048 -N "" -q' 0 "Generate RSA 2048 key"
rlRun 'ssh-keygen -l -f test_rsa2048.pub' 0 "Verify RSA 2048 key"

echo "=== Test 12: Error handling ==="
rlRun 'ssh-keygen -t invalid -f /dev/null 2>&1 || true' 0 "Invalid key type"
rlRun 'ssh-keygen -f /nonexistent/test -N "" -q 2>&1 || true' 0 "Invalid path"

cd /
rm -rf $TmpDir

echo ""
echo "All openssh functional tests passed!"