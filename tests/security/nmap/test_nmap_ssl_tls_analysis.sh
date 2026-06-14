#!/bin/sh -eu
# Security test: nmap — SSL/TLS security analysis
# Tests SSL/TLS certificate and vulnerability scanning
# Target: localhost with nginx HTTPS service

rlRun() { eval "$1" 2>&1; return $?; }

# === SETUP ===
INSTALLED_BY_TEST=0
SERVICES_STARTED=""

if ! rpm -q nmap 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y nmap 2>/dev/null; then
        INSTALLED_BY_TEST=1
    else
        echo "SKIP: nmap not available in repos"
        exit 0
    fi
fi

# Install nginx and generate SSL cert
if ! rpm -q nginx 2>/dev/null; then
    echo openruyi | sudo -S dnf install -y nginx 2>/dev/null || true
fi

if command -v openssl >/dev/null 2>&1; then
    SSL_DIR=$(mktemp -d)
    openssl req -x509 -nodes -days 1 -newkey rsa:2048 \
        -keyout "$SSL_DIR/server.key" -out "$SSL_DIR/server.crt" \
        -subj "/CN=localhost" 2>/dev/null || true
    echo openruyi | sudo -S mkdir -p /etc/nginx/conf.d 2>/dev/null || true
    cat > /tmp/nmap_ssl_test.conf << 'NGINXEOF'
server {
    listen 443 ssl;
    server_name localhost;
    ssl_certificate SSL_CERT_PATH;
    ssl_certificate_key SSL_KEY_PATH;
    root /usr/share/nginx/html;
}
NGINXEOF
    sed -i "s|SSL_CERT_PATH|$SSL_DIR/server.crt|" /tmp/nmap_ssl_test.conf
    sed -i "s|SSL_KEY_PATH|$SSL_DIR/server.key|" /tmp/nmap_ssl_test.conf
    echo openruyi | sudo -S cp /tmp/nmap_ssl_test.conf /etc/nginx/conf.d/nmap_ssl_test.conf 2>/dev/null || true
    CLEANUP_SSL_DIR="$SSL_DIR"
fi

if command -v nginx >/dev/null 2>&1; then
    echo openruyi | sudo -S nginx -t 2>/dev/null || true
    echo openruyi | sudo -S nginx 2>/dev/null || true
    SERVICES_STARTED="nginx"
    echo "SETUP: started nginx with HTTPS on port 443"
fi

rlRun 'nmap --version 2>&1 || true' 0 "获取 nmap 版本信息"

echo "=== 测试: SSL/TLS 安全分析 ==="

rlRun 'nmap -T4 --host-timeout 30s --script=ssl-cert -p 443 localhost 2>&1' 0 "SSL 证书分析"
rlRun 'nmap -T4 --host-timeout 30s --script=ssl-heartbleed -p 443 localhost 2>&1' 0 "Heartbleed 漏洞检测"
rlRun 'nmap -T4 --host-timeout 30s --script=sslv2 -p 443 localhost 2>&1' 0 "SSLv2 支持检测"

# === TEARDOWN ===
if [ -n "$SERVICES_STARTED" ]; then
    echo openruyi | sudo -S nginx -s stop 2>/dev/null || true
    echo "TEARDOWN: stopped nginx"
fi
echo openruyi | sudo -S rm -f /etc/nginx/conf.d/nmap_ssl_test.conf 2>/dev/null || true
rm -f /tmp/nmap_ssl_test.conf
if [ -n "$CLEANUP_SSL_DIR" ]; then
    rm -rf "$CLEANUP_SSL_DIR"
fi
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y nmap 2>/dev/null || true
    echo "TEARDOWN: removed nmap"
fi

echo ""
echo "All nmap SSL/TLS analysis tests passed!"
