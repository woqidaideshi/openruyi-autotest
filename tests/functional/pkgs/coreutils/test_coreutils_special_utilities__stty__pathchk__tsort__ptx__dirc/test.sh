#!/bin/sh -eux
# Functional test: coreutils - Special-utilities--stty--pathchk--tsort--ptx--dirc

. "../setup.sh"

echo "=== Test 23: Special utilities (stty, pathchk, tsort, ptx, dircolors) ==="

# 23.1 stty
rlRun 'stty -a' 0 "stty -a show all terminal settings"

# 23.2 pathchk
rlRun 'pathchk /tmp' 0 "pathchk validate path"
rlRun 'pathchk -p /tmp' 0 "pathchk -p POSIX check"

# 23.3 tsort
rlRun 'echo -e "a b\nb c" | tsort' 0 "tsort topological sort"

# 23.4 ptx
rlRun 'ptx fruits.txt' 0 "ptx permuted index"

# 23.5 dircolors
rlRun 'dircolors -p' 0 "dircolors -p print database"
rlRun 'dircolors' 0 "dircolors output LS_COLORS"

# ===================================================================

. "../teardown.sh"
echo "All coreutils Special-utilities--stty--pathchk--tsort--ptx--dirc tests passed!"
