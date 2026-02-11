#!/usr/bin/env python3
"""
HyprDuma Config Auto-Installer
Automates the complete installation of HyprDuma dotfiles.
Run: python3 install.py
"""

import configparser
import subprocess
import sys
import shutil
from pathlib import Path

# --- Colors ---
RESET = "\033[0m"
BOLD = "\033[1m"
RED = "\033[31m"
GREEN = "\033[32m"
YELLOW = "\033[33m"
BLUE = "\033[34m"
MAGENTA = "\033[35m"
CYAN = "\033[36m"

REPO_URL = "https://github.com/duma799/hyprduma-config.git"

PACMAN_PACKAGES = [
    "hyprland", "hyprlock", "hyprshot", "wlogout", "kitty", "waybar",
    "swaybg", "waypaper", "wofi", "nautilus", "wireplumber",
    "pipewire-pulse", "brightnessctl", "playerctl", "adwaita-cursors",
    "python-pywal", "fastfetch",
]


def print_step(num, total, msg):
    print(f"\n{BOLD}{BLUE}[{num}/{total}]{RESET} {BOLD}{msg}{RESET}")


def print_ok(msg):
    print(f"  {GREEN}✓{RESET} {msg}")


def print_warn(msg):
    print(f"  {YELLOW}!{RESET} {msg}")


def print_err(msg):
    print(f"  {RED}✗{RESET} {msg}")


def print_info(msg):
    print(f"  {CYAN}→{RESET} {msg}")


def ask_yn(prompt, default=True):
    suffix = " [Y/n] " if default else " [y/N] "
    try:
        answer = input(f"  {MAGENTA}?{RESET} {prompt}{suffix}").strip().lower()
    except (EOFError, KeyboardInterrupt):
        print()
        sys.exit(1)
    if not answer:
        return default
    return answer in ("y", "yes")


def run(cmd, check=True, capture=False, **kwargs):
    """Run a shell command."""
    if capture:
        result = subprocess.run(
            cmd, shell=True, capture_output=True, text=True, **kwargs
        )
        if check and result.returncode != 0:
            return None
        return result.stdout.strip()
    else:
        result = subprocess.run(cmd, shell=True, **kwargs)
        if check and result.returncode != 0:
            return False
        return result.returncode == 0


def cmd_exists(name):
    return shutil.which(name) is not None


def find_repo_dir():
    """Determine the repo directory - either CWD or needs cloning."""
    cwd = Path.cwd()
    # Check if we're inside the cloned repo
    if (cwd / "hyprland.conf").exists() and (cwd / "pywal.sh").exists():
        return cwd
    # Check if install.py is in the repo
    script_dir = Path(__file__).resolve().parent
    if (script_dir / "hyprland.conf").exists() and (script_dir / "pywal.sh").exists():
        return script_dir
    return None


def check_arch():
    """Verify we're on Arch Linux."""
    if not Path("/etc/arch-release").exists():
        print_err("This installer is designed for Arch Linux (or Arch-based distros).")
        if not ask_yn("Continue anyway?", default=False):
            sys.exit(1)


def install_aur_helpers():
    """Step: Install yay and paru (optional)."""
    has_yay = cmd_exists("yay")
    has_paru = cmd_exists("paru")

    if has_yay and has_paru:
        print_ok("yay and paru are already installed")
        return

    if has_yay:
        print_ok("yay is already installed")
    if has_paru:
        print_ok("paru is already installed")

    missing = []
    if not has_yay:
        missing.append("yay")
    if not has_paru:
        missing.append("paru")

    if not ask_yn(f"Install AUR helper(s): {', '.join(missing)}?"):
        print_warn("Skipping AUR helpers (caelestia-shell will require manual install)")
        return

    run("sudo pacman -S --needed --noconfirm git base-devel")

    for helper in missing:
        print_info(f"Building {helper} from AUR...")
        build_dir = Path(f"/tmp/{helper}-build")
        if build_dir.exists():
            shutil.rmtree(build_dir)
        ok = run(
            f"git clone https://aur.archlinux.org/{helper}.git {build_dir}"
            f" && cd {build_dir} && makepkg -si --noconfirm"
        )
        if ok:
            print_ok(f"{helper} installed")
        else:
            print_err(f"Failed to install {helper} - you can install it manually later")
        if build_dir.exists():
            shutil.rmtree(build_dir)


