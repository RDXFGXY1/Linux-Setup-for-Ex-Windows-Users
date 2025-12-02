# Troubleshooting Graphics Driver Problems on Ubuntu

Graphics driver issues can cause everything from a black screen on boot to poor performance in games and animations. This guide covers how to identify and fix common problems on Ubuntu.

---

## Step 1: Identify Your Graphics Card

First, you need to know what GPU you have. Open a terminal and run:
```bash
lspci -nnk | grep -iA3 "VGA\|3D"
```
This will show you your graphics card model and the kernel driver currently in use.

---

## Troubleshooting NVIDIA Drivers

NVIDIA issues are common due to their proprietary nature.

### 1. Use the "Additional Drivers" Tool
This is the safest method for installing and managing NVIDIA drivers.
1.  Open the "Software & Updates" application and go to the "Additional Drivers" tab.
2.  It will list the available drivers for your card. Select the latest stable, "proprietary, tested" driver.
3.  Click "Apply Changes" and reboot when prompted.

### 2. Use the Command Line
You can also manage drivers via the terminal.
```bash
# See recommended drivers
ubuntu-drivers devices

# Install the recommended driver automatically
sudo ubuntu-drivers autoinstall

# Or install a specific version
# sudo apt install nvidia-driver-535
```

### 3. If You Need Newer Drivers (For Gamers)
For the latest drivers, you can add the official PPA for graphics drivers.
```bash
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt update
```
After adding the PPA, the "Additional Drivers" tool will show newer versions.

### 4. Purging and Reinstalling
If your graphics are broken, you may need to remove all NVIDIA drivers and start fresh.
```bash
sudo apt purge "*nvidia*"
sudo ubuntu-drivers autoinstall
```

---

## Troubleshooting AMD and Intel Drivers

### AMD Drivers
Modern AMD graphics drivers (`amdgpu`) are open-source and built directly into the Linux kernel and Mesa graphics stack. You generally do not need to install anything manually.

**Problem:** Poor gaming performance or issues with a very new GPU.
**Solution:** You need a newer kernel or Mesa version than Ubuntu provides by default.
-   **Update your system:** `sudo apt update && sudo apt upgrade`
-   **Use a PPA for newer Mesa (for gamers):** For newer, but still stable Mesa drivers, you can use the Kisak PPA.
    ```bash
    sudo add-apt-repository ppa:kisak/kisak-mesa
    sudo apt update
    sudo apt upgrade
    ```

### Intel Drivers
Intel graphics drivers are also open-source and fully integrated into the kernel and Mesa. You should never need to install an Intel driver manually. Issues are almost always resolved by a system update or a kernel upgrade.

---

## Black Screen on Boot (`nomodeset`)

If you can't even boot into Ubuntu after a driver install or update, you may need the `nomodeset` kernel parameter.

1.  **Start your computer** and hold down the `Shift` key to get the GRUB boot menu.
2.  **Select the default Ubuntu entry** and press the `E` key to edit it.
3.  **Find the line that starts with `linux`**. It will end with `quiet splash`.
4.  **Add `nomodeset` before `quiet splash`**.
5.  **Press `Ctrl+X` or `F10` to boot**.

This will get you into the system with basic graphics, allowing you to then follow the steps above to fix, purge, or change your graphics driver. To make this change permanent (not recommended, only as a last resort), you would edit `/etc/default/grub` and run `sudo update-grub`.
