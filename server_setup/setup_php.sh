#!/bin/sh

# Script updated 2010-04-11 by Fred to php 5.3.2
# Script updated 2009-09-24 by Christopher (heavymark.com) for latest source versions and incorrect url and addition of proper enabling of xmlrpc.
# Script updated 2009-08-05 by Andy (andy.hwang.tw) to correct typo on m4 extract command.
#
# Script updated 2009-07-28 by samutz (samutz.com) to include ZIP, XMLRPC,
# and GNU M4 (previous version of script failed without it)
#
# Script updated 2009-07-24 by ercoppa (ercoppa.org) to convert this script for PHP 5.3 (with all features of dreamhost,# except kerberos) with Xdebug and APC
#
# Script updated 2009-05-24 by ksmoe to correct copying of correct PHP cgi file (php-cgi instead of php)
# Script updated 2006-12-25 by Carl McDade (hiveminds.co.uk) to allow memory limit and freetype
#
# Script updated 2007-11-24 by Andrew (ajmconsulting.net) to allow 3rd wget line to pass
# LIBMCRYPT version information (was set as static download file name previously.)
#
# Script updated 2009-4-25 by Daniel (whathuhstudios.com) for latest source versions
## Save the code to a file as *.sh
# Abort on any errors
#
set -e

# Where do you want all this stuff built? I'd recommend picking a local
# filesystem.
# ***Don't pick a directory that already exists!***  We clean up after
# ourselves at the end!
SRCDIR=${HOME}/src

# And where should it be installed?
INSTALLDIR=${HOME}/php5

# Set DISTDIR to somewhere persistent, if you plan to muck around with this
# script and run it several times!
DISTDIR=${HOME}/dist

# Higher is nicer, lower is less nice and could get your install process killed!
NICE=19

# Pre-download clean up!!!!
rm -rf $SRCDIR

# Update version information here.
PHP5="php-5.3.2"
CURL="curl-7.19.7"XDEBUG="xdebug-2.1.0rc2"
M4="m4-1.4.13"
AUTOCONF="autoconf-2.65"
#AUTOMAKE="automake-1.11.1"
#EAC="eaccelerator-0.9.6"
CCLIENT="imap-2007e"
CCLIENT_DIR="imap-2007e"
OPENSSL="openssl-0.9.8l"
OPENSSL_DIR="openssl-0.9.8l"
LIBMCRYPT="libmcrypt-2.5.8"LIBTOOL="libtool-2.2.6b"
APC="APC-3.1.3"
IMAGEMAGICK="ImageMagick-6.5.9-0"
IMAGICK="imagick-3.0.0RC1"

# What PHP features do you want enabled?
PHPFEATURES="--prefix=${INSTALLDIR} \
--with-config-file-path=${INSTALLDIR}/etc/php5/${DOMAIN} \
--with-config-file-scan-dir=${INSTALLDIR}/etc/php5/${DOMAIN} \
--enable-fastcgi \--bindir=$INSTALLDIR/bin \
--enable-force-cgi-redirect \
--enable-zip \
--enable-xmlrpc \
--with-xmlrpc \
--with-xml \
--with-freetype-dir=/usr \
--with-mhash=/usr \
--with-zlib-dir=/usr \
--with-jpeg-dir=/usr \--with-png-dir=/usr \
--with-curl=${INSTALLDIR} \
--with-gd \
--enable-gd-native-ttf \
--enable-memory-limit \
--enable-soap \
--enable-ftp \
--enable-exif \
--enable-sockets \
--enable-wddx \--enable-sqlite-utf8 \
--enable-calendar \
--enable-mbstring \
--enable-mbregex \
--enable-bcmath \
--with-mysql=/usr \
--with-mysqli \
--without-pear \
--with-gettext \
--with-pdo-mysql \--with-openssl=${INSTALLDIR} \
--with-imap=${INSTALLDIR} \
--with-xsl \
--with-ttf=/usr \
--with-xslt \
--with-xslt-sablot=/usr \
--with-dom-xslt=/usr \
--with-mcrypt=${INSTALLDIR} \
--with-imap-ssl=/usr"
# ---- end of user-editable bits. Hopefully! ----

