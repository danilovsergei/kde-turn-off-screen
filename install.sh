#!/bin/bash
bin_name="kde-turn-off-screen"
abs_bin_path=$bin_dir/$bin_name
service_file=kde-turn-off-screen.service
systemd_dir=$HOME/.config/systemd/user
latest_release="https://github.com/danilovsergei/kde-turn-off-screen/releases/latest/download/"

# creates directory if it does not exist
function create_dir() {
  if [[ ! -d "$1" ]]; then
    mkdir -p "$1"
  fi
}

if [ $# -eq 0 ]; then
  echo "Error: No installation dir is provided"
  echo "Example: install.sh ~/local/kde-turn-off-screen"
  exit 1
fi

# location kde-turn-off-screen binary will be installed
bin_dir="$1"
create_dir $bin_dir

echo -e "Download latest release from github $latest_release\n"
temp_dir=$(mktemp -d)
cd "$temp_dir"
curl -s -L "$latest_release/$bin_name" -o "$bin_name"
curl -s -L "$latest_release/$service_file" -o "$service_file"
chmod +x kde-turn-off-screen


echo -e "Copy $bin_name into $bin_dir\n"
cp -f $bin_name "$bin_dir/"

echo -e "Replace <bin_dir> with $bin_dir in $service_file\n"  
sed -i "s|=<bin_dir>|=$bin_dir|g" $service_file

if ! ( grep -q "$abs_bin_path" "$service_file" ); then
  echo "Failed to replace ExecStart in $service_file to $abs_bin_path"
fi

echo -e "Remove TODO line from $service_file \n"
sed -i '/^# TODO/d' "$service_file"


echo -e "Copy $service_file to $systemd_dir\n"
create_dir $systemd_dir
cp -f $service_file "$systemd_dir/"

echo -e "Start $service_file service\n"
systemctl --user enable $service_file
systemctl --user start $service_file

service_status=$(systemctl --user status $service_file)
if ! ( echo $service_status | grep -q "active" ); then
  echo -e "\nFailed to start $service_file\n"
  echo "Run systemctl --user status $service_file for details"
fi

echo -e "Service $service_file started\n"