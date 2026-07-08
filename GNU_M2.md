# <span id="top">GNU Modula-2 Quick Reference</span> <span style="font-size:90%;">[↩](./README.md#top)</span>

> **Note:** See the official [GNU Modula-2](https://gcc.gnu.org/onlinedocs/gm2/index.html) online documentation for GNU Modula-2 usage.

### Prerequisites
- [MinGW-W64](https://github.com/niXman/mingw-builds-binaries/releases/), e.g. installed in directory ` C:\opt\mingw64\` (750 MB) in our case.

We first make sure we're using the [`gcc`][gcc_cli] executable from the [MinGW][mingw_binaries] binary distribution. In our case we need to switch our default `gcc` :
   
   <pre style="font-size:80%;border:1px solid #cccccc;">
   <b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/where">where</a> gcc</b>
   C:\opt\msys64\usr\bin\gcc.exe
   &nbsp;
   <b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/where">where</a> /r c:\opt\mingw64 gcc</b>
   c:\opt\mingw64\mingw64\bin\gcc.exe
   &nbsp;
   <b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/set">set</a> "PATH=c:\opt\mingw64\bin;%PATH%"</b>
   &nbsp;
   <b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/where">where</a> gcc</b>
   c:\opt\mingw64\bin\gcc.exe
   C:\opt\msys64\usr\bin\gcc.exe
   </pre>

   > **Note:** In our case the locally installed [MinGW][mingw_binaries] binary distribution include a newer [`gcc`][gcc_cli] version :
   > <pre style="margin:-24px 0 0 0; font-size:80%;">
   > <b>&gt; C:\opt\msys64\usr\bin\<a href="https://gcc.gnu.org/onlinedocs/gcc/Invoking-GCC.html" rel="external">gcc.exe</a> --version | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> /b gcc</b>
   > gcc (GCC) 15.2.0
   > &nbsp;
   > <b>&gt; c:\opt\mingw64\bin\gcc --version | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> /b gcc</b>
   > gcc (x86_64-win32-seh-rev0, Built by MinGW-Builds project) 16.1.0
   > </pre>

<!--=======================================================================-->

### <span id="build_gm2">Building `gm2` on Windows</span> [**&#x25B4;**](#top)

The build steps are the following :

1. **Source installation**<br/>We install the GCC sources from the GCC Git repository ([GitHub GCC mirror][gcc_mirror]).
   - `%USERPROFILE%\workspace-perso\m2-examples\gcc` is our working directory.
   - `C:\opt\gm2` is our installation directory.
   <pre style="font-size:80%;">
   <b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/cd">cd</a> gcc</b>
   <b>&gt; <a href="https://git-scm.com/docs/git-clone">git clone</a> <a href="https://gcc.gnu.org/git.html" rel="external">git://gcc.gnu.org/git/gcc.git</a> gcc-source</b>
   Cloning into 'gcc-source'...
   remote: Enumerating objects: 3357790, done.
   remote: Counting objects: 100% (294947/294947), done.
   remote: Compressing objects: 100% (18512/18512), done.
   remote: Total 3357790 (delta 289119), reused 277524 (delta 276389), pack-reused 3062843
   Receiving objects: 100% (3357790/3357790), 1.34 GiB | 4.79 MiB/s, done.
   Resolving deltas: 100% (2769808/2769808), done.
   Updating files: 100% (159050/159050), done.
   </pre>
   > **Note:** The installed source directory is 2.6 GB in size :
   > <pre style="margin:-24px 0 0 0; font-size:80%;">
   > <b>&gt; <a href="https://linux.die.net/man/1/du">du</a> -sm gcc-source</b>
   > 2630 gcc-source
   > </pre>

   We later can run [`git pull`](https://git-scm.com/docs/git-pull) to keep our local Git copy up-to-date :
   <pre style="font-size:80%;"
   <b>$ <a href="https://git-scm.com/docs/git-pull">git pull</a></b>
   remote: Enumerating objects: 164, done.
   remote: Counting objects: 100% (156/156), done.
   remote: Compressing objects: 100% (48/48), done.
   remote: Total 49 (delta 40), reused 0 (delta 0), pack-reused 0
   Unpacking objects: 100% (49/49), 14.21 KiB | 41.00 KiB/s, done.
   From git://gcc.gnu.org/git/gcc
      34c81df45ae..5d0a9050f3a  master          -> origin/master
      35e2a41470f..861bc2f31f2  releases/gcc-13 -> origin/releases/gcc-13
      c014d142c62..749ed863deb  releases/gcc-14 -> origin/releases/gcc-14
      eb5a9409154..51e41126d45  releases/gcc-15 -> origin/releases/gcc-15
      c8ea9199ba0..f18809c280e  releases/gcc-16 -> origin/releases/gcc-16
      34c81df45ae..5d0a9050f3a  trunk           -> origin/trunk
   Updating 34c81df45ae..5d0a9050f3a
   Fast-forward
   gcc/ChangeLog                            | 205 ++++++++++++++++++++
   gcc/DATESTAMP                            |   2 +-
   [...]
   15 files changed, 948 insertions(+), 49 deletions(-)
   create mode 100644 gcc/testsuite/gfortran.dg/EXformat_1.F90
   create mode 100644 gcc/testsuite/gfortran.dg/EXformat_2.f90
   </pre>

2. **Configuration checks** [**&#x25B4;**](#top)
   We enter the GCC source directory (e.g. `gcc\`), start a Unix session with command [`sh`][sh_cli] and check the [`gcc`][gcc_cli] version :
   <pre style="font-size:80%;border:1px solid #cccccc;">
   <b>$ <a href="https://man7.org/linux/man-pages/man1/cd.1p.html">cd</a> gcc-source</b>
    &nbsp;
   <b>&gt; C:\opt\msys64\usr\bin\<a href="https://linux.die.net/man/1/sh">sh.exe</a></b>
   <b>$ <a href="">pwd</a></b>
   /f/gcc/gcc-sources
   &nbsp;
   <b>$ <a href="https://linux.die.net/man/1/which">which</a> gcc</b>
   /c/opt/mingw64/bin/gcc
   </pre>

   > **Note**: We've observed that some shell scripts use CRLF line terminators, i.e.
   > <pre style="margin:-24px 0 0 0;font-size:80%;">
   > <b>$ <a href="">file</a> libiberty/configure</b>
   > libiberty/configure: POSIX shell script, ASCII text executable, with CRLF line terminators
   > </pre>

   We execute shell script [`contrib/download_prerequisites`](https://github.com/gcc-mirror/gcc/blob/master/contrib/download_prerequisites)<sup id="anchor_01"><b><a href="#footnote_01">1</a></b></sup> *once* to be sure we have the required packages : 
    <!--
    https://stackoverflow.com/questions/9253695/building-gcc-requires-gmp-4-2-mpfr-2-3-1-and-mpc-0-8-0
    -->
    <pre style="font-size:80%;border:1px solid #cccccc;">
    <b>$ ./contrib/<a href="https://github.com/gcc-mirror/gcc/blob/master/contrib/download_prerequisites" rel="external">download_prerequisites</a></b>
   2026-05-23 21:25:17 URL:https://gcc.gnu.org/pub/gcc/infrastructure/gettext-0.22.tar.gz [26105696/26105696] -> "gettext-0.22.tar.gz" [1]
   2026-05-23 21:25:18 URL:https://gcc.gnu.org/pub/gcc/infrastructure/gmp-6.3.0.tar.bz2 [2643888/2643888] -> "gmp-6.3.0.tar.bz2" [1]
   2026-05-23 21:25:20 URL:https://gcc.gnu.org/pub/gcc/infrastructure/mpfr-4.2.2.tar.bz2 [1753999/1753999] -> "mpfr-4.2.2.tar.bz2" [1]
   2026-05-23 21:25:21 URL:https://gcc.gnu.org/pub/gcc/infrastructure/mpc-1.3.1.tar.gz [773573/773573] -> "mpc-1.3.1.tar.gz" [1]
   2026-05-23 21:25:22 URL:https://gcc.gnu.org/pub/gcc/infrastructure/isl-0.24.tar.bz2 [2261594/2261594] -> "isl-0.24.tar.bz2" [1]
   gettext-0.22.tar.gz: OK
   gmp-6.3.0.tar.bz2: OK
   mpfr-4.2.2.tar.bz2: OK
   mpc-1.3.1.tar.gz: OK
   isl-0.24.tar.bz2: OK
   All prerequisites downloaded successfully.
    &nbsp;
    <b>$ <a href="https://man7.org/linux/man-pages/man1/find.1.html" rel="external">find</a> . -name "*.tar.*"</b>
   ./gettext-0.22.tar.gz
   ./gmp-6.3.0.tar.bz2
   ./isl-0.24.tar.bz2
   ./mpc-1.3.1.tar.gz
   ./mpfr-4.2.2.tar.bz2
    </pre>

    > **Note:** We further install the following MSYS2 packages <sup id="anchor_02"><b><a href="#footnote_02">2</a></b></sup> which are also required to generate the GCC distribution (but are missing in our local MSYS2 installation).
    > - [`automake`][msys2_automake]     # `/usr/bin/aclocal`, `/usr/bin/automake`
    > - [`mingw-w64-x86_64-gcc-obj`][msys2_objc]
    > - [`texinfo`][msys2_texinfo]       # `/usr/bin/makeinfo`
    >
    > <pre style="font-size:80%;">
    > <b>&gt; <a href="">where</a> automake make makeinfo</b>
    > c:\opt\msys64\usr\bin\automake.exe
    > c:\opt\msys64\usr\bin\make.exe
    > c:\opt\msys64\usr\bin\makeinfo.exe
    > </pre>

3. <span id="makefile_creation">**Makefile creation**</span> [**&#x25B4;**](#top)

   By default the [`configure`][configure_script] script *doesn't include* the Modula-2 frontend in the generated build file `Makefile`, e.g. 

   <pre style="font-size:80%;border:1px solid #cccccc;">
   <b>$ <a href="https://www.gnu.org/prep/standards/html_node/Configuration.html" rel="external">./configure</a> CC=gcc \
   --host=x86_64-pc-mingw32 \
   --prefix=/c/opt/gm2</b>
   checking build system type... x86_64-pc-msys
   checking host system type... x86_64-pc-mingw32
   checking target system type... x86_64-pc-mingw32
   [...]
   checking whether g++ supports C++11 features by default... yes
   checking whether g++ supports C++11 features by default... yes
   checking for objdir... .libs
   configure: WARNING: using in-tree isl, disabling version check
   The following languages will be built: <span style="color:red;"><b>c,c++,fortran,lto,objc</b></span>
   [...]
   </pre>

   We specify option `--enable-languages` in order to add value `m2` to the list of supported languages :

   <pre style="font-size:80%;border:1px solid #cccccc;">
   <b>$ <a href="https://www.gnu.org/prep/standards/html_node/Configuration.html" rel="external">./configure</a> CC=gcc \
   --host=x86_64-pc-mingw32 \
   --prefix=/c/opt/gm2 \
   <span style="color:blue;">--enable-languages=c,c++,lto,m2</span></b>
   checking build system type... x86_64-pc-mingw64
   checking host system type... x86_64-pc-mingw32
   checking target system type... x86_64-pc-mingw32
   checking for a BSD-compatible install... /usr/bin/install -c
   [...]
   checking for clang for target... no
   checking for gcc for target... yes
   checking for target -plugin option... no
   checking whether to enable maintainer-specific portions of Makefiles... no
   configure: creating ./config.status
   config.status: creating Makefile
   </pre>

4. **Makefile execution**

   <pre style="font-size:80%;border:1px solid #cccccc;">
   <b>$ <a href="https://www.gnu.org/software/make/manual/html_node/Options-Summary.html">make</a> -e TMP=/c/temp</b>
   </pre>
   > **Notes:**
   > - [GNU make][gnu_make] version 3.80 or newer is required.
   > - We specify the variable `TMP` to avoid the error message "<code>Cannot create temporary file in C:\WINDOWS\: Permission denied</code>" (see post <a href="https://github.com/msys2/MINGW-packages/issues/5794">"gcc trying to write a temporary file to C:\WINDOWS\"</a>).

<!--=======================================================================-->

## <span id="footnotes">Footnotes</span> [**&#x25B4;**](#top)

<span id="footnote_01">[1]</span> ***Script `download_prerequisites`*** [↩](#anchor_01)

<dl><dd style="margin:6px;">
We add option "<code>--no-check-certificate</code>" in shell script <a href="https://github.com/gcc-mirror/gcc/blob/master/contrib/download_prerequisites" rel="external"><code>./contrib/download_prerequisites</code></a> to skip certificate validation.
<pre style="font-size:80%;">
<b>if type <a href="https://linux.die.net/man/1/wget">wget</a></b> > /dev/null ; <b>then</b>
  <span style="color:green;"># fetch='wget'</span>
  fetch=<span style="color:darkred;">'wget --no-check-certificate'</span>
<b>else</b>
  fetch=<span style="color:darkred;">'curl -LO'</span>
<b>fi</b>
</pre>
</dd></dl>

<span id="footnote_02">[2]</span> ***Additional MSYS packages*** [↩](#anchor_02)

<dl><dd style="margin:6px;">
<pre style="font-size:70%;border:1px solid #cccccc;">
<b>&gt; C:\opt\msys64\usr\bin\<a href="https://www.msys2.org/docs/package-management/" rel="external"><b>pacman.exe</b></a> -Sy <a href="https://packages.msys2.org/package/texinfo">msys/texinfo</a></b>
:: Synchronizing package databases...
 [...]
 msys is up to date
resolving dependencies...
looking for conflicting packages...
&nbsp;
Packages (1) texinfo-7.1-1
&nbsp;
Total Download Size:   1.40 MiB
Total Installed Size:  9.44 MiB
&nbsp;
:: Proceed with installation? [Y/n] y
:: Retrieving packages...
 texinfo-7.1-1-x86_64                        1433.8 KiB   950 KiB/s 00:02
[##########################################] 100% (1/1) checking keys in keyring
[##########################################] 100% (1/1) checking package integrity
[##########################################] 100% (1/1) loading package files
[##########################################] 100% (1/1) checking for file conflicts
[##########################################] 100% (1/1) checking available disk space
:: Processing package changes...
[##########################################] 100% (1/1) installing texinfo
:: Running post-transaction hooks...
[##########################################] 100% (1/1) Updating the info directory file...
</pre>

<pre style="font-size:70%;border:1px solid #cccccc;">
<b>&gt; c:\opt\msys64\usr\bin\<a href="https://www.msys2.org/docs/package-management/"><b>pacman.exe</b></a> -Sy automake</b>
:: Synchronizing package databases...
 [...]
 msys is up to date
resolving dependencies...
looking for conflicting packages...

Packages (7) automake1.11-1.11.6-6  automake1.12-1.12.6-6  automake1.13-1.13.4-7
             automake1.14-1.14.1-6  automake1.15-1.15.1-4  automake1.16-1.16.5-1
             automake-wrapper-20221207-1

Total Download Size:   2.97 MiB
Total Installed Size:  8.72 MiB

:: Proceed with installation? [Y/n] y
:: Retrieving packages...
automake1.13-1.13.4-7-any                    501.5 KiB   370 KiB/s 00:01
[##########################################] 100%
automake1.16-1.16.5-1-any                    526.3 KiB   290 KiB/s 00:02
[##########################################] 100%
automake1.15-1.15.1-4-any                    513.4 KiB   272 KiB/s 00:02
[##########################################] 100%
automake1.14-1.14.1-6-any                    503.1 KiB   259 KiB/s 00:02
[##########################################] 100%
automake-wrapper-20221207-1-any                4.4 KiB  39.5 KiB/s 00:00
[##########################################] 100%
automake1.11-1.11.6-6-any                    490.2 KiB   553 KiB/s 00:01
[##########################################] 100%
automake1.12-1.12.6-6-any                    503.1 KiB   155 KiB/s 00:03
[##########################################] 100%
Total (7/7)                                    3.0 MiB   903 KiB/s 00:03
[##########################################] 100% (7/7) checking keys in keyring
[##########################################] 100% (7/7) checking package integrity
[##########################################] 100% (7/7) loading package files
[##########################################] 100% (7/7) checking for file conflicts
[##########################################] 100% (7/7) checking available disk space
:: Processing package changes...
[##########################################] 100% (2/7) installing automake1.12
[##########################################] 100% (2/7) installing automake1.12
[##########################################] 100% (3/7) installing automake1.13
[##########################################] 100% (4/7) installing automake1.14
[##########################################] 100% (5/7) installing automake1.15
[##########################################] 100% (6/7) installing automake1.16
[##########################################] 100% (7/7) installing automake-wrapper
:: Running post-transaction hooks...
[##########################################] 100% (1/1) Updating the info directory file...
</pre>
</dd></dl>

<span id="footnote_03">[3]</span> ***Source file modifications*** [↩](#anchor_03)

<dl><dd style="margin:6px;">
We add the following code to the C source file <code>m2-examples\gcc\gcc-source\libiberty\pex-win32.c</code> :
<pre style="font-size:80%;border:1px solid #cccccc;">
<span style="color:green;">/* See https://gcc.gnu.org/pipermail/gcc-cvs/2020-December/339598.html */</span>
&nbsp;
#<b>ifndef</b> _O_BINARY
#  <b>define</b> _O_BINARY O_BINARY
#  <b>define</b> _O_CREAT O_CREAT
#  <b>define</b> _O_NOINHERIT O_CLOEXEC
#  <b>define</b> _O_RDONLY O_RDONLY
#  <b>define</b> _O_TEXT O_TEXT
#  <b>define</b> _O_TRUNC O_TRUNC
#  <b>define</b> _O_WRONLY O_WRONLY
#
#  <b>define</b> _close close
#  <b>define</b> _dup dup
#  <b>define</b> _open open
#  <b>define</b> _read read
#<b>endif</b>
&nbsp;
#<b>ifndef</b> _S_IREAD
#  <b>define</b> _S_IREAD S_IREAD
#  <b>define</b> _S_IWRITE S_IWRITE
#<b>endif</b>
</pre>

We modify file `m2-examples\gcc\Makefile` (lines 396-297) :

<pre style="font-size:80%;border:1px solid #cccccc;">
 <span style="color:green;">#AS = x86_64-pc-mingw32-as</span>
 AS = /usr/x86_64-w64-pc-msys/bin/<a href="https://linux.die.net/man/1/as"><b>as</b></a>
 <span style="color:green;">#AR = x86_64-pc-mingw32-ar</span>
 AR = /usr/x86_64-w64-pc-msys/bin/<a href="https://linux.die.net/man/1/ar"><b>ar</b></a>
</pre>

We modify file `m2-examples\gcc\gcc-source\gcc\config\i386\host-mingw32.cc` as follows (lines 29ff); our modification is based on file <code>m2-examples\gcc\gcc-source\gcc\ada\mingw32.h</code> (lines 50-55) :

<pre style="font-size:80%;border:1px solid #cccccc;">
<span style="color:blue;">#<b>if defined</b> (__CYGWIN__) && !defined (__CYGWIN32__) && !defined (IN_RTS)
/* Note: windows.h on cygwin-64 includes x86intrin.h which uses malloc.
   That fails to compile, if malloc is poisoned, i.e. if !IN_RTS.  */
#<b>define</b> _X86INTRIN_H_INCLUDED
#<b>define</b> _EMMINTRIN_H_INCLUDED
#<b>endif</b></span>
#<b>define</b> WIN32_LEAN_AND_MEAN  <span style="color:green;">/* Not so important if we have windows.h.gch.  */</span>
#<b>include</b> &lt;windows.h>
#<b>include</b> &lt;stdlib.h>
<span style="color:blue;">#include &lt;io.h></span>
</pre>
</dd></dl>

<!--
$ C:\opt\msys64\usr\bin\sh.exe ./configure --host=x86_64-pc-mingw32 --prefix=/c/opt/gcc-13 --enable-languages=c,c++,lto,m2
checking build system type... x86_64-pc-msys
checking host system type... x86_64-pc-mingw32
checking target system type... x86_64-pc-mingw32
checking for a BSD-compatible install... /usr/bin/install -c
checking whether ln works... yes
checking whether ln -s works... no, using cp -pR
checking for a sed that does not truncate output... /usr/bin/sed
checking for gawk... gawk
checking for libatomic support... yes
checking for libitm support... no
checking for libsanitizer support... no
checking for libvtv support... yes
checking for libphobos support... no
checking for x86_64-pc-mingw32-gcc... no
checking for gcc... gcc
checking whether the C compiler works... yes
checking for C compiler default output file name... a.exe
checking for suffix of executables... .exe
checking whether we are cross compiling... no
checking for suffix of object files... o
checking whether we are using the GNU C compiler... yes
checking whether gcc accepts -g... yes
checking for gcc option to accept ISO C89... none needed
checking for gcc option to accept ISO C99... none needed
checking for x86_64-pc-mingw32-g++... no
checking for x86_64-pc-mingw32-c++... no
checking for x86_64-pc-mingw32-gpp... no
checking for x86_64-pc-mingw32-aCC... no
checking for x86_64-pc-mingw32-CC... no
checking for x86_64-pc-mingw32-cxx... no
checking for x86_64-pc-mingw32-cc++... no
checking for x86_64-pc-mingw32-cl.exe... no
checking for x86_64-pc-mingw32-FCC... no
checking for x86_64-pc-mingw32-KCC... no
checking for x86_64-pc-mingw32-RCC... no
checking for x86_64-pc-mingw32-xlC_r... no
checking for x86_64-pc-mingw32-xlC... no
checking for g++... g++
checking whether we are using the GNU C++ compiler... yes
checking whether g++ accepts -g... yes
checking whether g++ accepts -static-libstdc++ -static-libgcc... yes
checking for x86_64-pc-mingw32-gnatbind... no
checking for gnatbind... gnatbind
checking for x86_64-pc-mingw32-gnatmake... no
checking for gnatmake... gnatmake
checking whether compiler driver understands Ada and is recent enough... no
checking for x86_64-pc-mingw32-gdc... no
checking for gdc... no
checking whether the D compiler works... no
checking how to compare bootstrapped objects... cmp --ignore-initial=16 $$f1 $$f2
checking whether g++ supports C++11 features by default... yes
checking whether g++ supports C++11 features by default... yes
checking for objdir... .libs
configure: WARNING: using in-tree isl, disabling version check
 'c++' language required by 'm2' in stage 1; enabling
*** This configuration is not supported in the following subdirectories:
     target-libgomp target-libitm target-libsanitizer target-libphobos target-libffi target-libgo gnattools gotools target-libada target-zlib target-libbacktrace target-libgfortran target-libobjc
    (Any other directories should still work fine.)
checking for default BUILD_CONFIG...
checking for --enable-vtable-verify... no
checking for bison... no
checking for byacc... no
checking for yacc... no
checking for bison... no
checking for gm4... no
checking for gnum4... no
checking for m4... m4
checking for flex... no
checking for lex... no
checking for flex... no
checking for makeinfo... makeinfo
checking for expect... no
checking for runtest... no
checking for x86_64-pc-mingw32-ar... no
checking for x86_64-pc-mingw32-as... no
checking for x86_64-pc-mingw32-dlltool... no
checking for x86_64-pc-mingw32-dsymutil... no
checking for ld... (cached) /usr/lib/gcc/x86_64-pc-msys/13.2.0/../../../../x86_64-pc-msys/bin/ld.exe
checking for x86_64-pc-mingw32-ld... (cached) /usr/lib/gcc/x86_64-pc-msys/13.2.0/../../../../x86_64-pc-msys/bin/ld.exe
checking for x86_64-pc-mingw32-lipo... no
checking for x86_64-pc-mingw32-nm... no
checking for x86_64-pc-mingw32-ranlib... no
checking for x86_64-pc-mingw32-strip... no
checking for x86_64-pc-mingw32-windres... no
checking for x86_64-pc-mingw32-windmc... no
checking for x86_64-pc-mingw32-objcopy... no
checking for x86_64-pc-mingw32-objdump... no
checking for x86_64-pc-mingw32-otool... no
checking for x86_64-pc-mingw32-readelf... no
checking where to find the target ar... pre-installed in /usr/lib/gcc/x86_64-pc-msys/13.2.0/../../../../x86_64-pc-msys/bin
checking where to find the target as... pre-installed in /usr/lib/gcc/x86_64-pc-msys/13.2.0/../../../../x86_64-pc-msys/bin
checking where to find the target cc... pre-installed
checking where to find the target c++... pre-installed
checking where to find the target c++ for libstdc++... pre-installed
checking where to find the target dlltool... pre-installed in /usr/lib/gcc/x86_64-pc-msys/13.2.0/../../../../x86_64-pc-msys/bin
checking where to find the target dsymutil... pre-installed
checking where to find the target gcc... pre-installed
checking where to find the target gfortran... pre-installed
checking where to find the target gccgo... pre-installed
checking where to find the target gdc... pre-installed
checking where to find the target gm2... pre-installed
checking where to find the target ld... pre-installed in /usr/lib/gcc/x86_64-pc-msys/13.2.0/../../../../x86_64-pc-msys/bin
checking where to find the target lipo... pre-installed
checking where to find the target nm... pre-installed in /usr/lib/gcc/x86_64-pc-msys/13.2.0/../../../../x86_64-pc-msys/bin
checking where to find the target objcopy... pre-installed in /usr/lib/gcc/x86_64-pc-msys/13.2.0/../../../../x86_64-pc-msys/bin
checking where to find the target objdump... pre-installed in /usr/lib/gcc/x86_64-pc-msys/13.2.0/../../../../x86_64-pc-msys/bin
checking where to find the target otool... pre-installed
checking where to find the target ranlib... pre-installed in /usr/lib/gcc/x86_64-pc-msys/13.2.0/../../../../x86_64-pc-msys/bin
checking where to find the target readelf... pre-installed in /usr/lib/gcc/x86_64-pc-msys/13.2.0/../../../../x86_64-pc-msys/bin
checking where to find the target strip... pre-installed in /usr/lib/gcc/x86_64-pc-msys/13.2.0/../../../../x86_64-pc-msys/bin
checking where to find the target windres... pre-installed
checking where to find the target windmc... pre-installed
checking whether to enable maintainer-specific portions of Makefiles... no
configure: creating ./config.status
config.status: creating Makefile
-->

<!--
g++ -c -DIN_GCC       -DGENERATOR_FILE -I. -Ibuild -I../.././gcc -I../.././gcc/build -I../.././gcc/../include -I./../intl -I../.././gcc/../libcpp/include  \
        -o build/gengtype.o ../.././gcc/gengtype.cc
/c/Users/michelou/workspace-perso/m2-examples/gcc-13-20230219/missing flex  -ogengtype-lex.cc ../.././gcc/gengtype-lex.l && { \
  echo '#ifdef HOST_GENERATOR_FILE' > gengtype-lex.cc.tmp; \
  echo '#include "config.h"'       >> gengtype-lex.cc.tmp; \
  echo '#else'                     >> gengtype-lex.cc.tmp; \
  echo '#include "bconfig.h"'      >> gengtype-lex.cc.tmp; \
  echo '#endif'                    >> gengtype-lex.cc.tmp; \
  cat gengtype-lex.cc >> gengtype-lex.cc.tmp; \
  mv gengtype-lex.cc.tmp gengtype-lex.cc; \
}
/c/Users/michelou/workspace-perso/m2-examples/gcc-13-20230219/missing: line 81: flex: command not found
WARNING: 'flex' is missing on your system.
         You should only need it if you modified a '.l' file.
         You may want to install the Fast Lexical Analyzer package:
         <http://flex.sourceforge.net/>
make[2]: [Makefile:3076: gengtype-lex.cc] Error 127 (ignored)
g++ -c -DIN_GCC       -DGENERATOR_FILE -I. -Ibuild -I../.././gcc -I../.././gcc/build -I../.././gcc/../include -I./../intl -I../.././gcc/../libcpp/include  \
        -o build/gengtype-lex.o gengtype-lex.cc
cc1plus: fatal error: gengtype-lex.cc: No such file or directory
compilation terminated.
make[2]: *** [Makefile:2855: build/gengtype-lex.o] Error 1
make[2]: Leaving directory '/c/Users/michelou/workspace-perso/m2-examples/gcc-13-20230219/host-x86_64-pc-mingw32/gcc'
make[1]: *** [Makefile:4651: all-gcc] Error 2
make[1]: Leaving directory '/c/Users/michelou/workspace-perso/m2-examples/gcc-13-20230219'
make: *** [Makefile:1064: all] Error 2

michelou@DESKTOP-U9DCNVQ C:\Users\michelou\workspace-perso\m2-examples\gcc-13-20230219
$ where /r c:\opt\msys64 flex
INFO: Could not find files for the given pattern(s).

michelou@DESKTOP-U9DCNVQ C:\Users\michelou\workspace-perso\m2-examples\gcc-13-20230219
$ C:\opt\msys64\usr\bin\pacman.exe -Sy flex
:: Synchronizing package databases...
 clangarm64                                                            404.7 KiB   269 KiB/s 00:02
[####################################################] 100%  mingw32   431.5 KiB   134 KiB/s 00:03
[####################################################] 100%  mingw64   462.0 KiB   251 KiB/s 00:02
[####################################################] 100%  ucrt64    463.8 KiB   254 KiB/s 00:02
[####################################################] 100%  clang32   418.6 KiB   118 KiB/s 00:04
[####################################################] 100%  clang64   455.0 KiB   575 KiB/s 00:01
[####################################################] 100%  msys is up to date
resolving dependencies...
looking for conflicting packages...

Packages (1) flex-2.6.4-3

Total Download Size:   0.30 MiB
Total Installed Size:  1.53 MiB

:: Proceed with installation? [Y/n] y
:: Retrieving packages...
 flex-2.6.4-3-x86_64                                              303.8 KiB   534 KiB/s 00:01
[####################################################] 100% (1/1) checking keys in keyring                                        
[####################################################] 100% (1/1) checking package integrity
[####################################################] 100% (1/1) loading package files
[####################################################] 100% (1/1) checking for file conflicts
[####################################################] 100% (1/1) checking available disk space
:: Processing package changes...
[####################################################] 100% (1/1) installing flex
:: Running post-transaction hooks...
[####################################################] 100% (1/1) Updating the info directory file...
-->
<!--=======================================================================-->

***

*[mics](https://lampwww.epfl.ch/~michelou/)/July 2026* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- href links -->

[configure_script]: https://www.gnu.org/prep/standards/html_node/Configuration.html
[gcc_cli]: https://gcc.gnu.org/onlinedocs/gcc/Invoking-GCC.html
[gcc_mirror]: https://github.com/gcc-mirror/gcc "GitHub GCC Mirror"
[gnu_make]: https://www.gnu.org/software/make/
[mingw_binaries]: https://github.com/niXman/mingw-builds-binaries/releases
[msys2_automake]: https://packages.msys2.org/package/automake
[msys2_objc]: https://packages.msys2.org/packages/mingw-w64-x86_64-gcc-objc
[msys2_texinfo]: https://packages.msys2.org/package/texinfo
[sh_cli]: https://man7.org/linux/man-pages/man1/sh.1p.html
