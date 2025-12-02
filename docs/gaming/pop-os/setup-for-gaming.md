# Setting up Pop!_OS for Gaming

This guide will walk you through optimizing your Pop!_OS installation for the best gaming experience.

---

## 1. Ensure Latest System Updates

Keeping your system updated is crucial for the latest drivers and performance improvements.

```bash
sudo apt update && sudo apt upgrade
```

## 2. Graphics Driver Installation

### For NVIDIA Users:

If you installed Pop!_OS using the NVIDIA ISO, your drivers should already be installed. If not, or if you need to update them:

1.  **Check for Additional Drivers:**
    Go to `Settings` > `About` > `Graphics`. Ensure your NVIDIA GPU is listed and the proprietary driver is in use.
2.  **Install via Pop!_OS:**
    ```bash
    sudo apt install system76-driver-nvidia
    # Or, to check for recommended drivers:
    # ubuntu-drivers devices
    # sudo apt install nvidia-driver-XXX # Replace XXX with recommended version
    ```
3.  **Pop!_OS Power Settings:** Utilize the built-in "Hybrid Graphics" or "NVIDIA Graphics" options in the top-bar system tray menu to ensure your dedicated GPU is active when gaming.

### For AMD/Intel Users:

Your open-source drivers (`amdgpu` or `i915`) are included in the kernel and are generally highly optimized. Ensure your system is fully updated for the latest Mesa drivers.

```bash
sudo apt update && sudo apt upgrade
```

## 3. Install Gaming Software

Pop!_OS has excellent support for gaming platforms.

### Steam:

Steam is the primary platform for most PC games.

```bash
sudo apt install steam
```
After installing, log in and enable Steam Play (Proton) for compatibility with Windows-only games:
1.  Go to `Steam` > `Settings` > `Steam Play`.
2.  Check "Enable Steam Play for supported titles" and "Enable Steam Play for all other titles."
3.  Select the latest `Proton Experimental` or a specific Proton-GE version.

### Lutris:

Lutris is an open-source game manager that allows you to install and play games from various sources, including GOG, Epic Games Store, and other launchers.

```bash
sudo add-apt-repository ppa:lutris-team/lutris
sudo apt update
sudo apt install lutris
```

### Wine / Proton-GE:

While Steam manages Proton, Lutris often uses different Wine versions (including Proton-GE or Wine-Staging).
-   **Proton-GE:** You can manage Proton-GE versions through tools like `ProtonUp-Qt` (available as a Flatpak or AppImage).
-   **Wine-Staging:**
    ```bash
    sudo apt install wine-staging winetricks
    ```

## 4. Performance Optimizations

Pop!_OS includes some built-in optimizations.

-   **GameMode:** GameMode is a daemon that optimizes your Linux system for gaming when certain games are running.
    ```bash
    sudo apt install gamemode
    ```
    To activate it for Steam games, add `gamemoderun %command%` to your game's launch options in Steam.
-   **Pop!_OS Power Profiles:** In your system tray, you can switch between "Balanced," "High Performance," and "Battery Life" profiles. Choose "High Performance" for gaming.

---

By following these steps, your Pop!_OS system should be fully optimized for a great gaming experience.
