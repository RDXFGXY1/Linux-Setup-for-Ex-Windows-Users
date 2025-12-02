# Troubleshooting WiFi Not Working

WiFi problems can be frustrating, but they are often solvable. This guide will walk you through the most common causes and solutions, from simple checks to more advanced driver installations.

---

### Step 1: Identify Your WiFi Adapter

First, you need to know what WiFi hardware you have. Open a terminal and run this command:

```bash
lspci -knn | grep -iA3 net
```

Look for a "Network controller" entry. This will show you the manufacturer (e.g., Intel, Broadcom, Realtek) and the model of your WiFi card. Keep this information handy.

### Step 2: Check if WiFi is Blocked

Sometimes, WiFi can be accidentally disabled by a physical switch or a software block.

1.  **Check for a physical switch:** Many laptops have a function key (e.g., `Fn + F2`) or a physical switch to turn WiFi on/off. Make sure it's enabled.

2.  **Check for software blocks:** Run the following command in your terminal:

    ```bash
    rfkill list all
    ```

    If you see "Soft blocked: yes" or "Hard blocked: yes" for your wireless device, it's disabled.
    - To unblock it, run:
      ```bash
      sudo rfkill unblock wifi
      ```

### Step 3: Check Kernel Drivers

Most WiFi cards work out-of-the-box if the kernel has the right driver.

- **Check if a driver is loaded:** In the output from `lspci -knn | grep -iA3 net`, look for a line that says `Kernel driver in use:`.
- **If a driver is listed:** Your hardware is recognized. The problem might be with firmware or configuration.
- **If no driver is listed:** The kernel doesn't have a built-in driver for your card. This is common with newer hardware or certain Broadcom/Realtek cards.

### Step 4: Use Garuda's Tools & Prepare for Manual Installation

Before manually installing drivers from the internet, always use Garuda's built-in tools first.

1.  **Use Garuda Hardware Configuration:**
    - Open the `Garuda Welcome` app and go to `Garuda Settings Manager`.
    - In the `Hardware Configuration` section, your system will scan for hardware and may offer to "Auto Install" the correct proprietary drivers. This is the safest way to install drivers for Broadcom and other devices.

2.  **Install Kernel Headers (Essential for DKMS):**
    If you need to install a driver manually (especially one ending in `-dkms`), you **must** have the headers for your currently running kernel. Garuda KDE Lite uses the `linux-zen` kernel by default.
    - First, check your kernel version: `uname -r`
    - Install the matching headers. For the default `linux-zen` kernel, the command is:
      ```bash
      sudo pacman -S linux-zen-headers
      ```
    - You also need the `dkms` package itself:
      ```bash
      sudo pacman -S dkms
      ```
    This prepares your system to build driver modules correctly.

### Step 5: Install Missing Drivers & Firmware

If no driver was loaded, you likely need to install it manually. This is the most common reason for WiFi not working on a new Linux installation.

#### For Intel WiFi Cards:
Intel wireless drivers are usually included in the Linux kernel. If your card is very new, you may need to update your system or manually install newer firmware.

1.  **Update your system:** This often resolves driver issues.
    ```bash
    sudo pacman -Syu
    ```

2.  **Check for firmware:** Search for your card's firmware (e.g., `firmware-iwlwifi`) in your distribution's package manager.

#### For Broadcom WiFi Cards:
Broadcom cards often require proprietary drivers.

1.  **Install the driver:** The most common package is `broadcom-wl`. It's usually available in the official repositories.
    ```bash
    sudo pacman -S broadcom-wl
    ```
    If it's not found in the official repos, you might need to install it from the AUR (Arch User Repository) using an AUR helper like `yay` or `paru` (Garuda often includes `paru` by default):
    ```bash
    paru -S broadcom-wl-dkms # or yay -S broadcom-wl-dkms
    ```
    After installation, reboot your computer.

#### For Realtek WiFi Cards:
Realtek cards can be tricky and may require drivers from the AUR (Arch User Repository), as they may not be in the kernel yet.

1.  **Search the AUR:** Use an AUR helper like `paru` (included with Garuda) to search for your model. For example, if `lspci` shows "RTL8821CE", search for it:
    ```bash
    paru -Ss 8821ce
    ```
    This will likely show a result like `rtl8821ce-dkms-git`.

2.  **Install the DKMS driver:** Install the `-dkms` version of the driver. This will ensure it rebuilds automatically with kernel updates. (Make sure you've installed the kernel headers and `dkms` as shown in Step 4).
    ```bash
    # Example for RTL8821CE
    paru -S rtl8821ce-dkms-git

    # Example for RTL8723DE
    paru -S rtl8723de-dkms-git

    # Example for RTL88x2bu (common for USB adapters)
    paru -S rtl88x2bu-dkms-git
    ```
    Follow the prompts to install.

3.  **Reboot:** After the installation is complete, reboot your computer. The new driver should be loaded automatically.

### Step 6: Disable Power Saving (If Connection is Unstable)

If your WiFi connects but drops frequently, it might be due to aggressive power management.

1.  **Check current setting:**
    ```bash
    iwconfig
    ```
    Look for `Power Management:on`.

2.  **Turn it off temporarily:**
    ```bash
    sudo iwconfig wlan0 power off
    ```
    (Replace `wlan0` with your wireless device name, which you can find from `iwconfig` or `ip a`).

3.  **Make the change permanent:** If this fixes the issue, you can create a configuration file to disable it permanently.
    - Create a new file (e.g., using `kate` or `nano`):
      ```bash
      sudo nano /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf
      ```
    - Add the following content:
      ```ini
      [connection]
      wifi.powersave = 2
      ```
      (`2` means "disable").
    - Save the file and restart NetworkManager:
      ```bash
      sudo systemctl restart NetworkManager
      ```

### Step 7: Use a USB WiFi Adapter or Tethering

If you still can't get the internal WiFi to work and need an immediate connection, you can:
- **Tether your phone:** Connect your smartphone via USB and enable USB tethering. Your computer will get an internet connection through your phone.
- **Use a USB WiFi Adapter:** Purchase a Linux-compatible USB WiFi adapter. Brands like Panda and CanaKit often work out-of-the-box with no driver installation required.

---

By following these steps, you should be able to diagnose and fix most common WiFi issues on a new Linux installation.
