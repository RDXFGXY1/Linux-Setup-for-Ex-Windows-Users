# Troubleshooting WiFi Not Working on Ubuntu

This guide provides a step-by-step process to diagnose and fix common WiFi problems on Ubuntu and other Debian-based distributions.

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

## Step 3: Check for Missing Drivers

Ubuntu has a built-in tool to find and install proprietary drivers, which are often needed for WiFi cards, especially from Broadcom or Realtek.

1.  **Open the "Software & Updates" application.**
2.  **Go to the "Additional Drivers" tab.**
3.  **Wait for it to search.** If it finds a proprietary driver for your WiFi card, it will be listed here. Select it and click "Apply Changes." You may need an internet connection via Ethernet for this to work.

Alternatively, you can run this from the command line:
```bash
sudo ubuntu-drivers autoinstall
```
After a reboot, the driver should be active.

## Step 4: Check Kernel Messages for Errors

The kernel log can give you specific error messages related to firmware or driver problems.

```bash
dmesg | grep -iE "wifi|firmware|b43|iwlwifi|rtl"
```
Look for any messages that say "firmware file not found" or other errors related to your WiFi adapter. This often indicates you need to install a specific firmware package.

## Step 5: Install Missing Firmware

If the kernel log indicates missing firmware, you may need to install the `linux-firmware` package. While it's usually installed by default, ensuring it's present and up-to-date can solve issues.

```bash
sudo apt update
sudo apt install linux-firmware
```
Reboot after the installation.

## Step 6: Common Issues with Specific Brands

### Broadcom
Some Broadcom cards require the `bcmwl-kernel-source` package. You can install it via the "Additional Drivers" tool or with:
```bash
sudo apt install bcmwl-kernel-source
```
For older cards, you might need `firmware-b43-installer`.

### Realtek
Realtek drivers can be tricky and sometimes require drivers from outside Ubuntu's main repositories. Search online for your specific Realtek model number (e.g., "RTL8821CE Ubuntu driver") to find community-maintained drivers on GitHub, often installable via DKMS.

---

If you're still having trouble after these steps, searching online with your specific WiFi adapter model and "Ubuntu" will often lead you to a solution for your exact hardware.
