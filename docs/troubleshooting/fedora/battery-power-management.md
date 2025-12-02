# Troubleshooting Battery Power Management on Fedora

This guide provides tools and techniques to improve battery life and troubleshoot power management issues on Fedora laptops.

---

## Step 1: Check Battery Health and Status

First, verify that the system is correctly reading your battery and check its overall health.

1.  **Use the `upower` command:** This utility provides detailed information about all power sources.
    ```bash
    # The command to show information about your primary battery
    upower -i /org/freedesktop/UPower/devices/battery_BAT0
    ```
    *(Note: If `BAT0` doesn't work, you can find your battery's path with `upower -e`)*

2.  **Analyze the output:**
    *   `state`: Shows if the battery is charging, discharging, or full.
    *   `energy-full`: The amount of energy the battery holds when full.
    *   `energy-full-design`: The amount of energy the battery was designed to hold.
    *   `capacity`: The health of your battery, calculated as `(energy-full / energy-full-design) * 100`. A low capacity (e.g., < 80%) indicates a worn-out battery.

## Step 2: Use Built-in Power Profiles

Modern Fedora (with the GNOME desktop) includes simple power profiles that are a good first step.

1.  **Click the system menu** in the top-right corner.
2.  **Select the power profile** that suits your needs:
    *   **Power Saver:** Reduces performance to maximize battery life.
    *   **Balanced:** The default mode, offering a mix of performance and battery conservation.
    *   **Performance:** (Only available on some hardware) Maximizes performance at the cost of battery life.

For simple needs, switching to "Power Saver" when on battery is often enough.

## Step 3: Install TLP for Advanced Power Management

**TLP** is the most highly recommended tool for optimizing battery life on Linux. It's a "fire-and-forget" service that applies a wide range of power-saving tweaks automatically in the background.

1.  **Install TLP:**
    ```bash
    sudo dnf install tlp tlp-rdw
    ```
    The `tlp-rdw` package is for radio device wizardry, helping to turn off WiFi, Bluetooth, and WWAN when not needed.

2.  **Start the service:** TLP starts automatically on boot after installation. To start it immediately without rebooting, run:
    ```bash
    sudo tlp start
    ```

That's it! TLP will now apply its default, highly-optimized settings whenever you are on battery power. For most users, no further configuration is needed. Advanced users can edit the configuration file at `/etc/tlp.conf`.

## Step 4: Monitor Power Usage with `powertop`

`powertop` is a tool that analyzes your system to see what hardware components and applications are using the most power.

1.  **Install `powertop`:**
    ```bash
    sudo dnf install powertop
    ```
2.  **Run an initial calibration:** This is important for getting accurate readings. Run it on battery power and let it complete all its cycles. It will take several minutes.
    ```bash
    sudo powertop --calibrate
    ```
3.  **Run `powertop` in interactive mode:**
    ```bash
    sudo powertop
    ```
    *   Use the `Tab` key to navigate between tabs.
    *   The **"Overview"** tab shows a list of the top power consumers.
    *   The **"Tunables"** tab shows suggestions for power-saving settings. You can press `Enter` on a "Bad" tunable to change it to "Good."

4.  **Apply all tunables automatically:** You can have `powertop` set all tunables to "Good" on boot.
    ```bash
    sudo powertop --auto-tune
    ```
    You can create a systemd service to run this automatically every time you boot.

By combining the built-in power profiles with a tool like TLP, you can significantly extend your laptop's battery life on Fedora.
