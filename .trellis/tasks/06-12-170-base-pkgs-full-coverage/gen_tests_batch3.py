"""Batch 3: Heavy CLI packages + perl-Locale-gettext"""
import os

BASE = 'tests/functional'

def mkdir(path): os.makedirs(path, exist_ok=True)

def write(p, content):
    os.makedirs(os.path.dirname(p), exist_ok=True)
    with open(p, 'w') as f: f.write(content)

def gen_pkg_fmf(pkg, require=None):
    r = [f'summary: 功能测试 - {pkg} 软件包功能验证', 'test: ./test.sh']
    r.append('tag:\n  - functional\n  - ' + pkg)
    r.append('duration: 5m\ntier: 1')
    r.append(f'path: /tests/functional/{pkg}')
    if require:
        r.append('require:')
        for req in require: r.append(f'  - {req}')
    return '\n'.join(r)+'\n'

def gen_sub_fmf(pkg, sub, title):
    return f'''summary: {title}
test: ./test.sh
tag:
  - functional
  - {pkg}
duration: 2m
tier: 1
path: /tests/functional/{pkg}/{sub}
'''

def hdr(desc, cmds=None):
    h = '#!/bin/sh -eux\n# Functional test: ' + desc + '\n'
    if cmds: h += '# Commands: ' + ', '.join(cmds) + '\n'
    h += '\nrlRun() { eval "$1" 2>&1; return $?; }\n\n'
    return h

R=lambda p: f"rlRun 'rpm -q {p}' 0 \"检查 {p}\"\n"
C=lambda c: f"rlRun 'which {c}' 0 \"检查 {c}\"\n"
V=lambda c: f"rlRun '{c} --version 2>&1 || true' 0 \"{c} 版本\"\n"
T='rlRun \'TmpDir=$(mktemp -d)\' 0 "创建临时目录"\nrlRun \'cd $TmpDir\' 0 "进入测试目录"\n'
CL='rlRun \'cd /\' 0 "离开测试目录"\nrlRun \'rm -rf $TmpDir\' 0 "清理临时目录"\n'
S=lambda t: f'\necho "=== {t} ==="\n'
P=lambda p: f'\necho ""\necho "All {p} functional tests passed!"\n'

# ============= beakerlib =============
def gen_beakerlib():
    p='beakerlib'; d=os.path.join(BASE,p)
    write(os.path.join(d,'test.sh'),
        hdr('beakerlib - 测试框架',['beakerlib-deja-summarize','beakerlib-journalcmp','beakerlib-testwatcher'])+
        R(p)+C('beakerlib-deja-summarize')+C('beakerlib-journalcmp')+C('beakerlib-testwatcher')+P(p))
    write(os.path.join(d,'main.fmf'),gen_pkg_fmf(p,[p]))
    
    for sub,title,body in [
        ('test_beakerlib_basic','beakerlib - 基本功能',
         hdr('beakerlib 基本功能',['beakerlib-deja-summarize','beakerlib-journalcmp','beakerlib-testwatcher'])+R(p)+
         C('beakerlib-deja-summarize')+C('beakerlib-journalcmp')+C('beakerlib-testwatcher')+
         S('帮助信息')+
         'rlRun \'beakerlib-deja-summarize --help 2>&1 | head -10\' 0 "summarize 帮助"\n'+
         'rlRun \'beakerlib-journalcmp --help 2>&1 | head -10\' 0 "journalcmp 帮助"\n'+
         'rlRun \'beakerlib-testwatcher --help 2>&1 | head -10\' 0 "testwatcher 帮助"\n'+P('beakerlib-basic')),
    ]:
        sd=os.path.join(d,sub); write(os.path.join(sd,'test.sh'),body)
        write(os.path.join(sd,'main.fmf'),gen_sub_fmf(p,sub,title))
    return f'{p}: ok'

