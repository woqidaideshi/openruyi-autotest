#!/bin/sh -eux
# Functional test: coreutils - Links-and-path-resolution--ln--link--unlink--readl

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q coreutils' 0 "Check coreutils package is installed"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 4: Links and path resolution (ln, link, unlink, readlink, realpath) ==="

# 4.1 ln
rlRun 'echo "link content" > link_src.txt' 0 "Create link source"
rlRun 'ln link_src.txt link_hard.txt' 0 "ln create hard link"
rlRun 'test link_src.txt -ef link_hard.txt' 0 "ln: hard link same inode"
rlRun 'ln -s link_src.txt link_soft.txt' 0 "ln -s symbolic link"
rlRun 'test -L link_soft.txt' 0 "ln -s: symlink exists"
rlRun 'cat link_soft.txt' 0 "ln -s: read through symlink"
rlRun 'ln -sf link_src.txt link_soft.txt' 0 "ln -sf force recreate symlink"

# 4.2 link (hard link)
rlRun 'link link_src.txt link_via_link.txt' 0 "link create hard link"
rlRun 'test link_src.txt -ef link_via_link.txt' 0 "link: same inode"

# 4.3 unlink
rlRun 'unlink link_via_link.txt' 0 "unlink remove hard link"
rlRun 'test ! -f link_via_link.txt' 0 "unlink: file removed"

# 4.4 readlink
rlRun 'readlink link_soft.txt' 0 "readlink show symlink target"
rlRun 'test "$(readlink link_soft.txt)" = "link_src.txt"' 0 "readlink: correct target"
rlRun 'readlink -f link_soft.txt' 0 "readlink -f canonicalize"

# 4.5 realpath
rlRun 'realpath link_soft.txt' 0 "realpath canonical path"

# ===================================================================

echo ""
echo "All coreutils Links-and-path-resolution--ln--link--unlink--readl tests passed!"
