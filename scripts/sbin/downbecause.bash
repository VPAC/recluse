#!/bin/bash

# downbecause
#    
# Produce errors for offline nodes based on moab information
#                                                        
# Written by Chris Samuel, csamuel@vpac.org              
# Copyright (C) 2009 Victorian Partnership for Advanced Computing

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or   
# (at your option) any later version.                                 

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of 
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the  
# GNU General Public License for more details.                   

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

CONFIG=/usr/local/recluse/config
[ -r "$CONFIG" ] || echo "Can't source $CONFIG"
[ -r "$CONFIG" ] || exit 0
source $CONFIG

if [ $# -ne 0 ]
then
	command="diagnose -n -t $1"
else
	command="diagnose -n"
fi

for i in $($command | egrep "^$cluster" | egrep "Down|Drained" | awk '{print $1}'); do
	reason=$(checknode $i | grep 'node rm message' | cut -b 26-)
	if [ x"$reason" == "x" ]
	then
		reason="NO REASON"
	fi
	echo "$i  $reason"
done