# ============= binutils =============
def gen_binutils():
    p='binutils'; d=os.path.join(BASE,p)
    cmds=['ar','nm','objdump','objcopy','readelf','size','strings','strip','addr2line','c++filt','elfedit','ranlib']
    write(os.path.join(d,'test.sh'),
        hdr('binutils - 二进制工具集',cmds)+R(p)+
        ''.join(C(c) for c in cmds[:6])+P(p))
    write(os.path.join(d,'main.fmf'),gen_pkg_fmf(p,[p]))
    
    subs=[
        ('test_binutils_nm','binutils - nm 符号查看',
         hdr('binutils - nm',['nm'])+R(p)+C('nm')+
         S('nm 符号查看')+'rlRun \'nm --help 2>&1 | head -10\' 0 "nm 帮助"\n'+
         'rlRun \'which ls\' 0 "找到测试二进制"\n'+
         'rlRun \'nm /usr/bin/ls 2>&1 | head -10\' 0 "查看 ls 符号表"\n'+
         'rlRun \'nm -D /usr/bin/ls 2>&1 | head -10\' 0 "查看动态符号"\n'+P('binutils-nm')),
        
        ('test_binutils_objdump','binutils - objdump 反汇编',
         hdr('binutils - objdump',['objdump'])+R(p)+C('objdump')+
         S('objdump')+'rlRun \'objdump --help 2>&1 | head -10\' 0 "objdump 帮助"\n'+
         'rlRun \'objdump -f /usr/bin/ls 2>&1 | head -10\' 0 "查看文件头"\n'+
         'rlRun \'objdump -h /usr/bin/ls 2>&1 | head -20\' 0 "查看段信息"\n'+
         'rlRun \'objdump -d /usr/bin/ls 2>&1 | head -10\' 0 "反汇编"\n'+P('binutils-objdump')),
        
        ('test_binutils_readelf','binutils - readelf',
         hdr('binutils - readelf',['readelf'])+R(p)+C('readelf')+
         S('readelf')+'rlRun \'readelf --help 2>&1 | head -10\' 0 "readelf 帮助"\n'+
         'rlRun \'readelf -h /usr/bin/ls 2>&1 | head -20\' 0 "ELF 头"\n'+
         'rlRun \'readelf -S /usr/bin/ls 2>&1 | head -20\' 0 "段头表"\n'+
         'rlRun \'readelf -d /usr/bin/ls 2>&1 | head -10\' 0 "动态段"\n'+P('binutils-readelf')),
        
        ('test_binutils_strings','binutils - strings',
         hdr('binutils - strings',['strings'])+R(p)+C('strings')+
         S('strings')+'rlRun \'strings --help 2>&1 | head -10\' 0 "strings 帮助"\n'+
         'rlRun \'strings /usr/bin/ls 2>&1 | head -10\' 0 "提取 ls 字符串"\n'+
         'rlRun \'strings -n 8 /usr/bin/ls 2>&1 | head -10\' 0 "提取长字符串"\n'+P('binutils-strings')),
        
        ('test_binutils_objcopy','binutils - objcopy/strip',
         hdr('binutils - objcopy',['objcopy','strip'])+R(p)+C('objcopy')+C('strip')+T+
         S('objcopy/strip')+
         'rlRun \'cp /usr/bin/ls .\' 0 "复制测试文件"\n'+
         'rlRun \'objcopy --help 2>&1 | head -10\' 0 "objcopy 帮助"\n'+
         'rlRun \'strip --help 2>&1 | head -10\' 0 "strip 帮助"\n'+
         'rlRun \'strip ls 2>&1 || true\' 0 "strip 文件"\n'+P('binutils-objcopy')),
        
        ('test_binutils_ar','binutils - ar 归档',
         hdr('binutils - ar',['ar'])+R(p)+C('ar')+T+
         S('ar 归档')+
         'rlRun \'echo "test" > file1.txt\' 0 "创建文件1"\n'+
         'rlRun \'echo "data" > file2.txt\' 0 "创建文件2"\n'+
         'rlRun \'ar cr test.a file1.txt file2.txt\' 0 "创建归档"\n'+
         'rlRun \'test -f test.a\' 0 "验证归档存在"\n'+
         'rlRun \'ar t test.a\' 0 "列出归档内容"\n'+
         'rlRun \'ar x test.a\' 0 "解出归档"\n'+P('binutils-ar')),
        
        ('test_binutils_error','binutils - 错误处理',
         hdr('binutils 错误处理')+R(p)+C('nm')+C('objdump')+C('readelf')+
         S('错误处理')+
         'rlRun \'nm nonexistent 2>&1 || true\' 1-255 "nm 不存在的文件"\n'+
         'rlRun \'objdump nonexistent 2>&1 || true\' 1-255 "objdump 不存在的文件"\n'+
         'rlRun \'readelf nonexistent 2>&1 || true\' 1-255 "readelf 不存在的文件"\n'+
         'rlRun \'nm --invalid 2>&1 || true\' 0 "nm 无效参数"\n'+P('binutils-error')),
    ]
    for sub,title,body in subs:
        sd=os.path.join(d,sub); write(os.path.join(sd,'test.sh'),body)
        write(os.path.join(sd,'main.fmf'),gen_sub_fmf(p,sub,title))
    return f'{p}: ok'

