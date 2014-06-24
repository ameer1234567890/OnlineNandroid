###########################################################################################################
###########################################################################################################
##                                                                                                       ##
##                                Online Nandroid - Partition Layout Maker                               ##
##                                                                                                       ##
##                                             By Ameer Dawood                                           ##
##                                                                                                       ##
###########################################################################################################
###########################################################################################################
# Software License Agreement (Modified BSD License)                                                       #
# Copyright (c) 2012-2014, Ameer Dawood                                                                   #
# All rights reserved.                                                                                    #
# Redistribution and use of this software in source and binary forms, with or without modification, are   #
# permitted provided that the following conditions are met:                                               #
# * Redistributions of source code must retain the above copyright notice, this list of conditions and    #
#   the following disclaimer.                                                                             #
# * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and #
#   the following disclaimer in the documentation and/or other materials provided with the distribution.  #
# * The name of the author may not be used to endorse or promote products derived from this software      #
#   without specific prior written permission.                                                            #
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED  #
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A  #
# PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR  #
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT      #
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS     #
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR  #
# TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF    #
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.                                                              #
###########################################################################################################

#### partlayout.sh
#### Generate partition layouts for Online Nandroid
#### By Ameer Dawood
#### Version 1.0.1
#### Last Updated: 24/06/2014 11:06 UTC+6

#### Version
version="1.0.0"

#### Help screen
if [ "$1" == "--help" -o "$1" == "-h" ]; then
	echo ""
	echo "Online Nandroid - Partition Layout Maker v$version by Ameer Dawood"
	echo ""
	echo "Usage: partlayout.sh [options]"
	echo ""
	echo "Options:"
	echo "  -h, --help          display this help message and exit"
	echo "  -m, --mtk           MTK Mode (if input file is dumchar_info)"
	echo "  -s, --scatter       Scatter File Mode (if input file is a scatter file)"
	echo ""
	exit 0
fi

#### Define constants
raw_output_file="partlayout4nandroid.device"
input_file="Partitions.txt"

#### Check for required tools
echo -e "Checking for required tools... \c"
if [ "`which wc`" == "" ]; then
	echo -e "Error: No wc found! Exiting..."
	exit
fi
if [ "`which expr`" == "" ]; then
	echo -e "Error: No expr found! Exiting..."
	exit
fi
if [ "`which awk`" == "" ]; then
	echo -e "Error: No awk found! Exiting..."
	exit
fi
if [ "`which egrep`" == "" ]; then
	echo -e "Error: No egrep found! Exiting..."
	exit
fi
if [ "`which cat`" == "" ]; then
	echo -e "Error: No cat found! Exiting..."
	exit
fi
if [ "`which rm`" == "" ]; then
	echo -e "Error: No rm found! Exiting..."
	exit
fi
if [ "`which mv`" == "" ]; then
	echo -e "Error: No mv found! Exiting..."
	exit
fi
if [ "`which 7za`" == "" ]; then
	echo -e "Error: No 7za found! Exiting..."
	exit
fi
echo -e "Done!"

##################### Making Partition Layout #####################
echo "#### Making Partition Layout"
echo "#############################"

#### Check if input file exists
if [ ! -f $input_file ]; then
	echo "Input file missing!"
	exit 2
fi

#### Check and announce mode
if [ "$1" == "-m" -o "$1" == "--mtk" ]; then
	mode="mtk"
	echo "MTK Mode selected!"
elif [ "$1" == "-s" -o "$1" == "--scatter" ]; then
	mode="scatter"
	echo "Scatter File Mode selected!"
else
	echo "Normal Mode selected!"
fi

#### Set variables
lines=`wc -l $input_file | awk '{print $1}'`
lines=`expr $lines + 1`

