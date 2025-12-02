# Troubleshooting Brightness Control Issues on Fedora

Laptop brightness keys not working is a common issue on Linux. This guide provides several methods to resolve it on Fedora.

---

## Method 1: Modify GRUB Kernel Parameters (Most Common Fix)

Often, the kernel needs to be told which interface to use for backlight control. You can do this by adding a kernel parameter to your GRUB bootloader configuration.

1.  **Edit the GRUB configuration file:**
    ```bash
    sudo nano /etc/default/grub
    ```
2.  **Find the line** `GRUB_CMDLINE_LINUX="... quiet"`
3.  **Add a parameter** to the end of this line (inside the quotes). You should only try **one** of the following options at a time. The most common one that works is `acpi_backlight=vendor`.

    *   `acpi_backlight=vendor`
    *   `acpi_backlight=native`
    *   `acpi_backlight=video`
    *   `acpi_backlight=none`

    For example, the line might look like this:
    `GRUB_CMDLINE_LINUX="... quiet acpi_backlight=vendor"`

4.  **Save the file and update GRUB:** On Fedora, the command to rebuild the grub config is different from other distributions.
    ```bash
    sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
    ```
    *(Note: If you are on a legacy BIOS system, the path would be `/boot/grub2/grub.cfg`, but most modern systems use UEFI.)*

5.  **Reboot your computer.** After rebooting, test your brightness keys. If the first option didn't work, repeat the steps and try the next parameter in the list.

## Method 2: Create an X11 Configuration File (For Intel GPUs)

If the GRUB method doesn't work and you have an Intel GPU, you may need to explicitly tell the X11 server which backlight control interface to use. This is less common on modern Wayland-by-default Fedora, but can still be relevant.

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

You can check if the system even sees your key presses. The `acpid` package should provide the `acpi_listen` tool.

1.  **Install `acpid` if not present and start the service:**
    ```bash
    sudo dnf install acpid
    sudo systemctl enable --now acpid
    ```
2.  **Run `acpi_listen` in a terminal:**
    ```bash
    acpi_listen
    ```
3.  **Press your brightness up and down keys.** If you see output, the keys are being recognized, and the problem lies elsewhere (likely with the `acpi_backlight` kernel parameter). If you see no output, the kernel is not receiving the keypress events.

## Workaround: Software-Based Brightness Control

If you cannot get the hardware keys to work, you can always control brightness using software.

1.  **Find your display name:**
    ```bash
    xrandr | grep " connected"
    ```
    The output will look something like `eDP-1 connected ...`. Your display name is `eDP-1`.

2.  **Set the brightness using `xrandr`:** The brightness value is a multiplier from `0.0` (off) to `1.0` (full brightness). This only works in X11 sessions.
    ```bash
    # Set brightness to 70%
    xrandr --output eDP-1 --brightness 0.7
    ```
    You can use this command in scripts or assign it to custom keyboard shortcuts as a workaround.