# Push the install dir's bin directory into the path
export PATH=${INSTALLDIR}/bin:$PATH

echo ---------- Unpacking downloaded archives. This process may take several minutes! ----------

# set up directories
mkdir -p ${SRCDIR}
mkdir -p ${INSTALLDIR}if [ ! -f ${DISTDIR} ]
then
 mkdir -p ${DISTDIR}
fi

cd ${DISTDIR}

# Get all the required packages

if [ ! -f ${DISTDIR}/${PHP5}.tar.gz ] then
 wget -c http://us.php.net/get/${PHP5}.tar.gz/from/ch.php.net/mirror
fi

if [ ! -f ${DISTDIR}/${LIBICONV}.tar.gz ]
then
 wget -c http://mirrors.usc.edu/pub/gnu/libiconv/${LIBICONV}.tar.gz
fi

if [ ! -f ${DISTDIR}/${LIBMCRYPT}.tar.gz ] then
 wget -c http://easynews.dl.sourceforge.net/sourceforge/mcrypt/${LIBMCRYPT}.tar.gz
fi

if [ ! -f ${DISTDIR}/${CURL}.tar.gz ]
then
 wget -c http://curl.haxx.se/download/${CURL}.tar.gz
fi

if [ ! -f ${DISTDIR}/${M4}.tar.gz ] then
 wget -c http://ftp.gnu.org/gnu/m4/${M4}.tar.gz
fi

if [ ! -f ${DISTDIR}/${LIBXML2}.tar.gz ]
then
 wget -c ftp://xmlsoft.org/libxml2/${LIBXML2}.tar.gz
fi

if [ ! -f ${DISTDIR}/${LIBXSLT}.tar.gz ] then
 wget -c ftp://xmlsoft.org/libxml2/${LIBXSLT}.tar.gz
fi

if [ ! -f ${DISTDIR}/${MHASH}.tar.gz ]
then
 wget -c http://downloads.sourceforge.net/project/mhash/mhash/0.9.9.9/${MHASH}.tar.gz
fi

if [ ! -f ${DISTDIR}/${ZLIB}.tar.gz ] then
 wget -c http://www.zlib.net/${ZLIB}.tar.gz
fi

if [ ! -f ${DISTDIR}/${FREETYPE}.tar.gz ]
then
 wget -c http://kent.dl.sourceforge.net/sourceforge/freetype/${FREETYPE}.tar.gz
fi

if [ ! -f ${DISTDIR}/${LIBIDN}.tar.gz ] then
 wget -c ftp://alpha.gnu.org/pub/gnu/libidn/${LIBIDN}.tar.gz
fi

if [ ! -f ${DISTDIR}/${AUTOCONF}.tar.gz ]
then
 wget -c http://ftp.gnu.org/gnu/autoconf/${AUTOCONF}.tar.gz
fi

if [ ! -f ${DISTDIR}/${XDEBUG}.tgz ] then
 wget -c http://xdebug.org/files/${XDEBUG}.tgz
fi

if [ ! -f ${DISTDIR}/${CCLIENT}.tar.gz ]
then
 wget -c ftp://ftp.cac.washington.edu/imap/${CCLIENT}.tar.gz
fi

if [ ! -f ${DISTDIR}/${OPENSSL}.tar.gz ] then
 wget -c http://www.openssl.org/source/${OPENSSL}.tar.gz
fi

if [ ! -f ${DISTDIR}/${APC}.tgz ]
then
 wget -c http://pecl.php.net/get/${APC}.tgz
fi

# ImageMagick
if [ ! -f ${DISTDIR}/${IMAGEMAGICK}.tar.gz ]
then
 wget -c ftp://ftp.imagemagick.org/pub/ImageMagick/${IMAGEMAGICK}.tar.gz
fi

