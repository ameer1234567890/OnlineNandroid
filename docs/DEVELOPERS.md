### Update Functions &amp; Patch File URLs:
* Update Check URL: `https://raw.githubusercontent.com/ameer1234567890/OnlineNandroid/master/version`
* Download URL: `https://raw.githubusercontent.com/ameer1234567890/OnlineNandroid/master/onandroid`
* Changelog URL: `https://raw.githubusercontent.com/ameer1234567890/OnlineNandroid/master/changelog`
* Partition Layout File List URL: `https://raw.githubusercontent.com/ameer1234567890/OnlineNandroid/master/part_layouts/codenames`
* MTD Devices List URL: `https://raw.githubusercontent.com/ameer1234567890/OnlineNandroid/master/part_layouts/mtd_devices`
* Patch files in raw format: `https://raw.githubusercontent.com/ameer1234567890/OnlineNandroid/master/part_layouts/raw/partlayout4nandriod.codename`, where codename is the codename for the specific device.
* Patch files in flashable zip format: `https://raw.githubusercontent.com/ameer1234567890/OnlineNandroid/master/part_layouts/zip/part_detect_tool.codename.zip`, where codename is the codename for the specific device.

<br />
<br />

### Command Line Flags:
* v6 introduces a new command line flag mechanism with totally revamped code. Each command line flag also has a long version which is more descriptive and preferred by some. This screen can be accessed by typing `onandroid -h` or `onandroid --help`.
```none
-h, --help                    display this help message and exit
-h2, --help2                  display more help messages and exit
-ah, --advanced-help          display help for advanced backup mode
-v, --version                 display version number and exit
-p, --phone                   generate backup name with phone timezone
-u, --utc                     generate backup name with UTC time (default)
-i, --incremental             CWM6 style incremental backup mode
-a, --advanced PARTITIONS     advanced / selective backup mode
-l, --split                   split backup mode (CWM 6+ only)
-o, --old                     good old backup mode (default)
-gc, --garbage-collect        run garbage collect mode
-w, --twrp                    TWRP backup mode
-me, --md5-enable             enable md5 generation (for TWRP only)
-md, --md5-disable            disable md5 generation (for TWRP only)
-ce, --compression-enable     enable compression (for TWRP only)
-cd, --compression-disable    disable compression (for TWRP only)
-cg, --compression-gzip       enable compression and use gzip (TWRP only)
-c, --custom NAME             specify a custom backup name
-s, --storage MEDIA           specify an alternate storage media to backup
-e, --sd-ext-path PATH        specify path to sd-ext partition
-r, --replace                 replace backup with same name
```
* In addition to these, v8 introduces a new command line flag listing, which contains advanced and less frequently used command line flags. This screen can be accessed by typing `onandroid -h2` or `onandroid --help2`.
```none
-y, --yaffs-override            create tar balls instead of yaffs images for yaffs2 partitions
-t, --sbin-last                 use /sbin as last option for busybox
-ne, --notification-enable      enable vibrate and LED notification (default)
-nd, --notification-disable     disable vibrate and LED notification
-pp, --progress-percent         show percentage progress indicator (default)
-pd, --progress-dot             show dot progress indicator
-d, --device-id                 return device id used by TWRP
-ds, --set-device-id            set device id used by TWRP
-xd, --exclude-dalvik           exclude dalvik-cache from backup
-xg, --exclude-gmusic           exclude Google Music files from backup
```

<br />
<br />

### Specifying Custom Backup Name:
* While specifying custom backup names, characters not allowed in folder/directory names should not be used. The script does not do any filtering for such characters and thus any error spitted would be from the shell itself. If you are developing an android app or any other GUI for the script, you can optionally include filtering for disallowed characters. Spaces are not allowed as well.

<br />
<br />

### Specifying Alternate Backup Media:
* Since some people are having issues where the script detects internal sd card for backing up, but people want the external sd card to be selected (there is instances of vice versa too), there is a command line flag to set the sdcard / base folder. You could also use this for cryptonite volumes or any other folders for that matter. Here is an example:

* For sd card selection: (This would force Online Nandroid to backup to /sdcard/external_sd/clockworkmod/backup/...)
```shell
onandroid -s /sdcard/external_sd
OR
onandroid --storage /sdcard/external_sd
```

* For your cryptonite volume: (This would force Online Nandroid to backup to /sdcard/mnt/cryptonite/clockworkmod/backup/...)
```shell
onandroid -s /sdcard/mnt/cryptonite
OR
onandroid --storage /sdcard/mnt/cryptonite
```

<br />
<br />

### Specifying sd-ext Path / Mountpoint:
* Since it is almost impossible for the script to detect all the various flavors of sd-ext usages (such as app2sd, link2sd, data2sd, etc...), I have added a command line flag to manually specify sd-ext path / mountpoint. Here is an example:
```shell
onandroid -e /data/sdext2
OR
onandroid --sd-ext-path /data/sdext2
```

<br />
<br />

### Advanced / Selective Backup Mode:
* Using this backup mode you can backup only specific partitions.
```shell
Usage: onandroid -a <partitions>

<partitions>
  m: mmcblk0_start (for Acer devices)
  k: uboot (for MTK based devices)
  b: boot
  r: recovery
  w: wimax (for Samsung devices)
  l: appslog (for HTC and Sony (Ericsson) devices)
  g: kernel
  q: modem
  v: Trim Area / TA (for Sony devices)
  n: nvram (for MTK devices)
  s: system
  d: data
  c: cache
  t: datadata (for some Samsung devices)
  j: data/data (for HTC devices)
  e: efs (for Samsung devices)
  o: preload (for Samsung devices)
  u: .cust_backup (for Huawei devices)
  f: flexrom (for Acer devices)
  h: custpack (for Alcatel devices)
  i: mobile_info (for Alcatel devices)
  a: android_secure
  x: sd-ext
```
* Note: This help screen can be accessed by entering:
```shell
onandroid -ah
OR
onandroid --advanced-help
```
* Example (backup boot, system and data partitions only):
```shell
onandroid -a bsd
OR
onandroid --advanced bsd
```

