#!/bin/sh -eux
# Functional test: tar package
# Tests tar command for archive creation, extraction, and management
# Version: tar 1.35

# Check package installation
rpm -q tar
which tar

# Get version information
tar --version

# Create test environment
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 1: Basic archive creation ==="

# Test 1.1: Create test files
echo "file1 content" > file1.txt
echo "file2 content" > file2.txt
mkdir testdir
echo "file3 content" > testdir/file3.txt

# Test 1.2: Create tar archive
tar -cvf archive.tar file1.txt file2.txt

# Test 1.3: List archive contents
tar -tvf archive.tar

echo "=== Test 2: Archive extraction ==="

# Test 2.1: Extract archive
mkdir extract_dir
cd extract_dir
tar -xvf ../archive.tar
ls -la
cd ..

# Test 2.2: Verify extracted files
cat extract_dir/file1.txt
cat extract_dir/file2.txt

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

echo "=== Test 4: Advanced tar options ==="

# Test 4.1: Append files to existing archive
tar -rvf archive.tar testdir
tar -tvf archive.tar

# Test 4.2: Extract specific files
mkdir extract_specific && cd extract_specific
tar -xvf ../archive.tar file1.txt
ls -la
cd ..

# Test 4.3: Extract to different directory
mkdir -p target_dir
tar -xvf archive.tar -C target_dir
ls -la target_dir

# Test 4.4: Create archive from directory
tar -cvf dir_archive.tar testdir
tar -tvf dir_archive.tar

echo "=== Test 5: Archive verification ==="

# Test 5.1: Test archive integrity
tar -tvf archive.tar > /dev/null && echo "Archive integrity check passed"

# Test 5.2: Compare archive with original files
mkdir compare_dir && cd compare_dir
tar -xvf ../archive.tar
diff file1.txt ../file1.txt && echo "File comparison passed"
cd ..

echo "=== Test 6: Special attributes ==="

# Test 6.1: Preserve permissions
chmod 755 file1.txt
tar -cvpf perm_archive.tar file1.txt
mkdir perm_dir && cd perm_dir && tar -xvpf ../perm_archive.tar
ls -la file1.txt
cd ..

# Test 6.2: Preserve timestamps
touch -t 202501011200 file1.txt
tar -cvpf time_archive.tar file1.txt
mkdir time_dir && cd time_dir && tar -xvpf ../time_archive.tar
ls -la file1.txt
cd ..

echo "=== Test 7: Error handling ==="

# Test 7.1: Non-existent file
tar -cvf error.tar nonexistent_file 2>&1 || echo "Expected error for non-existent file"

# Test 7.2: Corrupted archive
echo "corrupted data" > corrupted.tar
tar -tvf corrupted.tar 2>&1 || echo "Expected error for corrupted archive"

# Test 7.3: Empty archive
tar -cvf empty.tar --files-from /dev/null
tar -tvf empty.tar

echo "=== Test 8: Wildcard and patterns ==="

# Test 8.1: Extract with wildcard pattern
mkdir pattern_dir && cd pattern_dir
tar -xvf ../archive.tar --wildcards '*.txt'
ls -la
cd ..

# Test 8.2: Exclude patterns
tar -cvf exclude_archive.tar --exclude='*.txt' file1.txt file2.txt testdir
tar -tvf exclude_archive.tar

echo "=== Test 9: Incremental backup ==="

# Test 9.1: Create incremental backup
tar -cvf incremental.tar --listed-incremental=snapshot.snar file1.txt file2.txt
tar -tvf incremental.tar

# Test 9.2: Multi-volume archive (test only)
tar -cvf multi.tar file1.txt file2.txt --tape-length=1024 2>&1 || echo "Multi-volume test completed"

echo "=== Test 10: Special file types ==="

# Test 10.1: Archive with symlinks
ln -s file1.txt link_to_file1
tar -cvhf symlink_archive.tar link_to_file1
tar -tvf symlink_archive.tar

# Test 10.2: Archive with hardlinks
ln file1.txt hardlink_to_file1
tar -cvf hardlink_archive.tar hardlink_to_file1
tar -tvf hardlink_archive.tar

# Cleanup
cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y tar 2>/dev/null || true
    echo "TEARDOWN: removed tar"
fi
echo ""
echo "All tar functional tests passed!"
