# Troubleshooting Bluetooth Problems on Fedora

This guide covers common steps to fix Bluetooth issues on Fedora, such as devices not connecting, not being detected, or adapters not being found.

---

## Step 1: Basic Checks

1.  **Ensure Bluetooth is Enabled:** Check the Bluetooth icon in the system tray or go to `Settings` > `Bluetooth` and make sure it is toggled on.
2.  **Check for Hardware Blocks:** Use `rfkill` to see if there's a soft block on your Bluetooth adapter.
    ```bash
    rfkill list
    ```
    If you see "Soft blocked: yes" for a Bluetooth device, unblock it:
    ```bash
    sudo rfkill unblock bluetooth
    ```
3.  **Check Service Status:** Ensure the Bluetooth service is active and running.
    ```bash
    sudo systemctl status bluetooth
    ```
    If it's not active, start and enable it:
    ```bash
    sudo systemctl start bluetooth
    sudo systemctl enable bluetooth
    ```

## Step 2: Install Necessary Packages

Ensure you have the core Bluetooth utilities installed. `blueman` is a more advanced Bluetooth manager that can sometimes solve issues the default desktop manager cannot.

```bash
sudo dnf install bluez bluez-tools blueman
```
After installing, try searching for devices using the "Bluetooth Manager" (`blueman-manager`) application.

## Step 3: Use `bluetoothctl` for Diagnostics

`bluetoothctl` is a powerful command-line tool for managing Bluetooth devices.

1.  **Launch the tool:**
    ```bash
    bluetoothctl
    ```
2.  **Power on the controller and scan for devices:**
    ```
    power on
    scan on
    ```
    This will show you if the adapter is capable of discovering new devices. Note the MAC address of the device you want to connect to.
3.  **Pair and connect:**
    ```
    pair <DEVICE_MAC_ADDRESS>
    connect <DEVICE_MAC_ADDRESS>
    ```
    If pairing fails, the error messages here can be more descriptive than the GUI.

## Step 4: Check for Driver or Firmware Issues

Sometimes the issue is a missing firmware file for your specific Bluetooth adapter.

1.  **Check kernel messages:**
    ```bash
    dmesg | grep -i blue
    ```
    Look for errors related to firmware loading.
2.  **Check your hardware:** Identify your Bluetooth adapter to search for specific driver needs.
    ```bash
    lsusb | grep -i blue
    lspci | grep -i blue
    ```
3.  **Install latest firmware:** Ensure you have the `linux-firmware` package.
    ```bash
    sudo dnf install linux-firmware
    ```
    A reboot might be required.

## Step 5: Edit the Bluetooth Configuration

In some cases, especially with audio devices, you may need to enable experimental features.

1.  **Edit the main configuration file:**
    ```bash
    sudo nano /etc/bluetooth/main.conf
    ```
2.  **Uncomment and set `ControllerMode`:** Find the line `#ControllerMode = dual` and change it to:
    ```
    ControllerMode = bredr
    ```
    This can help with some audio device connection issues.
3.  **Restart the Bluetooth service:**
    ```bash
    sudo systemctl restart bluetooth
    ```

If problems persist, search online using your device's model name (e.g., "Sony WH-1000XM4 Fedora connection issues") to find solutions tailored to your hardware.
