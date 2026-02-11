#!/usr/bin/env python3
# Restarts wallpaper and caelestia shell after hyprland config reload

import os
import socket
import subprocess
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

def main():
    path = get_socket_path()
    if not path:
        return

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

if __name__ == "__main__":
    main()