<br />
<br />

### Specifying Progress Indicator Type:
* There are two progress indicator types available. Using dots (as in versions prior to v6), and using percentages. By default, the second indicator type is used. If, for some reason (for instance some apps may not be able to properly display the percentage progress indicator), you want to choose a specific indicator type, it can be set via the below flags.
* Setting dot indicator:
```shell
onandroid -pd
OR
onandroid --progress-dot
```

* Setting percentage indicator:
```shell
onandroid -pp
OR
onandroid --progress-percent
```

<br />
<br />

### Disabling Notifications:
* If the app / tool you are developing has a method of notifying the user when backup is done, and / or if you do not require the notifications done by Online Nandroid script itself (currently led and vibrate notifications), you can disable notifications. Here is an example:
```shell
onandroid -nd
OR
onandroid --notification-disable
```

<br />
<br />

### Backup Format Indicators:
* Online Nandroid adheres to backup format indicator set in **.default_backup_format** file, by ClockWorkMod (CWM) recovery. This file could have 2 different strings, **dup** or **tar**, where **dup** means incremental backup mode and **tar** means split backup mode. The file is normally in the below location, as set by CWM. The sd card mount point may vary.
```shell
/mnt/sdcard/clockworkmod/.default_backup_format
```

* In addition, Online Nandroid introduces its own file (.advanced_backup_partitions) for specifying backup partitions for advanced / selective backup. This file should be populated with the partition letters in the same way as doing an advanced / selective backup. The file should be in the below location. The sd card mount point may vary.
```shell
/mnt/sdcard/clockworkmod/.advanced_backup_partitions
```

<br />
<br />

### Workaround for busybox in /sbin:
* Some kernels include busybox in the ramdisk, in ``/sbin/busybox``. This is mostly done to accommodate busybox calls in recovery mode. In the default setup of Terminal Emulator, ``/sbin`` is given preference over ``/system/bin`` and ``/system/xbin``. Thus, Online Nandroid uses ``/sbin/busybox`` over any other busybox installations. The issue arises when the busybox binary in ``/sbin/busybox`` is out of date. This sometimes causes undesired affects for Online Nandroid. To overcome this situation, you can use the below command line  flag.
```shell
onandroid -t
OR
onandroid --sbin-last
```

<br />
<br />

### Yaffs2 override:
* CWM has an old method of backing-up yaffs2 partitions as yaffs2 images, instead of tar balls. Since Online Nandroid follows the same formats used by CWM, it follows the same method as well. This has a side affect in some cases (specially if internal sdcard lives in /data/media or if an sd-ext setup is used). To overcome this, Online Nandroid can do tar backups for yaffs2 partitions as well. The override flag is:
```shell
onandroid -y
OR
onandroid --yaffs-override
```

<br />
<br />

### Exit Codes:
* Online Nandroid returns specific exit codes based on the status of the script run. Below is the list of error codes and their respective descriptions.
```shell
0 : Success
65 : Could not acquire root permissions
66 : Sufficient battery not available
67 : Error: BusyBox version less than 1.20 found
68 : SD card not found
69 : Killed by exit/kill signal
70 : mkyaffs2image not found in path
71 : dedupe not found in path
75 : busybox not found in path
80 : Could not change to backup path
81 : Cannot create backup directory
82 : Cannot delete backup directory
83 : Backup name already exists
84 : Cannot write to backup directory
85 : Cannot write to blobs directory
86 : Not enough disk space
87 : Could not change to backup directory
88 : Another instance already running
```

<br />
<br />

### PID:
* Online Nandroid outputs the PID (Process ID) which it is running under, to the file `/data/local/tmp/onandroid.pid` at the beginning of each run. This can be used to explicitly kill the Online Nandroid process via java or shell.

<br />
<br />

### Custom busybox:
* Starting from v8, Online Nandroid provides the ability to specify path to busybox via path to busybox specified in a text file at `/data/local/tmp/onandroid.busybox`. This provides the opportunity for apps to include their own busybox binary within the app's data directory, which could provide a more consistent experience and avoid glitches with various versions of busybox.
* Contents of onandroid.busybox file:
```shell
/system/xbin/busybox
```
* Note: This text file should contain the full path, including the file name of busybox binary, and should not contain a line feed or carriage return or both. Also, it is recommended for app developers to overwrite this file (if it exists), upon each run of the app or backup process and remove the file upon exit of the app or backup process.

<br />
<br />

### Compression modes in TWRP:
* TWRP compression is disabled by default, which is also the default in a new installation of TWRP. To enable TWRP compression, two different compression modes are offered.
* Normal compression using busybox's tar:
```shell
onandroid -w -ce
OR
onandroid --twrp --compression-enable
```
* Alternative compression using busybox's gzip:
```shell
onandroid -w -cg
OR
onandroid --twrp --compression-gzip
```
* Note: The normal compression mode does not work with certain busybox versions. [This BusyBox Installer](https://play.google.com/store/apps/details?id=com.jrummy.busybox.installer) is known to work and [this BusyBox Installer](https://play.google.com/store/apps/details?id=stericson.busybox) does not work. Alternative compression mode was provided to overcome this. However, it might take more time for compression than the normal mode. Sometimes, the alternative compression mode is known to produce smaller backups than the normal mode.