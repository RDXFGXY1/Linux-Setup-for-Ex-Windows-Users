# Troubleshooting Battery and Power Management

Linux generally has good power management, but out-of-the-box settings may not always be optimized for your specific laptop, leading to shorter battery life than you experienced on Windows. This guide will help you check your battery's health and tune your system for better power efficiency.

---

### Step 1: Check Battery Health

First, make sure your battery is still in good condition. All batteries degrade over time, and no amount of software tuning can fix a worn-out battery.

1.  **Use the `upower` Command:**
    `upower` is a command-line tool that can give you detailed information about your power devices.
    ```bash
    # Display full information about your battery
    upower -i /org/freedesktop/UPower/devices/battery_0
    ```
    Look for these key fields:
    - **`energy-full-design`:** The amount of energy the battery was designed to hold when it was new.
    - **`energy-full`:** The amount of energy the battery can hold now, in its current state.
    - **`capacity`:** The health of your battery, calculated as `(energy-full / energy-full-design) * 100`. A capacity of 80% or less indicates significant wear.

2.  **Use KDE System Settings:**
    Garuda KDE Lite users can check battery information and power profiles directly in `System Settings` > `Power Management`. This GUI tool provides details on battery health, charging status, and allows you to configure various power-saving profiles.

If your battery capacity is very low, the best solution is to replace the battery.

---

### Step 2: Install a Power Saving Tool (TLP)

**TLP** is the single most effective tool for improving battery life on Linux. It's a "fire-and-forget" utility that automatically applies a huge range of power-saving tweaks for your hardware without requiring any manual configuration.

1.  **Install TLP:**
    ```bash
    sudo pacman -S tlp tlp-rdw
    ```
    The `tlp-rdw` package is for radio devices (WiFi, Bluetooth), which is important.

2.  **Start and Enable TLP:**
    After installation, you need to start the service and enable it to run on every boot.
    ```bash
    # Start TLP for the current session
    sudo tlp start

    # Enable TLP to run automatically on boot
    sudo systemctl enable tlp
    ```

3.  **That's it!** You don't need to do anything else. TLP will automatically detect when your laptop is on battery vs. AC power and apply the appropriate settings. You should notice a significant improvement in battery life after installing it.

**To verify TLP is running,** use the command `sudo tlp-stat -s`. It should show that the service is enabled and active.

---

### Step 3: Identify Power-Hungry Applications

Sometimes, a single application or process can be the cause of poor battery life by constantly using the CPU.

1.  **Use `top` or `htop`:**
    - Open a terminal and run `top`.
    - The processes at the top of the list are using the most CPU. If an application is consistently using a high percentage of CPU (e.g., > 10%) even when it's idle, it might be misbehaving.
    - `htop` is a more user-friendly version of `top` that you may need to install:
      ```bash
      sudo pacman -S htop
      ```

2.  **Use `powertop`:**
    `powertop` is an advanced tool that analyzes your system and shows you exactly what hardware components and software processes are using the most power.
    - **Install `powertop`:**
      ```bash
      sudo pacman -S powertop
      ```
    - **Run `powertop`:** You need to run it with `sudo` to get all the data.
      ```bash
      sudo powertop
      ```
    - Navigate the tabs with the `Tab` key. The **`Tunables`** tab is particularly useful. It will show you a list of tweaks. For any item that says "Bad," pressing `Enter` will switch it to "Good," applying a power-saving setting. You can run `sudo powertop --auto-tune` to set all of these automatically.
    - The **`Overview`** tab shows a live list of the most power-hungry processes.

---

### Step 4: Other Common Tweaks

- **Screen Brightness:** The display is one of the biggest power drains. Simply lowering your screen brightness will have a large and immediate impact on battery life.

- **Disable Unused Hardware:** If you're not using Bluetooth or WiFi, turn them off. TLP helps with this automatically, but you can also do it manually from your system settings.

- **Choose Your Browser Wisely:** Some web browsers are more power-efficient than others. On Linux, Firefox and browsers based on it often perform better in terms of power consumption than Chrome or Chromium-based browsers, though this can vary.

By checking your battery's health, installing TLP, and keeping an eye out for runaway applications, you can ensure you're getting the most out of your laptop's battery.
