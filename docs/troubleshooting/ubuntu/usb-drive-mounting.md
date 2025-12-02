# Troubleshooting USB Drive Mounting on Ubuntu

This guide covers what to do when you plug in a USB flash drive or external hard drive and it doesn't automatically appear on your desktop or in your file manager.

---

## The Normal Process

Normally, when you plug in a USB drive, Ubuntu's desktop environment automatically "mounts" it and creates an icon in the Dock or a shortcut in the Files app sidebar. You simply click it to access your files. The issues below are for when this process fails.

## Step 1: Check if the Device is Detected at the Hardware Level

First, see if the Linux kernel even recognizes that a device has been plugged in.

1.  **Use `lsblk`:** This command lists all block devices (like hard drives and USB drives) known to the system.
    ```bash
    lsblk
    ```
    Look for a device that matches the size of your USB drive (e.g., `sdb`, `sdc`). If it has partitions, you will see them listed like `sdb1`. If you see your device here, the hardware is detected, and the problem is likely with the filesystem or mounting rules.

2.  **Check `dmesg`:** This command shows kernel log messages.
    ```bash
    dmesg | tail -n 20
    ```
    Plug in your USB drive and run the command again. You should see new messages related to "USB" and "scsi" or "sd", which indicate the device is being detected.

**If your device does not appear in `lsblk` or `dmesg`:**
*   Try a different USB port on your computer.
*   Try a different USB cable (if it's an external drive).
*   Test the drive on another computer to rule out a hardware failure of the drive itself.

## Step 2: Check for Filesystem Issues

If the hardware is detected but not mounting, it's often a filesystem problem.

1.  **Install Filesystem Tools:** Ubuntu supports many filesystems out of the box, but sometimes the necessary tools for checking or repairing them aren't installed. Common ones for USB drives are NTFS (Windows) and exFAT.
    ```bash
    # For NTFS (Windows drives)
    sudo apt install ntfs-3g

    # For exFAT (common on flash drives and SD cards)
    sudo apt install exfat-fuse exfat-utils
    ```

2.  **Repair the Filesystem:** The drive may have been unplugged unsafely, leading to filesystem corruption.
    *   **First, identify the partition name** using `lsblk` (e.g., `/dev/sdb1`).
    *   **Make sure it is unmounted:** `sudo umount /dev/sdb1`.
    *   **Run a filesystem check.** The command depends on the filesystem type.
        ```bash
        # For FAT32, exFAT, or NTFS
        sudo fsck /dev/sdb1

        # For ext2/3/4 (Linux filesystems)
        sudo e2fsck /dev/sdb1
        ```
    Answer `yes` to any prompts to repair the filesystem.

## Step 3: Manual Mounting

If the filesystem is okay but it's still not showing up, you can try to mount it manually.

1.  **Identify the partition name** (e.g., `/dev/sdb1`) using `lsblk`.
2.  **Create a mount point:** This is just an empty directory.
    ```bash
    sudo mkdir /mnt/myusb
    ```
3.  **Mount the device:**
    ```bash
    sudo mount /dev/sdb1 /mnt/myusb
    ```
4.  **Check the contents:** You should now be able to access the files in the `/mnt/myusb` directory.
    ```bash
    ls /mnt/myusb
    ```
5.  **When you are done, unmount it:**
    ```bash
    sudo umount /mnt/myusb
    ```

If the manual mount command gives an error, the error message itself is the best clue to the problem (e.g., "wrong fs type, bad option, bad superblock").
