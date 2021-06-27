#!/bin/sh
set -e
workdir=`mktemp -d`
clean_up () {
    cd
    rm -fr "$workdir"
}
trap clean_up EXIT
bindir="$(cd `dirname "$0"` && pwd)"
fernflower="$bindir/fernflower.jar"
apatch="$bindir/a.patch"

jar="$workdir/file.jar"
cp "$1" "$jar"
userdir=`pwd`

classes="$workdir/classes"
decomp="$workdir/decomp"
mkdir -p "$classes"
mkdir -p "$decomp"
cd "$classes"
unzip "$jar" com/vk/api/sdk/httpclient/HttpTransportClient.class
java -jar "$fernflower" "$classes" "$decomp"

cd "$decomp"
patch -p1 --no-backup-if-mismatch < "$apatch"
javac -cp "$jar" com/vk/api/sdk/httpclient/HttpTransportClient.java
rm com/vk/api/sdk/httpclient/HttpTransportClient.java
7z a "$jar" com

cd "$userdir"
mv "$jar" "$2"
