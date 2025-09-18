#!/bin/bash
set -eEu -o pipefail

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/common.sh"

OS_ID=$(get_os_id)
readonly OS_ID
OS_VERSION=$(get_os_version)
readonly OS_VERSION

echo_info 'Install VNC Server'
mkdir -p ~/.vnc
case $OS_ID in
  ol)
    case ${OS_VERSION%%.*} in
      8)
        install_package --epel Thunar tigervnc-server xfce4-panel xfce4-session xfce4-settings xfce4-terminal xfconf xfdesktop xfwm4
        sudo tee -a /etc/tigervnc/vncserver.users <<EOT >/dev/null
:1=$(id -un)
EOT
        echo_info "VNC Password"
        vncpasswd
        sudo systemctl enable --now vncserver@:1
        ;;
      9)
        echo_warn 'VNC Server is not yet tested on Oracle Linux 9.'
        exit 0
        # install_package --epel Thunar tigervnc-server xfce4-panel xfce4-session xfce4-settings xfce4-terminal xfconf xfdesktop xfwm4
        ;;
    esac
    ;;
  ubuntu)
    install_package tigervnc-standalone-server xfce4
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
    echo_info "VNC Password"
    vncpasswd
    echo_info "Run 'vncserver -localhost no'"
    ;;
esac
