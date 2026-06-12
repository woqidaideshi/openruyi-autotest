"""Install and research 143 new packages on server."""
import paramiko, time

SERVER='10.20.237.192';PORT=12055;USER='openruyi';PASS='openruyi'

pkgs=[
    'sqlite','libpng','popt','lz4','bzip2','unzip','gdbm','openssl',
    'slang','p11-kit','libffi','ncurses','cracklib','pcre2','libsepol',
    'python-rpm-macros','kbd','libpwquality','gnutls','rpm','dbus',
    'expat','libgcrypt','file','which','patch','nghttp2','libunistring',
    'libeconf','libcap','libcap-ng','json-c','jitterentropy','cpio',
    'publicsuffix-list','openruyi-release','libidn2','readline','tzdata',
    'libxml2','dbus-broker','authselect','python-srpm-macros','unbound',
    'gcc16','binutils','gawk','diffutils','libarchive','attr','libtool',
    'libxcrypt','chkconfig','setup','libgpg-error','automake','lvm2',
    'libpsl','libtasn1','libevent','python-pip','perl','autoconf',
    'bash-completion','gdb','help2man','groff','systemtap','texinfo',
    'flex','bison','meson','ninja','re2c','beakerlib','kyua','kmod',
    'pyproject-rpm-macros','python-rpm-generators','config','rsync',
    'cmocka','brotli','atf','ed','gpm','fdupes','libsodium','libedit',
    'swig','dejagnu','xxhash','iso-codes','libmicrohttpd','boost',
    'source-highlight','glib','xmlto','libssh','bc','nfs-utils','iproute2',
    'chrpath','expect','lzip','icu4c','python-packaging','libxslt','tcsh',
    'time','tcl','lutok','libbpf','libmnl','python-setuptools',
    'python-flit-core','iptables','scdoc','python-lxml','e2fsprogs',
    'libnftnl','libpcap','libnetfilter_conntrack','libnl','libnfnetlink',
    'libtirpc','krb5','keyutils','less','python-wheel','dos2unix',
    'pam_wrapper','uid_wrapper','nss_wrapper','socket_wrapper',
    'gobject-introspection','libseccomp','python-pyelftools','nss','libaio'
]

ssh=paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(SERVER,port=PORT,username=USER,password=PASS,timeout=180)

# Install all
print('Installing packages...')
cmd='echo openruyi | sudo -S dnf install -y '+' '.join(pkgs)+' 2>&1 | tail -5'
stdin,stdout,stderr=ssh.exec_command(cmd,timeout=300)
print(stdout.read().decode()[-500:])

# Research each for bin files
print('\nCommand research:')
for pkg in sorted(pkgs):
    stdin,stdout,stderr=ssh.exec_command(f'rpm -ql {pkg} 2>/dev/null | grep -E "bin/|sbin/" | head -10')
    bins=stdout.read().decode().strip()
    if bins:
        cmds=[b.split('/')[-1] for b in bins.split('\n') if b.strip()]
        print(f'  {pkg}: {",".join(cmds[:8])}')
    else:
        print(f'  {pkg}: (library, no CLI)')

ssh.close()
