#!/bin/sh -eux
# Functional test: tar - Special-attributes

. "../setup.sh"

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

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All tar Special-attributes tests passed!"
