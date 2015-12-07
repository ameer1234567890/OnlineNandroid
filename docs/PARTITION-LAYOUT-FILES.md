Online Nandroid uses a file named ``partlayout4nandroid`` for detection unmountable/unmounted partitions such as boot and recovery. This is a guide of how to make the ``partlayout4nandroid`` file for various devices.

1. The file should be in text format.
2. The raw file should be named ``partlayout4nandroid.{codename}`` where {codename} is the device's code name. Eg: ``partlayout4nandroid.maguro`` for Google Galaxy Nexus
3. Line endings should be UNIX style, LF only.
4. The first line of the file should be a column header in the form ``dev: size erasesize name``. (Spacing does not matter.)
5. Each line, thereafter, should start with the partition block device representation, which should be followed by a colon, a space, partition size in hexadecimal, a space, eraze size in hexadecimal, a space and partition name in quotes. An example is shown below:
``mmcblk0p1: 1ab3c 70000 "misc"``
6. The hexadecimal size and erase size should omit the ``0x`` normally used for hexadecimal representations.
7. The hexadecimal size and erase size should be padded with preceding zeros until it is the same length as the hexadecimal size of the partition with the highest  size.
8. The eraze size can be left as zeros, if unknown, padded in the same manner described above.
9. Each partition must have a valid size value.
10. If a partition's name is not known, it can be named as ``unknown``
11. The file should end with a line feed / empty line.
12. The below partitions must be named:
	* boot partition, named as ``boot``.
	* recovery partition, named as ``recovery``, unless the device does not have one.
	* system partition, named as ``system``.
	* data partition, named as ``userdata``.
	* cache partition, named as ``cache``
	* appslog partition, named as ``appslog``, if the device has one.
	* wimax partition, named as ``wimax``, if the device has one.
	* datadata partition, named as ``datadata``, if the device has one.
	* flexrom partition, named as ``flexrom``, if the device has one.
	* efs partition, named as ``efs``, if the device has one.
	* modem / radio partition, named as ``modem``, if the device has one.
	* internal sd card, named as ``emmc``, if the device has one.
	* All other mounted / mountable partitions.

----

* Note: If you have created or wants to create a partition layout file for your preferred device, you are most welcome to contact me and I shall be happy to include it in Online Nandroid's repository and any other places where I provide partition layout files.