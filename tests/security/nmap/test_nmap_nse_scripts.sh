#!/bin/sh -eu
# Security test: nmap — NSE script scanning
# Tests Nmap Scripting Engine for vulnerability/banner detection
# Target: localhost with nginx (HTTP/HTTPS) + sshd services

rlRun() { eval "$1" 2>&1; return $?; }

# === SETUP ===
INSTALLED_BY_TEST=0
SERVICES_STARTED=""

# Check/install nmap
if ! rpm -q nmap 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y nmap 2>/dev/null; then
        INSTALLED_BY_TEST=1
    else
        echo "SKIP: nmap not available in repos"
        exit 0
    fi
fi

# Install nginx for HTTP/HTTPS testing
if ! rpm -q nginx 2>/dev/null; then
    echo openruyi | sudo -S dnf install -y nginx 2>/dev/null || true
fi

# Generate self-signed SSL cert for HTTPS testing
if command -v openssl >/dev/null 2>&1; then
    SSL_DIR=$(mktemp -d)
    openssl req -x509 -nodes -days 1 -newkey rsa:2048 \
        -keyout "$SSL_DIR/server.key" -out "$SSL_DIR/server.crt" \
        -subj "/CN=localhost" 2>/dev/null || true
    # Add HTTPS server block
    echo openruyi | sudo -S mkdir -p /etc/nginx/conf.d 2>/dev/null || true
    cat > /tmp/nmap_test_ssl.conf << NGINXEOF
server {
    listen 443 ssl;
    server_name localhost;
    ssl_certificate $SSL_DIR/server.crt;
    ssl_certificate_key $SSL_DIR/server.key;
    root /usr/share/nginx/html;
}
NGINXEOF
    echo openruyi | sudo -S cp /tmp/nmap_test_ssl.conf /etc/nginx/conf.d/nmap_test_ssl.conf 2>/dev/null || true
    CLEANUP_SSL_DIR="$SSL_DIR"
fi

# Start nginx
if command -v nginx >/dev/null 2>&1; then
    echo openruyi | sudo -S nginx -t 2>/dev/null || true
    echo openruyi | sudo -S nginx 2>/dev/null || true
    SERVICES_STARTED="nginx"
    echo "SETUP: started nginx (ports 80, 443)"
fi

# Ensure sshd is running
if command -v sshd >/dev/null 2>&1; then
    echo openruyi | sudo -S systemctl start sshd 2>/dev/null || true
fi

rlRun 'nmap --version 2>&1 || true' 0 "获取 nmap 版本信息"

echo "=== 测试: NSE 脚本扫描 ==="

rlRun 'nmap -T4 --host-timeout 30s --script=banner -p 22 localhost 2>&1' 0 "NSE banner 脚本 (SSH)"
rlRun 'nmap -T4 --host-timeout 30s --script=http-headers -p 80 localhost 2>&1' 0 "NSE HTTP 头检测"
rlRun 'nmap -T4 --host-timeout 30s --script=ssh-auth-methods -p 22 localhost 2>&1' 0 "NSE SSH 认证方法检测"
rlRun 'nmap -T4 --host-timeout 30s --script=ssl-enum-ciphers -p 443 localhost 2>&1' 0 "NSE SSL 密码套件枚举"

# === TEARDOWN ===
if [ -n "$SERVICES_STARTED" ]; then
    echo openruyi | sudo -S nginx -s stop 2>/dev/null || true
    echo "TEARDOWN: stopped nginx"
fi
echo openruyi | sudo -S rm -f /etc/nginx/conf.d/nmap_test_ssl.conf 2>/dev/null || true
rm -f /tmp/nmap_test_ssl.conf
if [ -n "$CLEANUP_SSL_DIR" ]; then
    rm -rf "$CLEANUP_SSL_DIR"
fi
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y nmap 2>/dev/null || true
    echo "TEARDOWN: removed nmap"
fi

echo ""
echo "All nmap NSE script tests passed!"