# Imagick
if [ ! -f ${DISTDIR}/${IMAGICK}.tgz ]
then
 wget -c http://pecl.php.net/get/${IMAGICK}.tgz
fi
echo ---------- Unpacking downloaded archives. This process may take several minutes! ----------

cd ${SRCDIR}

# Unpack them all
echo Extracting ${PHP5}...
tar xzf ${DISTDIR}/${PHP5}.tar.gz
echo Done.
 echo Extracting ${LIBICONV}...
tar xzf ${DISTDIR}/${LIBICONV}.tar.gz
echo Done.

echo Extracting ${CURL}...
tar xzf ${DISTDIR}/${CURL}.tar.gz
echo Done.

echo Extracting ${LIBIDN}...
tar xzf ${DISTDIR}/${LIBIDN}.tar.gzecho Done.

#echo Extracting ${M4}...
#tar xzf ${DISTDIR}/${M4}.tar.gz
#echo Done.

echo Extracting ${LIBXML2}...
tar xzf ${DISTDIR}/${LIBXML2}.tar.gz
echo Done.
 echo Extracting ${LIBXSLT}...
tar xzf ${DISTDIR}/${LIBXSLT}.tar.gz
echo Done.

echo Extracting ${MHASH}...
tar xzf ${DISTDIR}/${MHASH}.tar.gz
echo Done.

echo Extracting ${ZLIB}...
tar xzf ${DISTDIR}/${ZLIB}.tar.gzecho Done.

#echo Extracting ${XDEBUG}...
#tar xzf ${DISTDIR}/${XDEBUG}.tgz
#echo Done.

echo Extracting ${AUTOCONF}...
tar xzf ${DISTDIR}/${AUTOCONF}.tar.gz
echo Done.
 echo Extracting ${CCLIENT}...
tar xzf ${DISTDIR}/${CCLIENT}.tar.gz
echo Done.

echo Extracting ${FREETYPE}...
tar xzf ${DISTDIR}/${FREETYPE}.tar.gz
echo Done.

echo Extracting ${OPENSSL}...
uncompress -cd ${DISTDIR}/${OPENSSL}.tar.gz |tar xecho Done.

echo Extracting ${LIBMCRYPT}...
tar xzf ${DISTDIR}/${LIBMCRYPT}.tar.gz
echo Done.

echo Extracting ${APC}...
tar xzf ${DISTDIR}/${APC}.tgz
echo Done.
 echo Extracting ${IMAGEMAGICK}...
tar xzf ${DISTDIR}/${IMAGEMAGICK}.tar.gz
echo Done.

echo Extracting ${IMAGICK}...
tar xzf ${DISTDIR}/${IMAGICK}.tgz
echo Done.

# Build them in the required order to satisfy dependencies
 #libiconv
echo ###################
echo Compile LIBICONV
echo ###################
cd ${SRCDIR}/${LIBICONV}
./configure --enable-extra-encodings --prefix=${INSTALLDIR}
# make clean
make
make install
#libxml2
echo ###################
echo Compile LIBXML2
echo ###################
cd ${SRCDIR}/${LIBXML2}
./configure --with-iconv=${INSTALLDIR} --prefix=${INSTALLDIR}
# make clean
make
make install
#libxslt
echo ###################
echo Compile LIBXSLT
echo ###################
cd ${SRCDIR}/${LIBXSLT}
./configure --prefix=${INSTALLDIR} \
 --with-libxml-prefix=${INSTALLDIR} \
 --with-libxml-include-prefix=${INSTALLDIR}/include/ \
 --with-libxml-libs-prefix=${INSTALLDIR}/lib/
# make cleanmake
make install

#libmcrypt
echo ###################
echo Compile LIBMCRYPT
echo ###################
cd ${SRCDIR}/${LIBMCRYPT}
./configure --disable-posix-threads --prefix=${INSTALLDIR}
# make cleanmake
make install