#### Check the maximum length of size
i=0
max_dec=0
while [ "$i" -lt "$lines" ]; do
	i=`expr $i + 1`
	line=`cat $input_file | head -n $i | tail -n 1`
	if [ "$mode" == "mtk" ]; then
		is_line_valid="`echo $line | awk '{print $2}' | egrep "^0x"`"
	elif [ "$mode" == "scatter" ]; then
		is_line_valid="`echo $line | awk '{print $2}' | egrep "^0x"`"
	else
		is_line_valid="`echo $line | awk '{print $1}' | egrep "^[0-9]+$"`"
	fi
	if [ "$i" == 1 ]; then
		first_line=$line
		codename=`echo $first_line | awk '{print $1}'`
		if [ "$codename" ]; then
			raw_output_file="partlayout4nandroid.$codename"
		fi
	fi
	if [ "$line" != "" -a "$is_line_valid" != "" ]; then
		if [ "$mode" == "mtk" -o "$mode" == "scatter" ]; then
			size_hexl=`echo $line | awk '{print $2}'`
			size_dec=`printf "%d \n " $size_hexl`
			size_dec=`expr $size_dec / 1024`
		else
			size_dec=`echo $line | awk '{print $3}'`
		fi
		if [ "$size_dec" -gt "$max_dec" ]; then
			max_dec=$size_dec
		fi
	fi
done

#### Check if output file already exists
if [ -f $raw_output_file ]; then
	echo "Output file already exists!"
	exit 2
fi

#### Calculate maximum length of size & set equivalant number of zeros for erase size
max_hex=`printf "%x\n" $max_dec`
max_len=`echo $max_hex | wc -c`
max_len=`expr $max_len - 1`
while [ $max_len -gt 0 ]; do
	erase_size="0$erase_size"
	max_len=`expr $max_len - 1`
done
erase_len=`echo $erase_size | wc -c`
erase_len=`expr $erase_len - 1`

#### Add additional CR to the end of input file (to overcome a bug if the file does not end with a CR)
echo "" >> $input_file

#### Write out the headers
echo "$first_line" > $raw_output_file
echo "" >> $raw_output_file
if [ "$mode" == "mtk" -o "$mode" == "scatter" ]; then
	echo "dev: size erasesize name start" >> $raw_output_file
else
	echo "dev: size erasesize name" >> $raw_output_file
fi

