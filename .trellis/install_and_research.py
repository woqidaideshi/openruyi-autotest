import paramiko
ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect('10.20.237.192', port=12055, username='openruyi', password='openruyi', timeout=15)

pkgs = ['rpm-config-openruyi','m4','preinstallimage','mpc','xz','curl','linux-headers','pkgconf','dwz','util-linux','zlib-ng','gzip','gettext','sed','libselinux','zstd','elfutils','audit','findutils','pam','python','debugedit','ca-certificates-mozilla','ca-certificates','newt','lua','glibc','cryptsetup','filesystem','nettle','isl','mpdecimal','mpfr','bash','gmp']

# Install missing packages
cmd = 'echo openruyi | sudo -S dnf install -y ' + ' '.join(pkgs) + ' 2>&1 | tail -10'
stdin, stdout, stderr = ssh.exec_command(cmd, timeout=120)
out = stdout.read().decode()
print('INSTALL:', out[-500:] if len(out) > 500 else out)

# Now research each package: commands, services
for pkg in pkgs:
    cmd = f"""
echo '=== {pkg} ==='
rpm -q {pkg} 2>&1 || echo NOT_INSTALLED
rpm -ql {pkg} 2>/dev/null | grep -E 'bin/|sbin/' | head -15
rpm -ql {pkg} 2>/dev/null | grep -E '\\.service$|\\.target$|\\.socket$' | head -5
"""
    stdin, stdout, stderr = ssh.exec_command(cmd)
    out = stdout.read().decode()
    lines = [l for l in out.split('\n') if l.strip() and ('===' in l or 'bin/' in l or '.service' in l or 'NOT_INSTALLED' in l)]
    for line in lines[:20]:
        print(line)
    print('---')

ssh.close()
print('DONE')
