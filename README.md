Nandroid backups are usually performed in recovery mode. This means you would have to turn off your phone and reboot in recovery mode, which wastes a whole lot of time rebooting and a lot more time offline. For me, this has been a killer as I do regular nandroid backups. Having to reboot in recovery and finding missed calls, sms from my wife and friends is totally not accepatable for me. So, I set to develop an online nandroid backup tool, namely Online Nandroid, which can do nandroid backups without switching off my phone.

Today, I am releasing it to public, as it may serve good for some others too. Originally I developed Online Nandroid specifically for Xperia devices, but now I am releasing it for all android devices.

This tool, eventhough called "Online Nandroid", does not upload/save backups to any online/cloud services. Online here means that it does backup while phone is live or still running Android.

The short name onandroid is meant to be pronouced as o-nandroid or o'nandroid and NOT on-android.

Online Nandroid backups the below partitions to ``/sdcard/clockworkmod/backup`` directory.

* mmcblk0_start (for Acer devices)
* boot
* recovery
* wimax (for Samsung devices)
* appslog (for HTC and Sony (Ericsson) devices)
* system
* data
* cache
* datadata (for Samsung devices)
* efs (for Samsung devices)
* .cust_backup (for Huawei devices)
* flexrom (for Acer devices)
* (cp)uid (for Acer devices)
* .android_secure
* sd-ext

The date format used for folder name is the same used by CWM itself and nandroid backups created with Online Nandroid can safely be restored using CWM.

Feedback (especially ideas to improve) are most welcome.
