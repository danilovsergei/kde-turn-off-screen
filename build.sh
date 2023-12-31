#!/bin/bash
build_dir=$(dirname `realpath "$0"`)
bin_dir=$build_dir/bin

cd $build_dir
#rm -r bin/*

go build -ldflags="-s -w" -o bin/kde-turn-off-screen-temp

cp systemd/kde-turn-off-screen.service bin/

cd bin
if [ ! -f "rce-execve" ]; then
  rm "rce-execve"
fi

upx -force-execve --best --brute kde-turn-off-screen-temp

if [ ! -f "rce-execve" ]; then
  "Echo failed to compress binary"
  exit 1
fi

mv "rce-execve" kde-turn-off-screen
rm kde-turn-off-screen-temp

chmod +x kde-turn-off-screen
chmod +x install.sh