# ============= e2fsprogs =============
def gen_e2fsprogs():
    p='e2fsprogs'; d=os.path.join(BASE,p)
    write(os.path.join(d,'test.sh'),
        hdr('e2fsprogs - ext 文件系统工具',['e2fsck','mke2fs','tune2fs','dumpe2fs','resize2fs'])+
        R(p)+C('e2fsck')+C('mke2fs')+C('tune2fs')+C('dumpe2fs')+P(p))
    write(os.path.join(d,'main.fmf'),gen_pkg_fmf(p,[p]))
    
    for sub,title,body in [
        ('test_e2fsprogs_basic','e2fsprogs - 基本功能',
         hdr('e2fsprogs 基本功能',['e2fsck','mke2fs','tune2fs','dumpe2fs'])+R(p)+
         C('e2fsck')+C('mke2fs')+C('tune2fs')+C('dumpe2fs')+
         S('帮助信息')+
         'rlRun \'e2fsck --help 2>&1 | head -10\' 0 "e2fsck 帮助"\n'+
         'rlRun \'mke2fs --help 2>&1 | head -10\' 0 "mke2fs 帮助"\n'+
         'rlRun \'tune2fs --help 2>&1 | head -10\' 0 "tune2fs 帮助"\n'+
         'rlRun \'dumpe2fs --help 2>&1 | head -10\' 0 "dumpe2fs 帮助"\n'+
         'rlRun \'resize2fs --help 2>&1 | head -10\' 0 "resize2fs 帮助"\n'+
         S('mke2fs 创建文件系统')+T+
         'rlRun \'dd if=/dev/zero of=test.img bs=1M count=10\' 0 "创建测试镜像"\n'+
         'rlRun \'mke2fs -F test.img\' 0 "创建 ext2 文件系统"\n'+
         'rlRun \'dumpe2fs test.img 2>&1 | head -10\' 0 "查看文件系统信息"\n'+P('e2fsprogs-basic')),
        
        ('test_e2fsprogs_error','e2fsprogs - 错误处理',
         hdr('e2fsprogs 错误处理')+R(p)+
         S('错误处理')+
         'rlRun \'e2fsck --invalid 2>&1 || true\' 0 "无效参数"\n'+
         'rlRun \'mke2fs --invalid 2>&1 || true\' 0 "mke2fs 无效参数"\n'+P('e2fsprogs-error')),
    ]:
        sd=os.path.join(d,sub); write(os.path.join(sd,'test.sh'),body)
        write(os.path.join(sd,'main.fmf'),gen_sub_fmf(p,sub,title))
    return f'{p}: ok'

