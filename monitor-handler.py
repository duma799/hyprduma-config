#!/usr/bin/env python3
# Restarts wallpaper and caelestia shell after hyprland config reload

import os
import socket
import subprocess
import sys
import time

def get_socket_path():
    xdg = os.environ.get("XDG_RUNTIME_DIR")
    sig = os.environ.get("HYPRLAND_INSTANCE_SIGNATURE")
    if not xdg or not sig:
        return None
    return f"{xdg}/hypr/{sig}/.socket2.sock"

def is_running(name):
    return subprocess.run(["pgrep", "-x", name], capture_output=True).returncode == 0

def handle_reload():
    time.sleep(1)
    if not is_running("swaybg"):
        subprocess.Popen(["waypaper", "--restore"])
    if not is_running("caelestia"):
        time.sleep(1)
        subprocess.Popen(["caelestia", "shell", "-d"])

def listen(path):
    sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    sock.connect(path)
    buf = ""

    while True:
        data = sock.recv(4096).decode()
        if not data:
            break
        buf += data
        while "\n" in buf:
            line, buf = buf.split("\n", 1)
            if line.startswith("configreloaded"):
                handle_reload()

    sock.close()

def main():
    path = get_socket_path()
    if not path:
        print("monitor-handler: HYPRLAND_INSTANCE_SIGNATURE not set", file=sys.stderr)
        return

    while True:
        try:
            listen(path)
        except (ConnectionRefusedError, FileNotFoundError):
            pass
        except Exception as e:
            print(f"monitor-handler: {e}", file=sys.stderr)

        # Socket closed or errored — wait and retry
        time.sleep(2)

        # Re-check socket path in case Hyprland restarted with new signature
        new_path = get_socket_path()
        if new_path:
            path = new_path

if __name__ == "__main__":
    main()
