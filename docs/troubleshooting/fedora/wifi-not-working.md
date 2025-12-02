# Troubleshooting WiFi Not Working on Fedora

This guide provides a step-by-step process to diagnose and fix common WiFi problems on Fedora.

---

## Step 1: Check if WiFi is Blocked

Sometimes, WiFi can be accidentally turned off by a physical switch on your laptop or a software block.

1.  **Check for a physical WiFi switch or key combination** (e.g., `Fn` + `F2`) on your laptop and ensure it's enabled.
2.  **Use the `rfkill` command** to check for software blocks:
    ```bash
    rfkill list
    ```
    If you see "Soft blocked: yes" for your wireless device, you can unblock it with:
    ```bash
    sudo rfkill unblock wifi
    ```

## Step 2: Identify Your WiFi Adapter

You need to know what hardware you have to find the right driver.

1.  **For PCI/internal cards**, use `lspci`:
    ```bash
    lspci -nnk | grep -iA3 net
    ```
2.  **For USB WiFi dongles**, use `lsusb`:
    ```bash
    lsusb
    ```
Look for your device in the output. The part in brackets `[xxxx:xxxx]` is the device ID, which can be very helpful for searching online.

## Step 3: Check for Missing Drivers and Firmware

Fedora's main repositories only contain open-source drivers. Many WiFi cards, especially those from Broadcom and some from Realtek, require proprietary drivers which can be installed from the **RPM Fusion** repository.

1.  **Ensure RPM Fusion is enabled:** If you haven't done so, enable the free and non-free repositories.
    ```bash
    sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    ```
2.  **Install General Firmware:** Ensure the main firmware package and the linux-firmware are installed.
    ```bash
    sudo dnf install linux-firmware
    ```
3.  **Reboot** and check if your WiFi is working. If not, you may need a specific driver.

## Step 4: Install Specific Drivers from RPM Fusion

### For Broadcom Cards:
Install the `broadcom-wl` driver package.
```bash
sudo dnf install broadcom-wl
```
After installation, reboot your system.

### For Realtek and other cards:
RPM Fusion contains a variety of drivers. You can search for drivers related to your hardware.
```bash
dnf search kmod
```
Look for packages that seem to match your hardware.

## Step 5: Check Kernel Messages for Errors

The kernel log can give you specific error messages related to firmware or driver problems.

```bash
dmesg | grep -iE "wifi|firmware|b43|iwlwifi|rtl"
```
Look for any messages that say "firmware file not found" or other errors related to your WiFi adapter. This can help you identify the specific firmware file or driver package you might be missing.

---

If you're still having trouble after these steps, the Fedora community is very helpful. Searching the Fedora forums or Ask Fedora with your specific WiFi adapter model will often lead you to a solution for your exact hardware.
