#!/bin/sh

#
# Script for nginx install
#
# update 15.05.2010
# @author Andrei Subbota <subbota@gmail.com>
# @todo check exists library
# @todo install openssl
# @todo install pcre
# @todo install md5
#

#Exit on error
set -e
clear

#=====================
#@todo Update versions, if necessary
NGINX="nginx-0.8.36"
ZLIB="zlib-1.2.5"

#@todo Update install paths, if necessary
NGINX_USER="nginx"
NGINX_GROUP="nginx"
NGINX_BIN_DIR="/usr/local/sbin/nginx"
NGINX_CONF_DIR="/etc/nginx/nginx.conf"
NGINX_LOG_DIR="/var/log/nginx/error.log"
NGINX_BASE_DIR="/usr/local"

ZLIB_BASE_DIR="/usr/local"

#@todo Alter features, if necessary
NGINX_FEATURES="--user=$NGINX_USER \
 --group=$NGINX_GROUP \
 --conf-path=$NGINX_CONF_DIR \
 --sbin-path= $NGINX_BIN_DIR \
 --error-log-path=$NGINX_LOG_DIR \
 --with-pcre \
 --with-http_ssl_module \
 --with-file-aio \
 --with-http_gzip_static_module \
 --without-mail_pop3_module \
 --without-mail_imap_module \
 --without-mail_smtp_module \
 --without-http_limit_zone_module \
 --without-http_limit_req_module \
 --without-http_empty_gif_module \
 --without-http_geo_module \
 --without-http_ssi_module \
"
ZLIB_FEATURES="--64 \
"

DOWNLOADS_DIR="tmp"
BUILD_DIR="$DOWNLOADS_DIR/build"

#===============================================================================

#@param string $1 Messagefunction echoL1 () {
    echo -e "\n\033[1;37;44m$1\033[0;0;0m\n"
}

#@param string $1 Message
function echoL2 () {
    echo -e "\n\033[0;37;44m$1\033[0;0;0m\n"
}

#@param string $1 URL
#@param string $2 Output directory
function downloadTo () {
    wget -c $1 --directory-prefix=$2
}

#@param string $1 TAR filename
#@param string $2 Output directory
function untarTo () {
    cd $2
    tar -xf $1    cd -
}

#@param string $1 Source directory
#@param string $2 Output directory
#@param string $3 configure arguments
function configureAndMake () {
    cd $1
    COMMAND="./configure --quiet --prefix=$2 $3"
    if [ $1 = "$BUILD_DIR/$OPENSSL" ];then
      #special command for OPEN SSL
      COMMAND="./config --prefix=$2 $3"
    fi
    echo "$COMMAND"
    eval $COMMAND
    make --quiet
    cd -
}

#@param string $1 Source directory
#@param string $2 Output directory
#@param string $3 configure arguments
function makeAndInstall () {
    configureAndMake $1 $2 "$3"
    cd $1
    make install --quiet
    cd -
}

#@param string $1 Directory
function mkdirClean () {
    rm -rf $1
    mkdir -p $1
}

#@param string $1 Message
function echoWarning () {
    echo -e "\n\033[1;37;41m$1\033[0;0;0m\n"
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
export PATH="$PATH:$NGINX_BIN_DIR"

echoL1 "-> DOWNLOADING..."

mkdirClean $BUILD_DIR

echoL2 "--> Downloading $ZLIB..."
downloadTo "http://zlib.net/$ZLIB.tar.gz" $DOWNLOADS_DIR
untarTo "$DOWNLOADS_DIR/$ZLIB.tar.gz" $BUILD_DIR

echoL2 "--> Downloading $NGINX..."
downloadTo "http://sysoev.ru/nginx/$NGINX.tar.gz" $DOWNLOADS_DIR
untarTo "$DOWNLOADS_DIR/$NGINX.tar.gz" $BUILD_DIR

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

echoL1 "-> BUILDING..."

echoL2 "--> Building $NGINX..."
makeAndInstall "$BUILD_DIR/$ZLIB" $ZLIB_BASE_DIR $ZLIB_FEATURES

echoL2 "--> Building $NGINX..."
makeAndInstall "$BUILD_DIR/$NGINX" $NGINX_BASE_DIR $NGINX_FEATURES

echoL1 "DONE"

exit 0