def install_packages():
    """Step: Install required packages via pacman."""
    print_info(f"Packages: {' '.join(PACMAN_PACKAGES)}")

    if not ask_yn("Install required packages via pacman?"):
        print_warn("Skipping package installation")
        return

    pkg_str = " ".join(PACMAN_PACKAGES)
    if not run(f"sudo pacman -S --needed --noconfirm {pkg_str}"):
        print_err("Some packages failed to install - check output above")
    else:
        print_ok("All packages installed")


def install_caelestia():
    """Step: Install Caelestia Shell (optional)."""
    already_installed = cmd_exists("caelestia")

    if already_installed:
        print_ok("Caelestia shell is already installed")
    else:
        if not cmd_exists("yay") and not cmd_exists("paru"):
            print_warn("No AUR helper found - skipping Caelestia (install manually: yay -S caelestia-shell)")
            return

        if not ask_yn("Install Caelestia Shell (recommended for dynamic theming)?"):
            print_warn("Skipping Caelestia shell")
            return

        helper = "yay" if cmd_exists("yay") else "paru"
        if run(f"{helper} -S --noconfirm caelestia-shell"):
            print_ok("Caelestia shell installed")
        else:
            print_err("Failed to install Caelestia - you can try manually: yay -S caelestia-shell")
            return

    # Pre-create state directories so caelestia shell starts cleanly
    state_dir = Path.home() / ".local" / "state" / "caelestia"
    wallpaper_dir = state_dir / "wallpaper"
    wallpaper_dir.mkdir(parents=True, exist_ok=True)
    print_ok("Created Caelestia state directories (~/.local/state/caelestia/)")

    # Launch caelestia shell if Hyprland is running
    if run("pgrep -x Hyprland", capture=True) is not None:
        print_info("Hyprland detected, launching Caelestia shell...")
        run("caelestia shell -d &", check=False)
        print_ok("Caelestia shell launched")
    else:
        print_info("Caelestia will start automatically on next Hyprland session")


def clone_repo():
    """Step: Clone the repository if needed. Returns repo Path."""
    repo_dir = find_repo_dir()
    if repo_dir:
        print_ok(f"Using repo at: {repo_dir}")
        return repo_dir

    clone_target = Path.home() / "Downloads" / "hyprduma-config"
    print_info(f"Cloning to {clone_target}")

    if clone_target.exists():
        if ask_yn(f"{clone_target} already exists. Remove and re-clone?"):
            shutil.rmtree(clone_target)
        else:
            if (clone_target / "hyprland.conf").exists():
                return clone_target
            print_err("Directory exists but doesn't contain config files")
            sys.exit(1)

    if run(f"git clone {REPO_URL} {clone_target}"):
        print_ok("Repository cloned")
        return clone_target
    else:
        print_err("Failed to clone repository")
        sys.exit(1)


def backup_configs():
    """Step: Backup existing configs."""
    config = Path.home() / ".config"
    backed_up = []

    for name in ["hypr", "waybar", "wlogout", "waypaper"]:
        src = config / name
        dst = config / f"{name}.backup"
        if src.exists() and not src.is_symlink():
            if dst.exists():
                print_warn(f"{dst} already exists - skipping backup of {name}")
                continue
            shutil.move(str(src), str(dst))
            backed_up.append(name)

    if backed_up:
        print_ok(f"Backed up: {', '.join(f'~/.config/{n}' for n in backed_up)}")
    else:
        print_ok("No existing configs to back up")


def install_hypr_config(repo):
    """Step: Copy Hyprland configuration files."""
    hypr_dir = Path.home() / ".config" / "hypr"
    hypr_dir.mkdir(parents=True, exist_ok=True)

    # Copy main config
    shutil.copy2(repo / "hyprland.conf", hypr_dir / "hyprland.conf")
    print_ok("Copied hyprland.conf")

    # Create screenshots directory
    screenshots = Path.home() / "Pictures" / "Screenshots"
    screenshots.mkdir(parents=True, exist_ok=True)
    print_ok(f"Created {screenshots}")

    # Copy wallpapers
    wallpapers_src = repo / "wallpapers"
    wallpapers_dst = hypr_dir / "wallpapers"
    if wallpapers_src.exists():
        if wallpapers_dst.exists():
            shutil.rmtree(wallpapers_dst)
        shutil.copytree(str(wallpapers_src), str(wallpapers_dst))
        count = len(list(wallpapers_dst.iterdir()))
        print_ok(f"Copied {count} wallpapers to ~/.config/hypr/wallpapers/")


