# Troubleshooting Bluetooth Problems

Bluetooth issues can stem from disabled hardware, missing firmware, or misconfigured services. This guide will help you diagnose and fix common Bluetooth problems on Linux.

---

### Step 1: Basic Checks

1.  **Ensure Bluetooth is Turned On:**
    - Check for a physical switch or a keyboard function key (e.g., `Fn + F3`) that toggles Bluetooth and make sure it is enabled.
    - Go to your system's `Settings` > `Bluetooth` and make sure the toggle is switched on.

2.  **Check for Software Blocks:**
    Use the `rfkill` command to see if Bluetooth is blocked.
    ```bash
    rfkill list all
    ```
    Look for a "Bluetooth" entry. If it says "Soft blocked: yes" or "Hard blocked: yes", unblock it:
    ```bash
    # Unblock Bluetooth
    sudo rfkill unblock bluetooth
    ```

### Step 2: Check the Bluetooth Service

The core of Bluetooth on Linux is the `bluetooth.service`. Check if it's running correctly.

1.  **Check the service status:**
    ```bash
    sudo systemctl status bluetooth.service
    ```
    - If it says `Active: active (running)`, the service is fine.
    - If it's `inactive` or `failed`, try starting or restarting it.

2.  **Start and Enable the Service:**
    - To start it for the current session:
      ```bash
      sudo systemctl start bluetooth.service
      ```
    - To enable it permanently so it starts on every boot:
      ```bash
      sudo systemctl enable bluetooth.service
      ```

### Step 3: Identify Your Bluetooth Adapter

You need to know what hardware you're dealing with.

- **For USB Bluetooth adapters (most common, including internal ones):**
  ```bash
  lsusb
  ```
- **For PCI Bluetooth adapters:**
  ```bash
  lspci -knn | grep -iA3 bluetooth
  ```
This will give you the manufacturer and device ID, which is useful for finding the right drivers or firmware.

### Step 4: Install Drivers and Firmware

If the adapter is recognized but doesn't work, it likely needs firmware. This is very common for adapters from Broadcom or Realtek.

1.  **Update Your System:** A system update often includes new or updated firmware files.
    ```bash
    sudo pacman -Syu
    ```

2.  **Search for Firmware Packages:**
    - **General Firmware:** On Garuda, the `linux-firmware` package is essential and should be installed and updated automatically with `sudo pacman -Syu`.
    - **Specific Firmware:** Sometimes, you need a specific package for your hardware, especially for Broadcom devices. Search your package manager or the web for your device model (e.g., "BCM20702A0 firmware arch"). You might find additional firmware in the AUR.

### Step 5: Prepare for Manual Driver Installation

If your adapter is from a manufacturer like Broadcom or Realtek and doesn't work out-of-the-box, you may need to install a driver from the AUR (Arch User Repository). These drivers often need to be built for your specific kernel, which requires having the correct kernel headers installed.

1.  **Install Kernel Headers:**
    Garuda KDE Lite uses the `linux-zen` kernel by default. You must install the headers that match your kernel version.
    ```bash
    # For the default linux-zen kernel
    sudo pacman -S linux-zen-headers

    # You also need the dkms package to manage kernel modules
    sudo pacman -S dkms
    ```
    This ensures that any DKMS driver you install from the AUR can be built correctly.

2.  **Ensure `bluez` Tools are Installed:**
    The core Bluetooth utilities are provided by the `bluez` and `bluez-utils` packages. Garuda should have these installed, but it's good to verify. `bluez-utils` provides the `bluetoothctl` tool for debugging.
    ```bash
    sudo pacman -S bluez bluez-utils
    ```

### Step 6: For Broadcom and Realtek Adapters

These often require special attention.

#### Broadcom:
Some Broadcom devices require specific firmware or driver packages from the AUR.
1.  **Search the AUR:** Use `paru -Ss broadcom` to see available packages.
2.  **Install the appropriate package.** A common one is `broadcom-bt-firmware` or `bcm20702a1-firmware`.
    ```bash
    # Example for many Broadcom chips
    paru -S broadcom-bt-firmware
    ```
    Reboot after installation.

#### Realtek:
Many newer Realtek Bluetooth adapters require drivers from the AUR.
1.  **Search the AUR:** Use `paru` to search for your device's model (e.g., `paru -Ss rtl8821ce`).
2.  **Install the DKMS driver:**
    ```bash
    # Example for RTL8821CE WiFi/BT combo
    paru -S rtl8821ce-dkms-git

    # Example for RTL8761B
    paru -S rtl8761b-fw
    ```
3.  **Reboot:** After the installation is complete, reboot your computer. The new driver or firmware should be loaded automatically.

### Step 7: Reset the Adapter

If the adapter is detected but won't scan or connect, you can try resetting it.

1.  **Find your adapter's index:**
    ```bash
    hciconfig
    ```
    This will show your adapter, usually named `hci0`.

2.  **Take it down and bring it back up:**
    ```bash
    # Replace hci0 if your adapter has a different name
    sudo hciconfig hci0 down
    sudo hciconfig hci0 up
    ```
    After this, try scanning for devices again.

### Step 8: Pairing and Connecting Tools

If the backend seems to work but you have UI issues, you can use command-line tools to debug.

1.  **Install `bluetoothctl`:** This tool is usually part of the `bluez` package, which should already be installed.
2.  **Run the interactive tool:**
    ```bash
    bluetoothctl
    ```
3.  **Use commands to scan and pair:**
    - `scan on` (starts scanning for devices)
    - `devices` (lists available devices)
    - `pair XX:XX:XX:XX:XX:XX` (replace with the MAC address of your device)
    - `connect XX:XX:XX:XX:XX:XX`
    - `trust XX:XX:XX:XX:XX:XX` (to auto-connect in the future)

    If these commands work, the issue is likely with your desktop's Bluetooth GUI. If they fail, the problem is in the driver or service layer.

---

By systematically working through these steps, you can solve the vast majority of Bluetooth issues on a Linux system.
