#!/bin/sh -eux
# Functional test: coreutils - Checksums--cksum--md5sum--sha1sum--sha224sum--sha3

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q coreutils 2>/dev/null || { echo 'coreutils not installed, skipping'; exit 0; }
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 13: Checksums (cksum, md5sum, sha1sum, sha224sum, sha384sum, sha512sum, sha256sum, b2sum, sum) ==="

# 13.1 cksum
rlRun 'cksum file1.txt' 0 "cksum CRC checksum"

# 13.2 md5sum
rlRun 'md5sum file1.txt' 0 "md5sum compute"
rlRun 'md5sum file1.txt > md5_check.txt' 0 "md5sum save"
rlRun 'md5sum -c md5_check.txt' 0 "md5sum -c verify"

# 13.3 sha1sum
rlRun 'sha1sum file1.txt' 0 "sha1sum compute"
rlRun 'sha1sum file1.txt > sha1_check.txt' 0 "sha1sum save"
rlRun 'sha1sum -c sha1_check.txt' 0 "sha1sum -c verify"

# 13.4 sha224sum
rlRun 'sha224sum file1.txt' 0 "sha224sum compute"

# 13.5 sha256sum
rlRun 'sha256sum file1.txt' 0 "sha256sum compute"
rlRun 'sha256sum file1.txt > sha256_check.txt' 0 "sha256sum save"
rlRun 'sha256sum -c sha256_check.txt' 0 "sha256sum -c verify"

# 13.6 sha384sum
rlRun 'sha384sum file1.txt' 0 "sha384sum compute"

# 13.7 sha512sum
rlRun 'sha512sum file1.txt' 0 "sha512sum compute"

# 13.8 b2sum
rlRun 'b2sum file1.txt' 0 "b2sum BLAKE2 checksum"

# 13.9 sum
rlRun 'sum file1.txt' 0 "sum BSD checksum"

# ===================================================================

echo ""
echo "All coreutils Checksums--cksum--md5sum--sha1sum--sha224sum--sha3 tests passed!"