def install_pywal(repo):
    """Step: Install pywal integration."""
    home = Path.home()
    hypr_dir = home / ".config" / "hypr"
    hypr_dir.mkdir(parents=True, exist_ok=True)

    # 1. Pywal templates
    templates_dst = home / ".config" / "wal" / "templates"
    templates_dst.mkdir(parents=True, exist_ok=True)
    templates_src = repo / "wal" / "templates"
    if templates_src.exists():
        for f in templates_src.iterdir():
            shutil.copy2(str(f), str(templates_dst / f.name))
        print_ok("Installed pywal templates")
    else:
        print_err("wal/templates not found in repo")

    # 2. Copy scripts to ~/.config/hypr/
    for script in ["pywal.sh", "sync-caelestia-wallpaper.sh", "waypaper-hook.sh"]:
        src = repo / script
        dst = hypr_dir / script
        if src.exists():
            shutil.copy2(str(src), str(dst))
            dst.chmod(0o755)
    print_ok("Copied pywal.sh, sync-caelestia-wallpaper.sh, and waypaper-hook.sh to ~/.config/hypr/")

    # 2b. Register waypaper hook in waypaper config
    hook_cmd = str(hypr_dir / "waypaper-hook.sh")
    waypaper_config_dir = home / ".config" / "waypaper"
    waypaper_config_dir.mkdir(parents=True, exist_ok=True)
    waypaper_ini = waypaper_config_dir / "config.ini"

    config = configparser.ConfigParser()
    if waypaper_ini.exists():
        config.read(str(waypaper_ini))

    if not config.has_section("Settings"):
        config.add_section("Settings")

    existing_post = config.get("Settings", "post_command", fallback="")
    if existing_post and existing_post != hook_cmd:
        print_warn(f"Waypaper already has post_command: {existing_post}")
        if ask_yn("Replace with waypaper-hook.sh?"):
            config.set("Settings", "post_command", hook_cmd)
            with open(str(waypaper_ini), "w") as f:
                config.write(f)
            print_ok("Updated waypaper post_command to use waypaper-hook.sh")
        else:
            print_info(f"To add manually: set post_command = {hook_cmd} in ~/.config/waypaper/config.ini")
    else:
        config.set("Settings", "post_command", hook_cmd)
        with open(str(waypaper_ini), "w") as f:
            config.write(f)
        print_ok("Registered waypaper-hook.sh as waypaper post_command")

    # 3. Copy pywal.sh to home for easy access
    home_pywal = home / "pywal.sh"
    shutil.copy2(str(repo / "pywal.sh"), str(home_pywal))
    home_pywal.chmod(0o755)
    print_ok("Copied pywal.sh to ~/pywal.sh")

    # 4. Kitty config
    kitty_dir = home / ".config" / "kitty"
    kitty_dir.mkdir(parents=True, exist_ok=True)
    kitty_src = repo / "kitty" / "kitty.conf"
    if kitty_src.exists():
        shutil.copy2(str(kitty_src), kitty_dir / "kitty.conf")
        print_ok("Installed kitty config with pywal colors")

    # 5. Bashrc pywal integration
    bashrc = home / ".bashrc"
    pywal_marker = "# Import pywal colorscheme from cache"
    already_configured = False

    if bashrc.exists():
        content = bashrc.read_text()
        if pywal_marker in content:
            already_configured = True

    if already_configured:
        print_ok("~/.bashrc already has pywal integration")
    else:
        snippet = (
            "\n# Import pywal colorscheme from cache\n"
            "(cat ~/.cache/wal/sequences &)\n"
            "\n# To add support for TTYs (optional)\n"
            "source ~/.cache/wal/colors-tty.sh 2>/dev/null\n"
        )
        with open(bashrc, "a") as f:
            f.write(snippet)
        print_ok("Added pywal integration to ~/.bashrc")

    # 6. Generate initial colors from default wallpaper
    wallpaper = hypr_dir / "wallpapers" / "sakura.jpg"
    if not wallpaper.exists():
        # Fallback: find any wallpaper
        wp_dir = hypr_dir / "wallpapers"
        if wp_dir.exists():
            for ext in ("*.jpg", "*.png", "*.jpeg"):
                found = list(wp_dir.glob(ext))
                if found:
                    wallpaper = found[0]
                    break

    if wallpaper.exists() and cmd_exists("wal"):
        print_info(f"Generating pywal colors from {wallpaper.name}...")
        run(f'wal -i "{wallpaper}"')
        print_ok("Generated initial pywal color scheme")

        # Apply colors
        pywal_script = home / "pywal.sh"
        if pywal_script.exists():
            if run(f'bash "{pywal_script}"'):
                print_ok("Applied pywal colors to all components")
            else:
                print_warn("pywal.sh had errors (normal if Hyprland isn't running yet)")
    elif not cmd_exists("wal"):
        print_warn("pywal (wal) not found - install python-pywal and run: wal -i <wallpaper> && ~/pywal.sh")
    else:
        print_warn("No wallpaper found - run manually: wal -i <wallpaper> && ~/pywal.sh")


