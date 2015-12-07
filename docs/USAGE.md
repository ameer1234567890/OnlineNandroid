### Basic Usage:

1. Open terminal emulator
1. Type `su` to obtain root
1. Type `onandroid`
1. Wait and watch

* The behaviour of Online Nandroid can be adjusted by using command line flags, some of which are described in detail below. Each command line flag has its longer counter-part and both forms can be mixed. For a complete list of command line flags and short descriptions, type:
```shell
onandroid -h
OR
onandroid --help
```

<br />
<br />

### Custom Backup Name:
* Example:
```shell
onandroid -c NAME
OR
onandroid --custom NAME
```
* Please be careful not to include characters not allowed in filenames. Spaces are not allowed.

<br />
<br />

### Timezone modifier:
* Example: Use phone timezone for backup file name
```shell
onandroid -p
OR
onandroid --phone
```

* Example: Use UTC (default) for backup file name
```shell
onandroid -u
OR
onandroid --utc
```
* Note: UTC is used as default (if no timezone modifier is passed). This is to comply with CWM nandroid backups.

<br />
<br />

### Backup Modes:
##### Good old backup mode (default).
* Example:
```shell
onandroid -o
OR
onandroid --old
```
* Note: This is the most commonly known, default backup format.

<br />

##### Split backup mode (CWM6+ only).
* Example:
```shell
onandroid -l
OR
onandroid --split
```
* Note: This is specifically useful if you have partitions which are over 2GB in size. Use this only if you have CWM 6+.

<br />

##### CWM6 style incremental / dedupe backup mode.
* Example:
```shell
onandroid -i
OR
onandroid --incremental
```

<br />

##### Garbage collect. For incremental backups (used for cleanup after deleting incremental backups).
* Example:
```shell
onandroid -gc
OR
onandroid --garbagecollect
```

<br />

##### Advanced / Selective backup mode. For backing up only specific partitions.
* Example:
```shell
onandroid -a PARTITIONS
OR
onandroid --advanced PARTITIONS
```
* Partition letters / names can be found by typing ``onandroid -ah``

<br />

##### TWRP backup mode.
* Example:
```shell
onandroid -w
OR
onandroid --twrp
```
* By default, TWRP backup mode creates uncompressed backups. If compressed backups are required, use it like this:
```shell
onandroid -w -ce
OR
onandroid --twrp --compression-enable
```
* By default, TWRP backup mode generates md5sum. If md5sums are not required, use it like this:
```shell
onandroid -w -md
OR
onandroid --twrp --md5-disable
```

<br />
<br />

### Replace Older Backups (with same name) - used with custom backup names:
* While using custom backup names, Online Nandroid will not allow an already existing backup name to be specified, by default. Trying this will return an error and halt backup. If you want to replace the older backup with a new backup, by using the same custom backup name, specify the below command line flag.
* Example:
```shell
onandroid -c MyBackup -r
OR
onandroid --custom MyBackup --replace
```
* Note: This will only work with custom backup names. This can be used to update a backup from a previous state, by way of using advanced backup mode in combination with this mode.
* Note: As of v9, replace mode would only replace the old backup after successful completion of the new backup. The old backup would be renamed to `{backup_name}_old`, where `{backup_name}` is the name of the backup. Once the new backup has completed, its files are moved to the old backup directory, the new backup directory is removed and the directory is renamed back to the backup name.