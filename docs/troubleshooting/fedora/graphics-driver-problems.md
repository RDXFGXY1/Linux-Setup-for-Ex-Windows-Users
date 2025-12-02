# Troubleshooting Graphics Driver Problems on Fedora

Graphics driver issues can cause everything from a black screen on boot to poor performance in games and animations. This guide covers how to identify and fix common problems on Fedora.

---

## Step 1: Identify Your Graphics Card

First, you need to know what GPU you have. Open a terminal and run:
```bash
lspci -nnk | grep -iA3 "VGA\|3D"
```
This will show you your graphics card model and the kernel driver currently in use.

---

## Troubleshooting NVIDIA Drivers

On Fedora, the standard and recommended way to install proprietary NVIDIA drivers is through the RPM Fusion repository.

### 1. Enable RPM Fusion
If you haven't already, enable the free and non-free repositories.
```bash
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
```

### 2. Install the NVIDIA Drivers
RPM Fusion makes it easy to install the correct driver for your card.
```bash
sudo dnf install akmod-nvidia # For most desktops
sudo dnf install xorg-x11-drv-nvidia-cuda # Optional: for CUDA support
```
The `akmod-nvidia` package automatically builds a kernel module for your current kernel, and for new kernels you install. After installing, **you must wait a few minutes for the kernel module to build**, then reboot.

### 3. Purging and Reinstalling
If your graphics are broken, you can remove all NVIDIA-related packages and start over.
```bash
sudo dnf remove "*nvidia*"
# Then, reinstall following the steps above
sudo dnf install akmod-nvidia
```
After a reinstall, remember to wait and then reboot.

---

## Troubleshooting AMD and Intel Drivers

Fedora is an excellent choice for AMD and Intel graphics users because it ships with very up-to-date versions of the Linux Kernel and the Mesa graphics stack.

### AMD and Intel Drivers
For both AMD (`amdgpu`) and Intel, the necessary drivers are open-source and built directly into the system. You do not need to install anything manually.

**Problem:** Poor performance, screen flickering, or a new GPU is not working correctly.
**Solution:** The most common solution is simply to ensure your system is fully up-to-date.
```bash
sudo dnf upgrade --refresh
```
A full system upgrade will bring in the latest kernel and Mesa drivers that Fedora has tested and packaged, which often resolves graphics issues, especially for newer hardware.

---

## Black Screen on Boot (`nomodeset`)

If you can't boot into Fedora after a driver install or update, you may need the `nomodeset` kernel parameter.

1.  **Start your computer** and hold down the `Shift` key to get the GRUB boot menu. (On UEFI systems, you may need to press `Esc` repeatedly).
2.  **Select the default Fedora entry** and press the `E` key to edit it.
3.  **Find the line that starts with `linux`**.
4.  **Add `nomodeset` to the end of that line**.
5.  **Press `Ctrl+X` or `F10` to boot**.

This will get you into the system with basic graphics, allowing you to then use the terminal to follow the steps above to fix, purge, or change your graphics driver.
