#!/bin/sh -eux
# Functional test: tar - Compression-formats

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 3: Compression formats ==="

# Test 3.1: Create gzip compressed archive
tar -czvf archive.tar.gz file1.txt file2.txt testdir
ls -lh archive.tar.gz

# Test 3.2: Create bzip2 compressed archive
tar -cjvf archive.tar.bz2 file1.txt file2.txt
ls -lh archive.tar.bz2

# Test 3.3: Create xz compressed archive
tar -cJvf archive.tar.xz file1.txt file2.txt
ls -lh archive.tar.xz

# Test 3.4: Extract different formats
mkdir extract_gz && cd extract_gz && tar -xzvf ../archive.tar.gz && cd ..
mkdir extract_bz2 && cd extract_bz2 && tar -xjvf ../archive.tar.bz2 && cd ..
mkdir extract_xz && cd extract_xz && tar -xJvf ../archive.tar.xz && cd ..

cd /
rm -rf $TmpDir

echo ""
echo "All tar Compression-formats tests passed!"