#libmcrypt lltdl issue!!
cd  ${SRCDIR}/${LIBMCRYPT}/libltdl
./configure --prefix=${INSTALLDIR} --enable-ltdl-install
# make clean
make
make install
 #zlib
echo ###################
echo Compile ZLIB
echo ###################
cd ${SRCDIR}/${ZLIB}
./configure --shared --prefix=${INSTALLDIR}
# make clean
make
make install
 #mhash
echo ###################
echo Compile MHASH
echo ###################
cd ${SRCDIR}/${MHASH}
./configure --prefix=${INSTALLDIR}
# make clean
make
make install
 #freetype
echo ###################
echo Compile FREETYPE
echo ###################
cd ${SRCDIR}/${FREETYPE}
./configure --prefix=${INSTALLDIR}
# make clean
make
make install
 #libidn
echo ###################
echo Compile LIBIDN
echo ###################
cd ${SRCDIR}/${LIBIDN}
./configure --with-iconv-prefix=${INSTALLDIR} --prefix=${INSTALLDIR}
# make clean
make
make install
 #cURL
echo ###################
echo Compile CURL
echo ###################
cd ${SRCDIR}/${CURL}
#php 5.3.0
#./configure --enable-ipv6 --enable-cookies \
# --enable-crypto-auth --prefix=${INSTALLDIR}
# or php < 5.3.0
  ./configure --with-ssl=${INSTALLDIR} --with-zlib=${INSTALLDIR} \
  --with-libidn=${INSTALLDIR} --enable-ipv6 --enable-cookies \
  --enable-crypto-auth --prefix=${INSTALLDIR}
# make clean
make
make install

#M4
#echo ###################
#echo Compile M4
#echo ###################
#cd ${SRCDIR}/${M4}
#./configure --prefix=${INSTALLDIR}
# make clean
#make
#make install

