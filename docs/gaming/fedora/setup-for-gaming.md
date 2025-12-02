# Setting up Fedora for Gaming

This guide will walk you through optimizing your Fedora Workstation installation for the best gaming experience. Fedora is known for its cutting-edge software and strong open-source ethos, providing a solid base for gaming.

---

## 1. Ensure Latest System Updates

Keeping your system updated is crucial for the latest drivers, kernel improvements, and performance enhancements.

```bash
sudo dnf upgrade --refresh
```

## 2. Enable RPM Fusion Repositories

Fedora prioritizes open-source software, so proprietary drivers and multimedia codecs (often needed for gaming) are not included by default. RPM Fusion provides these necessary packages.

```bash
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf upgrade --refresh
```

## 3. Graphics Driver Installation

### For NVIDIA Users:

1.  **Install NVIDIA Drivers via RPM Fusion:**
    ```bash
    sudo dnf install akmod-nvidia # akmod-nvidia automatically builds kernel modules for your running kernel
    sudo dnf install xorg-x11-drv-nvidia-cuda # Optional: for CUDA support
    ```
2.  **Reboot:** After installation, reboot your system for the drivers to take effect.
3.  **Verify Installation:** Open a terminal and run `nvidia-smi` to confirm drivers are working.

### For AMD/Intel Users:

Your open-source drivers (`amdgpu` or `i915`) are included in the kernel and are generally highly optimized. Ensure your system is fully updated for the latest Mesa drivers, which are provided by default in Fedora.

```bash
sudo dnf update mesa-dri-drivers
```

## 4. Install Gaming Software

Fedora has excellent support for gaming platforms.

### Steam:

Steam is the primary platform for most PC games. It's recommended to install Steam from the Flatpak.

1.  **Install Flatpak if not already installed:**
    ```bash
    sudo dnf install flatpak
    ```
2.  **Add Flathub repository:**
    ```bash
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    ```
3.  **Install Steam:**
    ```bash
    flatpak install flathub com.valvesoftware.Steam
    ```
After installing, launch Steam, log in, and enable Steam Play (Proton) for compatibility with Windows-only games:
1.  Go to `Steam` > `Settings` > `Steam Play`.
2.  Check "Enable Steam Play for supported titles" and "Enable Steam Play for all other titles."
3.  Select the latest `Proton Experimental` or a specific Proton-GE version.

### Lutris:

Lutris is an open-source game manager that allows you to install and play games from various sources, including GOG, Epic Games Store, and other launchers.

```bash
sudo dnf install lutris
```

### Wine / Proton-GE:

While Steam manages Proton, Lutris often uses different Wine versions (including Proton-GE or Wine-Staging).
-   **Proton-GE:** You can manage Proton-GE versions through tools like `ProtonUp-Qt` (available as a Flatpak).
    ```bash
    flatpak install flathub net.davidotek.GtkSourceView
    ```
-   **Wine:**
    ```bash
    sudo dnf install wine
    ```

## 5. Performance Optimizations

### GameMode:

GameMode is a daemon that optimizes your Linux system for gaming when certain games are running.

```bash
sudo dnf install gamemode
```
To activate it for Steam games, add `gamemoderun %command%` to your game's launch options in Steam.

### Power Profiles:

Fedora Workstation typically includes power profiles. You can manage these through your desktop environment settings (e.g., GNOME Power panel) to select a "Performance" profile when gaming.

---

By following these steps, your Fedora system should be well-prepared for a fantastic gaming experience.