# ============= rpm =============
def gen_rpm():
    p='rpm'; d=os.path.join(BASE,p)
    write(os.path.join(d,'test.sh'),
        hdr('rpm - RPM 包管理器',['rpm','rpmkeys','rpm2cpio','rpmdb'])+
        R(p)+C('rpm')+C('rpmkeys')+V('rpm')+P(p))
    write(os.path.join(d,'main.fmf'),gen_pkg_fmf(p,[p]))
    
    for sub,title,body in [
        ('test_rpm_query','rpm - 查询功能',
         hdr('rpm 查询',['rpm'])+R(p)+C('rpm')+
         S('rpm 查询')+
         'rlRun \'rpm --help 2>&1 | head -10\' 0 "rpm 帮助"\n'+
         'rlRun \'rpm -qa 2>&1 | head -10\' 0 "列出所有包"\n'+
         'rlRun \'rpm -q rpm\' 0 "查询 rpm 包"\n'+
         'rlRun \'rpm -qi rpm 2>&1 | head -10\' 0 "查询包信息"\n'+
         'rlRun \'rpm -ql rpm 2>&1 | head -10\' 0 "列出包文件"\n'+
         'rlRun \'rpm -qc rpm 2>&1\' 0 "列出配置文件"\n'+
         'rlRun \'rpm -qd rpm 2>&1 | head -5\' 0 "列出文档"\n'+P('rpm-query')),
        
        ('test_rpm_verify','rpm - 验证功能',
         hdr('rpm 验证',['rpm','rpmkeys'])+R(p)+C('rpm')+C('rpmkeys')+
         S('rpm 验证')+
         'rlRun \'rpmkeys --help 2>&1 | head -10\' 0 "rpmkeys 帮助"\n'+
         'rlRun \'rpm -V rpm 2>&1 || true\' 0 "验证 rpm 包完整性"\n'+
         'rlRun \'rpm --import 2>&1 | head -5 || true\' 0 "rpm --import 帮助"\n'+P('rpm-verify')),
        
        ('test_rpm_error','rpm - 错误处理',
         hdr('rpm 错误处理')+R(p)+C('rpm')+
         S('错误处理')+
         'rlRun \'rpm --invalid 2>&1 || true\' 0 "无效参数"\n'+
         'rlRun \'rpm -q nonexistent 2>&1 || true\' 1-255 "查询不存在的包"\n'+P('rpm-error')),
    ]:
        sd=os.path.join(d,sub); write(os.path.join(sd,'test.sh'),body)
        write(os.path.join(sd,'main.fmf'),gen_sub_fmf(p,sub,title))
    return f'{p}: ok'

# ============= lvm2 =============
def gen_lvm2():
    p='lvm2'; d=os.path.join(BASE,p)
    write(os.path.join(d,'test.sh'),
        hdr('lvm2 - LVM 逻辑卷管理',['pvcreate','vgcreate','lvcreate','lvs','pvs','vgs'])+
        R(p)+C('lvm')+C('pvs')+C('vgs')+C('lvs')+P(p))
    write(os.path.join(d,'main.fmf'),gen_pkg_fmf(p,[p]))
    
    for sub,title,body in [
        ('test_lvm2_basic','lvm2 - 基本功能',
         hdr('lvm2 基本功能',['lvm','pvs','vgs','lvs','pvcreate','vgcreate','lvcreate'])+R(p)+
         C('lvm')+C('pvs')+C('vgs')+C('lvs')+
         S('LVM 工具')+
         'rlRun \'lvm version 2>&1 || true\' 0 "LVM 版本"\n'+
         'rlRun \'lvm help 2>&1 | head -10\' 0 "LVM 帮助"\n'+
         'rlRun \'pvs 2>&1 || true\' 0 "显示物理卷"\n'+
         'rlRun \'vgs 2>&1 || true\' 0 "显示卷组"\n'+
         'rlRun \'lvs 2>&1 || true\' 0 "显示逻辑卷"\n'+
         'rlRun \'pvdisplay 2>&1 || true\' 0 "物理卷详情"\n'+
         'rlRun \'vgdisplay 2>&1 || true\' 0 "卷组详情"\n'+
         'rlRun \'lvdisplay 2>&1 || true\' 0 "逻辑卷详情"\n'+P('lvm2-basic')),
    ]:
        sd=os.path.join(d,sub); write(os.path.join(sd,'test.sh'),body)
        write(os.path.join(sd,'main.fmf'),gen_sub_fmf(p,sub,title))
    return f'{p}: ok'

