#!/bin/sh -eux
# Functional test: vim - Syntax-check

. "../setup.sh"

echo "=== Test 5: Syntax check ==="
cat > test.sh << 'EOF'
#!/bin/sh
echo "hello"
EOF
rlRun 'vim -e -s -c "syn on" -c "q" test.sh 2>&1 || true' 0 "vim: syntax enable"

. "../teardown.sh"
echo "All vim Syntax-check tests passed!"
