Detecting partition layout is key to any app using Online Nandroid. Online Nandroid, as of v8.xx, has support for detecting partition layout in 4 different ways, which are:
* `/proc/mtd` on MTD based devices
* `/proc/emmc` on some EMMC based devices
* `/proc/dumchar_info` on MTK based devices
* `/system/partlayout4nandroid`

Detection of partition layout runs in the same order of the above list. Online Nandroid looks for `/proc/mtd` first and so on. The last successful method of detection is treated and final and used as the layout. For example, even if `/proc/mtd` is found and contains valid layout, if `/proc/dumpchar_info` is found, the latter is treated final. This order is very important for the below 2 reasons.
* On MTD based devices, it has a valid `/proc/mtd` but without actual boot and recovery partition mapping. Those are properly defined in `/proc/dumchar_info`.
* If, for some reason, any of `/proc/mtd`, `/proc/emmc`, `/proc/dumchar_info` is not valid, it can be overriden by using `/system/partlayout4nandroid`, Online Nandroid's own partition layout file. To be honest, I have never come across such an instance, but I really feel safe keeping a reserve as manufacturers do all sorts of "mess" with newer devices.

#### MTD Based Devices
MTD devices can be detected by checking for existence of `/dev/mtd/mtd1` or `/dev/block/mtdblock1`. Some devices (specifically Google Galaxy Nexus - maguro and some others) has mtd0 but is not an MTD device. Thus you need to look for mtd1 instead of mtd0. MTD device detection should not be done by checking for existence of `/proc/mtd` as some EMMC based devices have this file but with only headers. Also, MTK based devices has a valid `/proc/mtd` whereas the proper partition layout can only be obtained from `/proc/dumchar_info`.

Thus, `/proc/mtd` is not to be relied upon for detection of MTD devices.
On some devices `/dev/mtd1` and `/dev/block/mtdblock1` might not be present but the device might actually be an MTD device. In this rare case, an MTD device can be detected by looking for mtdblock1 in `/proc/partitions`.

MTD based devices does not require patch files (`/system/partlayout4nandroid`). Thus, the user can be informed so.

#### MTK Based Devices
Devices based on MTK chipsets include `/proc/dumchar_info`. The existence of `/proc/dumchar_info` can be depended upon for MTK based device detection as it is not present on any other devices.

MTK based devices does not require patch files (`/system/partlayout4nandroid`). Thus, the user can be informed so.

#### Other EMMC based devices
These devices require partch files (`/system/partlayout4nandroid`). Thus, the user should be presented with list of patches to choose from. Optionally the list can be filtered based on the app's own detection mechanism or automatic detection and application of patch can be used.

In the case of automatic detection, it is recommended let the user confirm the detected device, instead of applying patch without user confirmation. This recommendation is due to the fact that Android is a vast universe of different devices from different manufacturers and there is every possibility of automatic detection going wrong. Custom ROMs and ROM modifications add up to this difficulty in automatic detection.
