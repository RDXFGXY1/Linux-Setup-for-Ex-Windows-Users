# Setting up Garuda Linux for Gaming

This guide will walk you through optimizing your Garuda KDE Lite installation for the best gaming experience.

---

## 1. Ensure Latest System Updates

Garuda is a rolling release distribution, so keeping your system updated is crucial for the latest drivers and performance improvements.

```bash
sudo pacman -Syu
```

## 2. Graphics Driver Installation

Garuda makes graphics driver management easy.

### For NVIDIA Users:

1.  **Garuda Settings Manager:** Open the `Garuda Welcome` app and navigate to `Garuda Settings Manager`. In the `Hardware Configuration` section, use the "Auto Install Proprietary Driver" option to install the recommended NVIDIA drivers.
2.  **`optimus-manager` (Hybrid Graphics Laptops):** If you have a laptop with both Intel/AMD integrated graphics and a dedicated NVIDIA card, `optimus-manager` is pre-installed on Garuda. Configure it to switch between GPUs or use the NVIDIA card as primary.
    ```bash
    # Check current status
    optimus-manager --status
    # Switch to NVIDIA (requires logout/reboot)
    optimus-manager --switch nvidia
    ```
3.  **Screen Tearing Fix:** Refer to the [Graphics Driver Problems troubleshooting guide](../../troubleshooting/arch/graphics-driver-problems.md) for detailed steps on fixing screen tearing with NVIDIA.

### For AMD/Intel Users:

Your open-source drivers (`amdgpu` or `i915`) are included in the kernel and are generally highly optimized. Ensure your system is fully updated for the latest Mesa drivers.

```bash
sudo pacman -Syu
```

## 3. Install Gaming Software

Garuda typically comes with many gaming tools pre-installed or easily installable.

### Steam:

Steam is the primary platform for most PC games.

```bash
sudo pacman -S steam
```
After installing, log in and enable Steam Play (Proton) for compatibility with Windows-only games:
1.  Go to `Steam` > `Settings` > `Steam Play`.
2.  Check "Enable Steam Play for supported titles" and "Enable Steam Play for all other titles."
3.  Select the latest `Proton Experimental` or a specific Proton-GE version.

### Lutris:

Lutris is an open-source game manager that allows you to install and play games from various sources, including GOG, Epic Games Store, and other launchers.

```bash
sudo pacman -S lutris
```

### Wine / Proton-GE:

While Steam manages Proton, Lutris often uses different Wine versions (including Proton-GE or Wine-Staging).
-   **Proton-GE:** You can manage Proton-GE versions through tools like `ProtonUp-Qt` (often pre-installed or available in the repos/AUR).
-   **Wine-Staging:**
    ```bash
    sudo pacman -S wine-staging winetricks
    ```

## 4. Performance Optimizations

Garuda already includes many performance tweaks, but you can check a few things:

-   **Zen Kernel:** Garuda uses the `linux-zen` kernel by default, which is optimized for responsiveness. Ensure you are running it.
    ```bash
    uname -r
    ```
-   **CPU Governor:** Ensure your CPU is set to a performance governor when gaming. TLP (if installed) manages this automatically, or you can manually set it.
    ```bash
    # Check current governor (should be 'performance' when gaming)
    cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
    ```
-   **GameMode:** GameMode is a daemon that optimizes your Linux system for gaming when certain games are running.
    ```bash
    sudo pacman -S gamemode
    ```
    To activate it for Steam games, add `gamemoderun %command%` to your game's launch options in Steam.

## 5. Filesystem Optimizations (BTRFS)

Garuda uses BTRFS by default, which can benefit from specific mounting options. While Garuda handles most of this, ensure `compress=zstd` is enabled for your root partition for potential performance gains and reduced disk usage.

```bash
# Check your fstab for mount options (look for the root / entry)
cat /etc/fstab
```
You should see `compress=zstd` among the options.

---

By following these steps, your Garuda KDE Lite system should be fully optimized for a great gaming experience.
