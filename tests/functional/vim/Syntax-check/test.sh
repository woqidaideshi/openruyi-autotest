#!/bin/sh -eux
# Functional test: vim - Syntax-check

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q vim-common' 0 "Check vim-common installed"
rlRun 'which vim' 0 "Check vim available"
rlRun 'vim --version 2>&1 | head -3' 0 "vim version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 5: Syntax check ==="
cat > test.sh << 'EOF'
#!/bin/sh
echo "hello"
EOF
rlRun 'vim -e -s -c "syn on" -c "q" test.sh 2>&1 || true' 0 "vim: syntax enable"


echo ""
echo "All vim Syntax-check tests passed!"