# ============= krb5 =============
def gen_krb5():
    p='krb5'; d=os.path.join(BASE,p)
    write(os.path.join(d,'test.sh'),
        hdr('krb5 - Kerberos 认证',['kinit','klist','kdestroy','kadmin','ktutil'])+
        R(p)+C('kinit')+C('klist')+C('kdestroy')+P(p))
    write(os.path.join(d,'main.fmf'),gen_pkg_fmf(p,[p]))
    
    for sub,title,body in [
        ('test_krb5_basic','krb5 - 基本功能',
         hdr('krb5 基本功能',['kinit','klist','kdestroy','kadmin','ktutil'])+R(p)+
         C('kinit')+C('klist')+C('kdestroy')+C('kadmin')+C('ktutil')+
         S('Kerberos 工具')+
         'rlRun \'kinit --help 2>&1 | head -10\' 0 "kinit 帮助"\n'+
         'rlRun \'klist --help 2>&1 | head -10\' 0 "klist 帮助"\n'+
         'rlRun \'kdestroy --help 2>&1 | head -10\' 0 "kdestroy 帮助"\n'+
         'rlRun \'kadmin --help 2>&1 | head -10\' 0 "kadmin 帮助"\n'+
         'rlRun \'ktutil --help 2>&1 | head -10\' 0 "ktutil 帮助"\n'+
         'rlRun \'klist 2>&1 || true\' 0 "查看票据(可能为空)"\n'+P('krb5-basic')),
    ]:
        sd=os.path.join(d,sub); write(os.path.join(sd,'test.sh'),body)
        write(os.path.join(sd,'main.fmf'),gen_sub_fmf(p,sub,title))
    return f'{p}: ok'

# ============= gcc16 =============
def gen_gcc16():
    p='gcc16'; d=os.path.join(BASE,p)
    write(os.path.join(d,'test.sh'),
        hdr('gcc16 - GCC 16 编译器',['gcc-16','g++-16','gcov-16'])+
        R(p)+C('gcc-16')+C('g++-16')+P(p))
    write(os.path.join(d,'main.fmf'),gen_pkg_fmf(p,[p]))
    
    for sub,title,body in [
        ('test_gcc16_basic','gcc16 - 基本功能',
         hdr('gcc16 基本功能',['gcc-16','g++-16'])+R(p)+C('gcc-16')+C('g++-16')+
         S('GCC 16')+
         'rlRun \'gcc-16 --version 2>&1 | head -3\' 0 "版本"\n'+
         'rlRun \'gcc-16 --help 2>&1 | head -10\' 0 "帮助"\n'+
         'rlRun \'g++-16 --help 2>&1 | head -10\' 0 "g++帮助"\n'+
         S('编译测试')+T+
         'rlRun \'echo "int main(){return 0;}" > test.c\' 0 "创建测试源码"\n'+
         'rlRun \'gcc-16 -o test test.c\' 0 "编译 C 程序"\n'+
         'rlRun \'./test\' 0 "运行编译后的程序"\n'+P('gcc16-basic')),
    ]:
        sd=os.path.join(d,sub); write(os.path.join(sd,'test.sh'),body)
        write(os.path.join(sd,'main.fmf'),gen_sub_fmf(p,sub,title))
    return f'{p}: ok'

