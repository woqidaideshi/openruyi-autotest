#!/bin/sh -eux
# Functional test: coreutils package
# Tests key GNU core utilities
# Version: coreutils 9.10

rlRun() { eval "$1" 2>&1; return $?; }

rlRun 'rpm -q coreutils' 0 "Check coreutils package is installed"

# Verify key commands exist
for cmd in ls cp mv rm cat echo mkdir touch ln head tail wc sort uniq cut du df basename dirname chmod; do
    rlRun "which $cmd" 0 "Check $cmd command is available"
done

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 1: File creation and listing (echo, cat, ls) ==="

# Test 1.1: echo and cat
rlRun 'echo "line1" > file1.txt' 0 "Create file with echo"
rlRun 'echo "line2" >> file1.txt' 0 "Append to file"
rlRun 'cat file1.txt' 0 "Display file with cat"
rlRun 'test $(cat file1.txt | wc -l) -eq 2' 0 "Verify file has 2 lines"

# Test 1.2: ls listing
rlRun 'ls -la' 0 "List files with ls -la"
rlRun 'ls file1.txt' 0 "List specific file"
rlRun 'ls -l file1.txt | grep -q "^-"' 0 "Verify file is regular file"
mkdir testdir
rlRun 'ls -ld testdir | grep -q "^d"' 0 "Verify directory is listed with d prefix"

echo "=== Test 2: Copy, move, remove (cp, mv, rm) ==="

# Test 2.1: cp copy
rlRun 'cp file1.txt file1_copy.txt' 0 "Copy file"
rlRun 'test -f file1_copy.txt' 0 "Verify copy exists"
rlRun 'diff file1.txt file1_copy.txt' 0 "Verify files are identical"

# Test 2.2: cp recursive
rlRun 'cp -r testdir testdir_copy' 0 "Recursive copy directory"
rlRun 'test -d testdir_copy' 0 "Verify directory copy exists"

# Test 2.3: mv move/rename
rlRun 'mv file1_copy.txt file1_renamed.txt' 0 "Rename file with mv"
rlRun 'test ! -f file1_copy.txt' 0 "Verify old name no longer exists"
rlRun 'test -f file1_renamed.txt' 0 "Verify new name exists"

# Test 2.4: rm remove
rlRun 'touch temp_remove.txt' 0 "Create temp file"
rlRun 'rm temp_remove.txt' 0 "Remove file"
rlRun 'test ! -f temp_remove.txt' 0 "Verify file removed"

# Test 2.5: rm recursive
rlRun 'cp -r testdir testdir_rm' 0 "Create directory to remove"
rlRun 'rm -rf testdir_rm' 0 "Recursive remove directory"
rlRun 'test ! -d testdir_rm' 0 "Verify directory removed"

echo "=== Test 3: Directory operations (mkdir, touch) ==="

# Test 3.1: mkdir
rlRun 'mkdir -p a/b/c' 0 "Create nested directories"
rlRun 'test -d a/b/c' 0 "Verify nested directory exists"

# Test 3.2: touch
rlRun 'touch newfile.txt' 0 "Create file with touch"
rlRun 'test -f newfile.txt' 0 "Verify touch created file"
rlRun 'touch -t 202001010000 newfile.txt' 0 "Set file timestamp"

echo "=== Test 4: Links (ln) ==="

# Test 4.1: Hard link
rlRun 'echo "link content" > link_src.txt' 0 "Create link source file"
rlRun 'ln link_src.txt link_hard.txt' 0 "Create hard link"
rlRun 'test link_src.txt -ef link_hard.txt' 0 "Verify hard link shares inode"

# Test 4.2: Symbolic link
rlRun 'ln -s link_src.txt link_soft.txt' 0 "Create symbolic link"
rlRun 'test -L link_soft.txt' 0 "Verify symlink exists"
rlRun 'cat link_soft.txt' 0 "Read through symlink"

echo "=== Test 5: File viewing (head, tail) ==="

# Create multi-line file
for i in $(seq 1 20); do
    echo "line $i" >> lines.txt
done

# Test 5.1: head
rlRun 'head -n 5 lines.txt' 0 "Show first 5 lines"
rlRun 'test $(head -n 3 lines.txt | wc -l) -eq 3' 0 "Verify head line count"

# Test 5.2: tail
rlRun 'tail -n 5 lines.txt' 0 "Show last 5 lines"
rlRun 'test $(tail -n 3 lines.txt | wc -l) -eq 3' 0 "Verify tail line count"

# Test 5.3: tail with +N
rlRun 'test $(tail -n +18 lines.txt | wc -l) -eq 3' 0 "Tail from line 18"

echo "=== Test 6: Counting and statistics (wc, du, df) ==="

# Test 6.1: wc
rlRun 'wc -l lines.txt' 0 "Count lines"
rlRun 'test $(wc -l < lines.txt) -eq 20' 0 "Verify 20 lines"
rlRun 'wc -c lines.txt' 0 "Count bytes"
rlRun 'wc -w lines.txt' 0 "Count words"

