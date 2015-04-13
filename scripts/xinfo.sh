###########################################################################################################
###########################################################################################################
##                                                                                                       ##
##                              Online Nandroid - Partition Layout Extractor                             ##
##                                                                                                       ##
##                                             By Ameer Dawood                                           ##
##                                                                                                       ##
###########################################################################################################
###########################################################################################################
# The MIT License (MIT)                                                                                   #
#                                                                                                         #
# Copyright (c) 2015 Ameer Dawood                                                                         #
#                                                                                                         #
# Permission is hereby granted, free of charge, to any person obtaining a copy                            #
# of this software and associated documentation files (the "Software"), to deal                           #
# in the Software without restriction, including without limitation the rights                            #
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell                               #
# copies of the Software, and to permit persons to whom the Software is                                   #
# furnished to do so, subject to the following conditions:                                                #
#                                                                                                         #
# The above copyright notice and this permission notice shall be included in all                          #
# copies or substantial portions of the Software.                                                         #
#                                                                                                         #
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR                              #
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,                                #
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE                             #
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER                                  #
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,                           #
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE                           #
# SOFTWARE.                                                                                               #
###########################################################################################################

#### xinfo.sh
#### Extract information from an Android device for
#### making new partition layouts for Online Nandroid
#### By Ameer Dawood
#### Version 1.0.0
#### Last Updated: 20/06/2014 18:20 UTC+6

#### Output device info
echo -e "Extracting device info... \c"
cat /system/build.prop | grep "^ro.product." | grep -v "^ro.product.locale." > xinfo.txt
echo "" >> xinfo.txt
echo -e "Done!"

#### Output /proc/partitions
echo -e "Extracting list of partitions... \c"
cat /proc/partitions >> xinfo.txt
echo "" >> xinfo.txt
echo -e "Done!"

#### Output block devices by-name
echo -e "Extracting partition info... \c"
ls -l /dev/block/platform/*/by-name >> xinfo.txt
echo -e "Done!"
