#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
OS_ID=$(
  . /etc/os-release
  echo "$ID"
)
readonly OS_ID

echo 'Install VNC Server'
case $OS_ID in
  ol)
    sudo yum --enablerepo=ol7_developer_EPEL -y install Thunar xfce4-panel xfce4-session xfce4-settings xfce4-terminal xfconf xfdesktop xfwm4 xfce4-terminal
    sudo yum -y install tigervnc-server
    ;;
  ubuntu)
    sudo apt update
    sudo apt -y install tigervnc-standalone-server xfce4
    ;;
esac
mkdir -p ~/.vnc
cat <<EOT >>~/.vnc/xstartup
#!/bin/bash
[[ -e ~/.Xresources ]] && xrdb ~/.Xresources
startxfce4 &
EOT
chmod +x ~/.vnc/xstartup