#### Calculate hexadecimal values and output to file (and screen)
i=0
line_n=0
while [ "$i" -lt "$lines" ]; do
	i=`expr $i + 1`
	line=`cat $input_file | head -n $i | tail -n 1`
	# Check if line is a valid line
	if [ "$mode" == "mtk" ]; then
		is_line_valid="`echo $line | awk '{print $2}' | egrep "^0x"`"
	elif [ "$mode" == "scatter" ]; then
		is_line_valid="`echo $line | awk '{print $2}' | egrep "^0x"`"
	else
		is_line_valid="`echo $line | awk '{print $1}' | egrep "^[0-9]+$"`"
	fi
	# Continue if line is valid
	if [ "$line" != "" -a "$is_line_valid" != "" ]; then
		line_n=`expr $line_n + 1`
		# Partition Size
		if [ "$mode" == "mtk" ]; then
			size_hexl=`echo $line | awk '{print $2}'`
			size_dec=`printf "%d \n " $size_hexl`
			size_dec=`expr $size_dec / 1024`
		elif [ "$mode" == "scatter" ]; then
			i_next=`expr $i + 3`
			line_next=`cat $input_file | head -n $i_next | tail -n 1`
			size_hexl_this=`echo $line | awk '{print $2}'`
			size_dec_this=`printf "%d \n " $size_hexl_this`
			size_dec_this=`expr $size_dec_this / 1024`
			size_hexl_next=`echo $line_next | awk '{print $2}'`
			size_dec_next=`printf "%d \n " $size_hexl_next`
			size_dec_next=`expr $size_dec_next / 1024`
			size_dec=`expr $size_dec_next - $size_dec_this`
		else
			size_dec=`echo $line | awk '{print $3}'`
		fi
		size_hex=`printf "%x\n" $size_dec`
		# Partition device
		if [ "$mode" == "mtk" ]; then
			partition=`echo $line | awk '{print $5}' | sed s/'\/dev\/block\/'/''/g`
		elif [ "$mode" == "scatter" ]; then
			partition="mmcblk0"
		else
			partition=`echo $line | awk '{print $4}'`
		fi
		size_len=`echo $size_hex | wc -c`
		size_len=`expr $size_len - 1`
		if [ $size_len -lt $erase_len ]; then
			prepend_len=`expr $erase_len - $size_len`
			while [ $prepend_len -gt 0 ]; do
				size_hex="0$size_hex"
				prepend_len=`expr $prepend_len - 1`
			done
		fi
		# Partition Name
		if [ "$mode" == "mtk" ]; then
			partition_name=`echo $line | awk '{print $1}'`
		elif [ "$mode" == "scatter" ]; then
			partition_name=`echo $line | awk '{print $1}'`
			partition_name="`echo $partition_name | tr 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' 'abcdefghijklmnopqrstuvwxyz'`"
		else
			partition_name=`echo $line | awk '{print $5}'`
		fi
		partition_name="`echo $partition_name | sed s/'bootimg'/'boot'/g`"
		partition_name="`echo $partition_name | sed s/'android'/'system'/g`"
		partition_name="`echo $partition_name | sed s/'usrdata'/'userdata'/g`"
		partition_name="`echo $partition_name | sed s/'fat'/'emmc'/g`"
		partition_name="`echo $partition_name | sed s/'__nodl_'/''/g`"
		# Partition start
		if [ "$mode" == "mtk" ]; then
			partition_start_hexl=`echo $line | awk '{print $3}'`
			partition_start_dec=`printf "%d \n " $partition_start_hexl`
			partition_start_dec=`expr $partition_start_dec / 1024`
			partition_start_hex=`printf "%x\n" $partition_start_dec`
		elif [ "$mode" == "scatter" ]; then
			partition_start_hexl=`echo $line | awk '{print $2}'`
			partition_start_dec=`printf "%d \n " $partition_start_hexl`
			partition_start_dec=`expr $partition_start_dec / 1024`
			partition_start_hex=`printf "%x\n" $partition_start_dec`
		fi
		partition_start_len=`echo $partition_start_hex | wc -c`
		partition_start_len=`expr $partition_start_len - 1`
		if [ $partition_start_len -lt $erase_len ]; then
			prepend_len=`expr $erase_len - $partition_start_len`
			while [ $prepend_len -gt 0 ]; do
				partition_start_hex="0$partition_start_hex"
				prepend_len=`expr $prepend_len - 1`
			done
		fi
		# Prepare formatted line to output
		if [ "$mode" == "mtk" -o "$mode" == "scatter" ]; then
			formatted_line="$partition: $size_hex $erase_size \"$partition_name\" $partition_start_hex"
		else
			formatted_line="$partition: $size_hex $erase_size \"$partition_name\""
		fi
		# Output to file (and screen)
		echo $formatted_line >> $raw_output_file
	fi
done

#### Calculate how many lines processed / discarded, and display summary
i=`expr $i + 1`
discarded=`expr $i - $line_n`
echo "$i lines read."
echo "$discarded lines discarded."
echo "$line_n lines processed."
echo -e "Removing input file...\c"
rm $input_file
echo "Done!"

##################### Making update.zip #####################
echo ""
echo "#### Making update.zip"
echo "#############################"

#### Collect information and set variables
echo "Collecting information..."
device_details=`cat $raw_output_file | head -n 1`
lines_in_file=`cat $raw_output_file | wc -l`
lines_to_output=`expr $lines_in_file - 2`
codename=`echo $device_details | awk '{print $1}'`
device_name=`echo $device_details | sed s/"$codename "/''/g`
zip_output_file="part_detect_tool.$codename.zip"

#### Check if a zip file was already made or not
if [ -f $zip_output_file ]; then
	echo "Zip File Already Exists!"
	exit 2
fi

#### Write out to codenames file
echo "Writing out to codenames file..."
echo -e "$codename\t$device_name" >> codenames

#### Prepare for zip generation
echo "Copying files..."
cat $raw_output_file | tail -n $lines_to_output > 0update.zip/system/partlayout4nandroid

#### Generate zip file and cleanup
echo "Producing update.zip..."
cd 0update.zip
7za a -tzip $zip_output_file | tail -n 1
mv system/partlayout4nandroid ../$raw_output_file
mv $zip_output_file ../
cd ..

#### Store raw file and zip file in appropriate directories
echo "Storing files..."
mv $zip_output_file zip
mv $raw_output_file raw

#### Announce done
echo "Done!"