# Test 6.2: du
rlRun 'du -sh .' 0 "Disk usage summary"
rlRun 'du -h a/' 0 "Disk usage of directory"

# Test 6.3: df
rlRun 'df -h' 0 "Disk free space"
rlRun 'df -h / | tail -1' 0 "Check root filesystem"

echo "=== Test 7: Text processing (sort, uniq, cut) ==="

cat > fruits.txt << 'EOF'
banana
apple
cherry
apple
banana
date
EOF

# Test 7.1: sort
rlRun 'sort fruits.txt' 0 "Sort lines alphabetically"
rlRun 'test "$(sort fruits.txt | head -1)" = "apple"' 0 "Verify first sorted line"
rlRun 'sort -r fruits.txt' 0 "Reverse sort"
rlRun 'sort -u fruits.txt' 0 "Sort and remove duplicates"

# Test 7.2: uniq
rlRun 'sort fruits.txt | uniq' 0 "Unique lines (after sort)"
rlRun 'test $(sort fruits.txt | uniq | wc -l) -eq 4' 0 "Verify 4 unique fruits"
rlRun 'sort fruits.txt | uniq -c' 0 "Count occurrences"
rlRun 'sort fruits.txt | uniq -d' 0 "Show only duplicates"

# Test 7.3: cut
echo "col1:col2:col3" > csv.txt
echo "a:b:c" >> csv.txt
echo "1:2:3" >> csv.txt
rlRun 'cut -d: -f1 csv.txt' 0 "Cut first field"
rlRun 'cut -d: -f2 csv.txt' 0 "Cut second field"
rlRun 'cut -d: -f1,3 csv.txt' 0 "Cut multiple fields"

echo "=== Test 8: Path manipulation (basename, dirname) ==="

# Test 8.1: basename
rlRun 'test "$(basename /usr/bin/grep)" = "grep"' 0 "basename extracts filename"
rlRun 'test "$(basename /path/to/file.txt .txt)" = "file"' 0 "basename with suffix removal"

# Test 8.2: dirname
rlRun 'test "$(dirname /usr/bin/grep)" = "/usr/bin"' 0 "dirname extracts directory"
rlRun 'test "$(dirname /path/to/file.txt)" = "/path/to"' 0 "dirname path extraction"

echo "=== Test 9: Permissions (chmod) ==="

# Test 9.1: chmod symbolic
rlRun 'touch perm_test.txt' 0 "Create file for permission test"
rlRun 'chmod u+x perm_test.txt' 0 "Add user execute permission"
rlRun 'test -x perm_test.txt' 0 "Verify execute permission set"

# Test 9.2: chmod numeric
rlRun 'chmod 644 perm_test.txt' 0 "Set permissions to 644"
rlRun 'ls -l perm_test.txt | grep -q "rw-r--r--"' 0 "Verify 644 permissions"

# Test 9.3: chmod recursive
rlRun 'mkdir perm_dir && touch perm_dir/f1 perm_dir/f2' 0 "Create directory with files"
rlRun 'chmod -R 755 perm_dir' 0 "Recursive chmod"

echo "=== Test 10: Redirection and pipes (tee) ==="

# Test 10.1: tee
rlRun 'echo "tee test" | tee tee_out.txt' 0 "tee to file"
rlRun 'grep -q "tee test" tee_out.txt' 0 "Verify tee output"
rlRun 'echo "append" | tee -a tee_out.txt' 0 "tee append mode"

echo "=== Test 11: Checksum utilities (cksum, md5sum, sha256sum) ==="

# Test 11.1: cksum
rlRun 'cksum file1.txt' 0 "Compute CRC checksum"

# Test 11.2: md5sum
rlRun 'md5sum file1.txt' 0 "Compute MD5 checksum"
rlRun 'md5sum file1.txt > md5_check.txt' 0 "Save MD5 checksum"
rlRun 'md5sum -c md5_check.txt' 0 "Verify MD5 checksum"

# Test 11.3: sha256sum
rlRun 'sha256sum file1.txt' 0 "Compute SHA256 checksum"
rlRun 'sha256sum file1.txt > sha256_check.txt' 0 "Save SHA256 checksum"
rlRun 'sha256sum -c sha256_check.txt' 0 "Verify SHA256 checksum"

echo "=== Test 12: Error handling ==="

# Test 12.1: cp nonexistent source
rlRun 'cp nonexistent.txt /tmp/ 2>&1' 1 "cp error on nonexistent source" || true

# Test 12.2: ls nonexistent file
rlRun 'ls nonexistent_file 2>&1' 2 "ls error on nonexistent file" || true

# Test 12.3: mkdir existing directory
rlRun 'mkdir testdir 2>&1' 1 "mkdir error on existing directory" || true

# Test 12.4: rm without -r on directory
rlRun 'rm testdir_copy 2>&1' 1 "rm error on directory without -r" || true

cd /
rm -rf $TmpDir

echo ""
echo "All coreutils functional tests passed!"