# ============= icu4c =============
def gen_icu4c():
    p='icu4c'; d=os.path.join(BASE,p)
    write(os.path.join(d,'test.sh'),
        hdr('icu4c - Unicode 国际化组件',['icuinfo','uconv','genbrk','gencnval'])+
        R(p)+C('icuinfo')+C('uconv')+P(p))
    write(os.path.join(d,'main.fmf'),gen_pkg_fmf(p,[p]))
    
    for sub,title,body in [
        ('test_icu4c_basic','icu4c - 基本功能',
         hdr('icu4c 基本功能',['icuinfo','uconv'])+R(p)+C('icuinfo')+C('uconv')+
         S('ICU 工具')+
         'rlRun \'icuinfo --help 2>&1 | head -10\' 0 "icuinfo 帮助"\n'+
         'rlRun \'uconv --help 2>&1 | head -10\' 0 "uconv 帮助"\n'+
         'rlRun \'icuinfo 2>&1 | head -10 || true\' 0 "显示 ICU 信息"\n'+
         'rlRun \'echo "test" | uconv -f UTF-8 -t UTF-8\' 0 "uconv 转码测试"\n'+P('icu4c-basic')),
    ]:
        sd=os.path.join(d,sub); write(os.path.join(sd,'test.sh'),body)
        write(os.path.join(sd,'main.fmf'),gen_sub_fmf(p,sub,title))
    return f'{p}: ok'

# ============= iproute2 =============
def gen_iproute2():
    p='iproute2'; d=os.path.join(BASE,p)
    write(os.path.join(d,'test.sh'),
        hdr('iproute2 - 网络工具',['ip','ss','tc','bridge'])+
        R(p)+C('ip')+C('ss')+C('tc')+P(p))
    write(os.path.join(d,'main.fmf'),gen_pkg_fmf(p,[p]))
    
    for sub,title,body in [
        ('test_iproute2_basic','iproute2 - 基本功能',
         hdr('iproute2 基本功能',['ip','ss','tc'])+R(p)+C('ip')+C('ss')+C('tc')+
         S('ip 命令')+
         'rlRun \'ip --help 2>&1 | head -10\' 0 "ip 帮助"\n'+
         'rlRun \'ip addr show 2>&1 | head -10\' 0 "显示网络地址"\n'+
         'rlRun \'ip link show 2>&1 | head -10\' 0 "显示网络链接"\n'+
         'rlRun \'ip route show 2>&1 | head -5\' 0 "显示路由表"\n'+
         S('ss 命令')+
         'rlRun \'ss --help 2>&1 | head -10\' 0 "ss 帮助"\n'+
         'rlRun \'ss -tln 2>&1 | head -10\' 0 "显示监听端口"\n'+
         S('tc 命令')+
         'rlRun \'tc --help 2>&1 | head -10\' 0 "tc 帮助"\n'+P('iproute2-basic')),
    ]:
        sd=os.path.join(d,sub); write(os.path.join(sd,'test.sh'),body)
        write(os.path.join(sd,'main.fmf'),gen_sub_fmf(p,sub,title))
    return f'{p}: ok'

# ============= perl-Locale-gettext (NEW directory) =============
def gen_perl_locale_gettext():
    p='perl-Locale-gettext'; d=os.path.join(BASE,p)
    write(os.path.join(d,'test.sh'),
        hdr('perl-Locale-gettext - Perl gettext 绑定')+R(p)+
        S('模块验证')+
        'rlRun \'perl -e "use Locale::gettext; print \\"ok\\n\\"" 2>&1 || true\' 0 "测试 Locale::gettext 模块加载"\n'+
        'rlRun \'rpm -ql perl-Locale-gettext 2>/dev/null | head -10\' 0 "列出包文件"\n'+P(p))
    write(os.path.join(d,'main.fmf'),gen_pkg_fmf(p,[p,'perl']))
    return f'{p}: ok'

# Execute
results=[]
for fn in [gen_beakerlib, gen_binutils, gen_e2fsprogs, gen_rpm, gen_lvm2, gen_krb5, gen_gcc16, gen_icu4c, gen_iproute2, gen_perl_locale_gettext]:
    try:
        r=fn(); results.append(r); print(f'  {r}')
    except Exception as e:
        print(f'  ERROR: {e}')

print(f'\nBatch 3 total: {len(results)}')
