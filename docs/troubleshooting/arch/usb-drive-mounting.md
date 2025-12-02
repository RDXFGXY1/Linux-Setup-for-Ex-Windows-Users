# Troubleshooting USB Drive Mounting

On modern Linux desktops, USB drives should automatically appear in your file manager when you plug them in. If a drive doesn't appear or you can't write to it, this guide will help you solve the problem.

---

### Step 1: Check if the Drive is Detected by the System

Before the file manager can see a drive, the Linux kernel has to detect it as a block device.

1.  **Open a terminal and plug in your USB drive.**
2.  **Run the `dmesg` command** to see the latest kernel messages:
    ```bash
    dmesg | tail -n 20
    ```
    You should see several new lines appear, describing the USB drive and its manufacturer (e.g., "Kingston DataTraveler"). You'll also see it being assigned a device name like `[sdb]`, `[sdc]`, etc.

3.  **Alternatively, use `lsblk`:**
    ```bash
    lsblk
    ```
    This command lists all block devices. Look for your USB drive in the list. It will be identifiable by its size. The `NAME` column shows its device name (e.g., `sdb`), and if it has partitions, they will be listed below it (e.g., `sdb1`).

If you see your drive in the output of these commands, the hardware is detected correctly. The problem is with mounting. If you don't see it, try a different USB port or a different computer to rule out a hardware failure of the drive itself.

---

### Step 2: When the Drive is Detected But Not Mounted

This usually happens if the filesystem on the drive is corrupted, unsupported, or doesn't have a volume label.

1.  **Install Filesystem Tools:**
    Your system might be missing the tools needed to read the filesystem on the drive (like NTFS for Windows-formatted drives or exFAT for large drives). On Garuda, `ntfs-3g` for NTFS and `exfatprogs` (or `exfat-utils`) for exFAT are usually installed by default, or easily installable via `pacman`.
    ```bash
    # For NTFS support
    sudo pacman -S ntfs-3g

    # For exFAT support
    sudo pacman -S exfatprogs
    ```
    After installing, unplug and replug the drive.

2.  **Manual Mounting:**
    If it still doesn't mount automatically, you can do it manually.
    - **Create a mount point:** This is just an empty folder.
      ```bash
      sudo mkdir /mnt/mydrive
      ```
    - **Find your partition name:** Use `lsblk` to find the partition you want to mount (e.g., `/dev/sdb1`).
    - **Mount the drive:**
      ```bash
      # For NTFS drives
      sudo mount -t ntfs-3g /dev/sdb1 /mnt/mydrive

      # For exFAT drives
      sudo mount -t exfat /dev/sdb1 /mnt/mydrive

      # For FAT32 or EXT4 drives
      sudo mount /dev/sdb1 /mnt/mydrive
      ```
    - You can now access the files in the `/mnt/mydrive` directory.
    - **When you are done, unmount it:**
      ```bash
      sudo umount /mnt/mydrave
      ```

3.  **Repair the Filesystem:**
    If mounting fails with an error, the filesystem on the drive might be corrupted.
    - **For Windows filesystems (NTFS, FAT):** The safest way to repair them is to plug the drive into a Windows machine and run its error-checking tool (`chkdsk`).
    - **For Linux filesystems (ext4):**
      ```bash
      # Unmount the partition first!
      sudo umount /dev/sdb1
      # Check and repair the filesystem
      sudo fsck /dev/sdb1
      ```

---

### Step 3: Can't Write to the Drive (Permission Issues)

This is a very common problem, especially with NTFS-formatted drives.

#### Scenario 1: NTFS Drive Was Not Shut Down Cleanly
If an NTFS drive was unplugged from a Windows machine without using "Safely Remove Hardware," it gets marked as "hibernated." Linux will mount it in read-only mode to prevent data corruption.

- **Solution 1 (Best):** Plug the drive back into a Windows computer, let it mount, and then use the "Safely Remove" icon in the system tray. This will cleanly unmount it.
- **Solution 2 (Force Mount):** If you don't have access to Windows, you can use `ntfs-3g` to remove the dirty flag. **This can be risky.**
  ```bash
  # Unmount first
  sudo umount /dev/sdb1
  # Fix the filesystem
  sudo ntfsfix /dev/sdb1
  ```
  Now try mounting it again.

#### Scenario 2: Linux Filesystem Ownership
If the drive is formatted with a Linux filesystem like `ext4`, the files and folders will have Linux ownership and permissions. If the drive was prepared on another Linux machine, your user on your current machine may not have permission to write to it.

- **Solution: Change Ownership:**
  1.  Mount the drive. For this example, let's say it's mounted at `/media/username/mydrive`.
  2.  Change the ownership of the mounted drive to your user.
      ```bash
      # Find your username
      whoami
      # Change ownership recursively
      sudo chown -R $(whoami):$(whoami) /media/username/mydrive
      ```
  You should now have full read/write access.

---

### How to Format a USB Drive
If you want to erase a drive and start fresh, you can use the **KDE Partition Manager** (recommended for KDE users) or the **Disks** utility (`gnome-disk-utility`).

**Using KDE Partition Manager:**
1.  Open "KDE Partition Manager" from your application menu.
2.  Select your USB drive from the list on the left. **Be very careful to select the correct drive.**
3.  Right-click on the drive and choose "New Partition Table" (e.g., GPT or MBR/DOS).
4.  Then, right-click on the unallocated space and choose "New".
5.  Choose the size, give it a name, and select the filesystem:
    - **NTFS:** Best for sharing with modern Windows systems.
    - **FAT32:** Best for maximum compatibility with all devices (TVs, cars, etc.), but limited to 4GB file sizes.
    - **exFAT:** A modern version of FAT with no file size limits. Good for Windows/Mac/Linux sharing.
    - **Ext4:** The best choice if you will only use the drive with Linux.
6.  Click "Apply" to execute the changes.
    It will now be ready to use.