#CCLIENT
echo ###################
echo Compile CCLIENT
echo ###################
cd ${SRCDIR}/${CCLIENT_DIR}
make ldb
# Install targets are for wusses!
cp c-client/c-client.a ${INSTALLDIR}/lib/libc-client.a
cp c-client/*.h ${INSTALLDIR}/include

#OPENSSL
echo ###################
echo Compile OPENSSL
echo ###################
# openssl
cd ${SRCDIR}/${OPENSSL_DIR}
./config shared zlib --prefix=${INSTALLDIR}
make
make install

# IMAGEMAGICK
echo ###################
echo Compile IMAGEMAGICK
echo ###################
cd ${SRCDIR}/${IMAGEMAGICK}
./configure -with-gslib --with-gs-font-dir=/usr/share/fonts/type1/gsfonts/ --without-perl --prefix=${INSTALLDIR}
# make clean
make
make install

#PHP 5
echo ###################
echo Compile PHP
echo ###################
cd ${SRCDIR}/${PHP5}
./configure ${PHPFEATURES}
# make clean
make
make install

# Copy a basic configuration for PHP
mkdir -p ${INSTALLDIR}/etc/php5/${DOMAIN}
#cp ${SRCDIR}/${PHP5}/php.ini-production ${INSTALLDIR}/etc/php5/${DOMAIN}/php.ini
cp ${SRCDIR}/${PHP5}/php.ini-dist ${INSTALLDIR}/etc/php5/${DOMAIN}/php.ini
#AUTOCONF
echo ###################
echo Compile AUTOCONF
echo ###################
cd ${SRCDIR}/${AUTOCONF}
./configure --prefix=${INSTALLDIR}
# make clean
make
make install

# XDEBUG
# echo ###################
# echo Compile XDEBUG
# echo ###################
# cd ${SRCDIR}/${XDEBUG}
# export PHP_AUTOHEADER=${INSTALLDIR}/bin/autoheader
# export PHP_AUTOCONF=${INSTALLDIR}/bin/autoconf
# echo $PHP_AUTOHEADER
# echo $PHP_AUTOCONF# ${INSTALLDIR}/bin/phpize
# ./configure --enable-xdebug --with-php-config=${INSTALLDIR}/bin/php-config --prefix=${INSTALLDIR}
# # make clean
# make
# mkdir -p ${INSTALLDIR}/extensions
# cp modules/xdebug.so ${INSTALLDIR}/extensions
# echo "zend_extension=${INSTALLDIR}/extensions/xdebug.so" >> ${INSTALLDIR}/etc/php5/${DOMAIN}/xdebug.ini


# APCecho ###################
echo Compile APC
echo ###################
cd ${SRCDIR}/${APC}
${INSTALLDIR}/bin/phpize
./configure --enable-apc --enable-apc-mmap --with-php-config=${INSTALLDIR}/bin/php-config --prefix=${INSTALLDIR}
# make clean
make
cp modules/apc.so ${INSTALLDIR}/extensions
echo "extension=${INSTALLDIR}/extensions/apc.so" >> ${INSTALLDIR}/etc/php5/${DOMAIN}/apc.ini
# Copy PHP CGI
mkdir -p ${HOME}/${DOMAIN}/cgi-bin
chmod 0755 ${HOME}/${DOMAIN}/cgi-bin
cp ${INSTALLDIR}/bin/php-cgi ${HOME}/${DOMAIN}/cgi-bin/php.cgi

# Create .htaccess
if [ -f ${HOME}/${DOMAIN}/.htaccess ]
then
 echo # echo '#####################################################################'
 echo ' Your domain already has a .htaccess, it is ranamed .htaccess_old    '
 echo '               --> PLEASE FIX THIS PROBLEM <--                       '
 echo '#####################################################################'
 echo #
 mv ${HOME}/${DOMAIN}/.htaccess ${HOME}/${DOMAIN}/.htaccess_old
fi

echo 'Options +ExecCGI' >> ${HOME}/${DOMAIN}/.htaccess
echo 'AddHandler php-cgi .php' >> ${HOME}/${DOMAIN}/.htaccess
echo 'Action php-cgi /cgi-bin/php.cgi' >> ${HOME}/${DOMAIN}/.htaccess
echo '' >> ${HOME}/${DOMAIN}/.htaccess
echo '<FilesMatch "^php5?\.(ini|cgi)$">' >> ${HOME}/${DOMAIN}/.htaccess
echo 'Order Deny,Allow' >> ${HOME}/${DOMAIN}/.htaccess
echo 'Deny from All' >> ${HOME}/${DOMAIN}/.htaccess
echo 'Allow from env=REDIRECT_STATUS' >> ${HOME}/${DOMAIN}/.htaccess
echo '</FilesMatch>' >> ${HOME}/${DOMAIN}/.htaccess

# IMAGICK
echo ###################echo Compile IMAGICK
echo ###################
cd ${SRCDIR}/${IMAGICK}
echo $PHP_AUTOHEADER
echo $PHP_AUTOCONF
${INSTALLDIR}/bin/phpize
./configure --prefix=${INSTALLDIR}/imagick --with-imagick=${INSTALLDIR} --with-php-config=${INSTALLDIR}/bin/php-config
# make clean
make
cp modules/imagick.so ${INSTALLDIR}/extensions
echo "extension=${INSTALLDIR}/extensions/imagick.so" >> ${INSTALLDIR}/etc/php5/${DOMAIN}/imagick.ini

# clean up
rm -rf $SRCDIR $DISTDIR

echo ---------- INSTALL COMPLETE! ----------
echo
echo 'Configuration files:'
echo "1) General PHP -> ${INSTALLDIR}/etc/php5/${DOMAIN}/php.ini"
echo "2) Xdebug conf -> ${INSTALLDIR}/etc/php5/${DOMAIN}/xdebug.ini"
echo "3) APC conf -> ${INSTALLDIR}/etc/php5/${DOMAIN}/apc.ini"
echo "3) Imagick conf -> ${INSTALLDIR}/etc/php5/${DOMAIN}/imagick.ini"
echo
echo 'You have to modify these files in order to enable Xdebug, APC, or Imagick features.'

exit 0
