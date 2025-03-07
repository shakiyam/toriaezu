#!/bin/bash
set -eu -o pipefail

# shellcheck disable=SC1091
OS_ID=$(
  . /etc/os-release
  echo "$ID"
)
readonly OS_ID
# shellcheck disable=SC1091
OS_VERSION=$(
  . /etc/os-release
  echo "$VERSION"
)
readonly OS_VERSION

echo 'Install VNC Server'
mkdir -p ~/.vnc
case $OS_ID in
  ol)
    case ${OS_VERSION%%.*} in
      8)
        sudo dnf -y --enablerepo=ol8_developer_EPEL install Thunar tigervnc-server xfce4-panel xfce4-session xfce4-settings xfce4-terminal xfconf xfdesktop xfwm4
        sudo tee -a /etc/tigervnc/vncserver.users <<EOT >/dev/null
:1=$(id -un)
EOT
        echo "VNC Password"
        vncpasswd
        sudo systemctl enable --now vncserver@:1
        ;;
      9)
        echo 'VNC Server is not yet tested on Oracle Linux 9.'
        exit 0
        # sudo dnf -y --enablerepo=ol9_developer_EPEL install Thunar tigervnc-server xfce4-panel xfce4-session xfce4-settings xfce4-terminal xfconf xfdesktop xfwm4
        ;;
    esac
    ;;
  ubuntu)
    sudo apt-get update
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y install tigervnc-standalone-server xfce4
    cat <<'EOT' >~/.vnc/xstartup
#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
/usr/bin/startxfce4
[[ -x /etc/vnc/xstartup ]] && exec /etc/vnc/xstartup
[[ -r $HOME/.Xresources ]] && xrdb $HOME/.Xresources
x-window-manager &
EOT
    chmod +x ~/.vnc/xstartup
    echo "VNC Password"
    vncpasswd
    echo "Run 'vncserver -localhost no'"
    ;;
esac
