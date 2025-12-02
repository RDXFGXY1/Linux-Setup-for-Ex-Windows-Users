# Troubleshooting Brightness Control Issues

Brightness control not working is a common issue, especially on laptops. It's often related to graphics drivers or kernel parameters. This guide will help you fix it.

---

### Step 1: Try the Basics First

1.  **Use Your Keyboard's Brightness Keys:** Press the function keys (e.g., `Fn + F5`/`F6`) that control screen brightness. Even if the on-screen display doesn't appear, the brightness level may still change.

2.  **Check Power Settings:** Go to your system's `Settings` > `Power` menu. You should find a brightness slider there. See if it works.

3.  **Update Your System:** A simple system update can fix driver-related issues.
    ```bash
    sudo pacman -Syu
    ```
    Reboot after updating to ensure all changes are applied.

### Step 2: Identify Your Graphics Card

Knowing your graphics hardware is crucial. Open a terminal and run:

```bash
lspci -k | grep -A 2 -i "VGA"
```

This will show your graphics card manufacturer (Intel, NVIDIA, AMD) and the kernel driver currently in use.

### Step 3: Modify Kernel Parameters

The most common fix is to tell the kernel how to handle the brightness controls for your hardware. This is done by editing the GRUB bootloader configuration.

1.  **Edit the GRUB config file:**
    ```bash
    sudo nano /etc/default/grub
    ```

2.  **Find the `GRUB_CMDLINE_LINUX_DEFAULT` line:** It usually looks like this:
    `GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"`

3.  **Add a kernel parameter:** Depending on your hardware, you will add one of the following parameters inside the quotes.

    **Common Parameters to Try:**
    - `acpi_backlight=vendor`
    - `acpi_backlight=video`
    - `acpi_backlight=native`
    - `acpi_backlight=none`

    **Example:**
    Start by trying `acpi_backlight=native`. Change the line to look like this:
    `GRUB_CMDLINE_LINUX_DEFAULT="quiet splash acpi_backlight=native"`

    **If you have an Intel GPU,** you might need a different parameter:
    - `intel_backlight=1` (this is a fictional example, the correct parameter would be `acpi_backlight=video` or `acpi_backlight=vendor` in most cases with Intel graphics). For modern Intel graphics, it should be `i915.enable_dpcd_backlight=1`. However, to avoid providing potentially harmful advice, it's better to stick to the `acpi_backlight` options which are safer.

    **Important:** Only try **one** parameter at a time. If one doesn't work, remove it and try the next one on the list.

4.  **Update GRUB and Reboot:**
    After adding the parameter, save the file (`Ctrl+O`, `Enter`, `Ctrl+X`). Then, update GRUB for the changes to take effect:

    ```bash
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    ```

    Now, reboot your computer and test the brightness keys. If it still doesn't work, repeat Step 3 with the next parameter on the list.

### Step 4: For NVIDIA Users

If you are using proprietary NVIDIA drivers, the brightness control might be handled differently.

1.  **Ensure you have the latest drivers:** On Garuda, you can manage your NVIDIA drivers through the `Garuda Settings Manager` or by using `optimus-manager` if you have a laptop with hybrid graphics. Make sure the correct proprietary NVIDIA driver is installed.

2.  **Add a driver option:** You may need to enable a specific option for the NVIDIA driver.
    - Create a new configuration file:
      ```bash
      sudo nano /etc/X11/xorg.conf.d/10-nvidia-brightness.conf
      ```
    - Add the following content:
      ```
      Section "Device"
          Identifier     "Device0"
          Driver         "nvidia"
          VendorName     "NVIDIA Corporation"
          BoardName      "GeForce GTX 1050 Ti" # Change this to your board name
          Option         "RegistryDwords" "EnableBrightnessControl=1"
      EndSection
      ```
      You can get the exact `BoardName` from `nvidia-smi`.
    - Save the file and reboot.

### Step 5: Manual Control via Terminal (If all else fails)

If the function keys still don't work, you can usually change the brightness manually. This can help confirm if the underlying system control works.

1.  **Find your display's brightness controls:**
    ```bash
    ls /sys/class/backlight/
    ```
    This will output a directory name, typically something like `acpi_video0` or `intel_backlight`.

2.  **Find the maximum brightness:**
    ```bash
    cat /sys/class/backlight/acpi_video0/max_brightness
    ```
    (Replace `acpi_video0` with your directory). This will give you a number, e.g., `1000`.

3.  **Set the brightness:** To set the brightness, you write a value to the `brightness` file. The value must be between 0 and the `max_brightness` value.

    ```bash
    # Example: Set brightness to 50% (500 out of 1000)
    sudo tee /sys/class/backlight/acpi_video0/brightness <<< 500
    ```

    If this command works, you can create a script or desktop shortcut to control it more easily as a temporary workaround.

---

By following these steps, you can systematically diagnose and resolve brightness control issues on your Linux system. The GRUB kernel parameter method (Step 3) is the most common and effective solution.
