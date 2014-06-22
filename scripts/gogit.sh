###########################################################################################################
###########################################################################################################
##                                                                                                       ##
##                                     Online Nandroid - Git Updater                                     ##
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

#### gogit.sh
#### Add new partition layouts to Online Nandroid
#### By Ameer Dawood
#### Version 1.1.1
#### Last Updated: 22/06/2014 12:27 UTC+6

#### Constants (All paths should be relative)
repodir="OnlineNandroid"
wikidir="Wiki"
newfilesdir="partlayout"

#### Check for required tools
echo -e "Checking for required tools... \c"
if [ "`which cp`" == "" ]; then
	echo -e "Error: No cp found! Exiting..."
	exit
fi
if [ "`which cat`" == "" ]; then
	echo -e "Error: No cat found! Exiting..."
	exit
fi
if [ "`which curl`" == "" ]; then
	echo -e "Error: No curl found! Exiting..."
	exit
fi
if [ "`which rm`" == "" ]; then
	echo -e "Error: No rm found! Exiting..."
	exit
fi
if [ "`which git`" == "" ]; then
	echo -e "Error: No git found! Exiting..."
	exit
fi
echo -e "Done!"

#### Check if new layouts exist
echo -e "Checking if new layouts exist... \c"
if [ "`find $newfilesdir/raw/ -type f`" == "" ]; then
	echo -e "Error: No new layout found! Exiting..."
	exit
fi
echo -e "Done!"

#### Check for duplicate layouts
echo -e "Checking for duplicate layouts... \c"
for i in $newfilesdir/raw/*; do
	filename=`echo $i | cut -d '/' -f 3`
	if [ -e $repodir/part_layouts/raw/$filename ]; then
		echo "Eror: Duplicate layout $filename found! Exiting..."
		exit
	fi
done
echo -e "Done!"

#### Copy new partition layouts to the git repo
echo -e "Copying new partition layouts to the git repo... \c"
cp $newfilesdir/raw/* $repodir/part_layouts/raw
cp $newfilesdir/zip/* $repodir/part_layouts/zip
echo -e "Done!"

#### Gather data for commit and wiki update
echo -e "Collecting data... \c"
commitm=`cat $newfilesdir/codenames | awk '{print $1}' | tr '\n' ', ' | sed s/',$'/''/g | sed s/','/', '/g`
commitm="part_detect_tool for $commitm"
changelogm=`cat $newfilesdir/codenames | sed s/'.*\t'/''/g | tr '\n' ', ' | sed s/',$'/''/g | sed s/','/', '/g`
changelogm="Added new layout(s) for $changelogm"
lines=`wc -l $newfilesdir/codenames | awk '{print $1}'`
i=0
while [ "$i" -lt "$lines" ]; do
	i=`expr $i + 1`
	line=`cat $newfilesdir/codenames | head -n $i | tail -n 1`
	if [ "$line" != "" ]; then
		codename=`echo $line | awk '{print $1}'`
		devicename=`echo $line | sed s/"$codename\s"/''/g`
		devicem="$devicem| $devicename | $codename | [Download](https://raw.githubusercontent.com/ameer1234567890/OnlineNandroid/master/part_layouts/zip/part_detect_tool.$codename.zip)|\n"
	fi
done
echo -e "Done!"

#### Update the git repo
echo -e "Updating the git repo..."
cat $newfilesdir/codenames >> $repodir/part_layouts/codenames
cd $repodir
git add . > /dev/null 2>&1
git commit -m "$commitm" > /dev/null 2>&1
commitsha=`git rev-parse HEAD`
git push
cd ..
echo -e "Done!"

#### Update the wiki
echo -e "Updating wiki..."
printf "$devicem" >> $wikidir/Supported-Devices.md
cd $wikidir
git add . > /dev/null 2>&1
git commit -m "Update Supported-Devices" > /dev/null 2>&1
git push
cd ..
echo -e "Done!"

#### Write changelog to file
echo -e "Writing changelog to request.json ...\c"
changelogm="$changelogm. $commitsha"
changelogm="{\"body\": \"$changelogm\"}"
echo $changelogm > request.json
echo -e "Done!"

#### Post Changelog
echo -e "Posting changelog"
curl -u 43f723f7a1a0323b309958f89df5e3dc51245f17:x-oauth-basic -X POST -d @request.json -o response.json https://api.github.com/repos/ameer1234567890/OnlineNandroid/issues/2/comments
echo -e "Done!"

#### Housekeeping
echo -e "Housekeeping... \c"
rm $newfilesdir/codenames
rm $newfilesdir/raw/*
rm $newfilesdir/zip/*
rm request.json
echo -e "Done!"

#### Final announcement
echo -e "Everything done! Get, set, go!"
