# Troubleshooting Brightness Control Issues on Ubuntu

Laptop brightness keys not working is a common issue on Linux. This guide provides several methods to resolve it on Ubuntu.

---

## Method 1: Modify GRUB Kernel Parameters (Most Common Fix)

Often, the kernel needs to be told which interface to use for backlight control. You can do this by adding a kernel parameter to your GRUB bootloader configuration.

1.  **Edit the GRUB configuration file:**
    ```bash
    sudo nano /etc/default/grub
    ```
2.  **Find the line** `GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"`.
3.  **Add a parameter** to this line. You should only try **one** of the following options at a time. The most common one that works is `acpi_backlight=vendor`.

    *   `acpi_backlight=vendor`
    *   `acpi_backlight=native`
    *   `acpi_backlight=video`
    *   `acpi_backlight=none`

    For example, the line might look like this:
    `GRUB_CMDLINE_LINUX_DEFAULT="quiet splash acpi_backlight=vendor"`

4.  **Save the file and update GRUB:**
    ```bash
    sudo update-grub
    ```
5.  **Reboot your computer.** After rebooting, test your brightness keys. If the first option didn't work, repeat the steps and try the next parameter in the list.

## Method 2: Create an X11 Configuration File (For Intel GPUs)

If the GRUB method doesn't work and you have an Intel GPU, you may need to explicitly tell the X11 server which backlight control interface to use.

1.  **Create a new configuration file:**
    ```bash
    sudo nano /usr/share/X11/xorg.conf.d/20-intel.conf
    ```
2.  **Add the following content** to the file. This tells the Intel driver to use its own backlight interface.
    ```
    Section "Device"
        Identifier  "card0"
        Driver      "intel"
        Option      "Backlight"  "intel_backlight"
        BusID       "PCI:0:2:0"
    EndSection
    ```
3.  **Save the file and reboot.**

## Method 3: Check if Keys are Recognized

You can check if the system even sees your key presses.

1.  **Run `acpi_listen` in a terminal:**
    ```bash
    acpi_listen
    ```
2.  **Press your brightness up and down keys.** If you see output in the terminal (e.g., `video/brightnessup ...`), the keys are being recognized, and the problem lies elsewhere (likely with the `acpi_backlight` kernel parameter). If you see no output, the kernel is not receiving the keypress events at all, which is a more complex issue related to your specific hardware's ACPI implementation.

## Workaround: Software-Based Brightness Control

If you cannot get the hardware keys to work, you can always control brightness using software.

1.  **Find your display name:**
    ```bash
    xrandr | grep " connected"
    ```
    The output will look something like `eDP-1 connected ...`. Your display name is `eDP-1`.

2.  **Set the brightness using `xrandr`:** The brightness value is a multiplier from `0.0` (off) to `1.0` (full brightness).
    ```bash
    # Set brightness to 70%
    xrandr --output eDP-1 --brightness 0.7
    ```
    You can use this command in scripts or assign it to custom keyboard shortcuts as a workaround.