def install_fastfetch_config(repo):
    """Step: Install fastfetch configuration."""
    home = Path.home()
    fastfetch_src = repo / "fastfetch"

    if not fastfetch_src.exists():
        print_warn("fastfetch/ directory not found in repo - skipping")
        return

    if not ask_yn("Install fastfetch config?"):
        print_warn("Skipping fastfetch config")
        return

    # Copy to ~/.config/fastfetch/
    fastfetch_dst = home / ".config" / "fastfetch"
    if fastfetch_dst.exists():
        shutil.rmtree(str(fastfetch_dst))
    shutil.copytree(str(fastfetch_src), str(fastfetch_dst))

    # Fix hardcoded /home/duma/ path in config.jsonc for the current user
    config_file = fastfetch_dst / "config.jsonc"
    if config_file.exists():
        content = config_file.read_text()
        fixed = content.replace("/home/duma/", str(home) + "/")
        if fixed != content:
            config_file.write_text(fixed)
            print_ok("Fixed fastfetch config paths for current user")

    print_ok("Installed fastfetch config to ~/.config/fastfetch/")


def print_banner():
    print(f"""{CYAN}{BOLD}
  ╦ ╦╦ ╦╔═╗╦═╗╔╦╗╦ ╦╔╦╗╔═╗
  ╠═╣╚╦╝╠═╝╠╦╝ ║║║ ║║║║╠═╣
  ╩ ╩ ╩ ╩  ╩╚══╩╝╚═╝╩ ╩╩ ╩
     Auto-Installer{RESET}
""")


def print_post_install():
    print(f"""
{BOLD}{GREEN}Installation complete!{RESET}

{BOLD}Next steps:{RESET}
  {CYAN}1.{RESET} Edit your app preferences in ~/.config/hypr/hyprland.conf (lines 27-34):
     $terminal, $fileManager, $menu, $browser, etc.

  {CYAN}2.{RESET} Adjust monitor config (lines 4-18) if your setup differs.

  {CYAN}3.{RESET} Start Hyprland from TTY:
     $ {BOLD}Hyprland{RESET}

     Or if already running, reload with: {BOLD}SUPER + SHIFT + R{RESET}

  {CYAN}4.{RESET} Change wallpaper + colors anytime:
     $ wal -i ~/path/to/wallpaper.jpg && ~/pywal.sh
     Or use waypaper GUI ({BOLD}SUPER + W{RESET}) - colors auto-apply via hook

  {CYAN}5.{RESET} Try {BOLD}fastfetch{RESET} in your terminal to see system info with custom styling

{BOLD}Backups:{RESET} Original configs saved as ~/.config/<name>.backup
{BOLD}Docs:{RESET}    See KEYBINDS.md for all keyboard shortcuts
""")


def main():
    print_banner()

    # Pre-flight check
    check_arch()

    total = 8
    step = 0

    # Step 1: AUR helpers
    step += 1
    print_step(step, total, "AUR Helpers (yay/paru)")
    install_aur_helpers()

    # Step 2: Packages
    step += 1
    print_step(step, total, "Install Required Packages")
    install_packages()

    # Step 3: Caelestia
    step += 1
    print_step(step, total, "Install Caelestia Shell")
    install_caelestia()

    # Step 4: Clone / locate repo
    step += 1
    print_step(step, total, "Locate/Clone Repository")
    repo = clone_repo()

    # Step 5: Backup
    step += 1
    print_step(step, total, "Backup Existing Configs")
    backup_configs()

    # Step 6: Install configs
    step += 1
    print_step(step, total, "Install Configuration Files")
    install_hypr_config(repo)

    # Step 7: Pywal
    step += 1
    print_step(step, total, "Setup Pywal Integration")
    install_pywal(repo)

    # Step 8: Fastfetch
    step += 1
    print_step(step, total, "Install Fastfetch Config")
    install_fastfetch_config(repo)

    print_post_install()


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print(f"\n{YELLOW}Interrupted by user{RESET}")
        sys.exit(130)
