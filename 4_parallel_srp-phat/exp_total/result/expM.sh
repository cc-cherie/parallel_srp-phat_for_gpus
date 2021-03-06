#!/bin/bash
# Release date: June 2015
# Author: Taewoo Lee, (twlee@speech.korea.ac.kr)
#
# Copyright (C) 2015 Taewoo Lee
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#
# Out: ./log/expM/exp_M?_Q?_TD?_CC?_SRP?_FD?_SRP?.log
#
# Reference:
# [1] Taewoo Lee, Sukmoon Chang, and Dongsuk Yook, "Parallel SRP-PHAT for
#     GPUs," Computer Speech and Language, vol. 35, pp. 1-13, Jan. 2016.
#
CheckError () {
  if [ $? -ne 0 ]; then
    exit 0
	fi
}

rm -f ./*.log
CheckError

# exp_M
for q in 97200; do
  for m in 8 16 32; do
	  
    # FD_GPU
    ## copy necessary files
    rm -f ../../TOA_table.bin 
    CheckError
    rm -f ../../sphCoords.bin
    CheckError
    cp ../tables/toa_tables/TOA_table_M"$m"_Q"$q".bin ../../TOA_table.bin
    CheckError
    cp ../tables/toa_tables/sphCoords_Q"$q".bin ../../sphCoords.bin
    CheckError
    
	  for fdgpu in 2 4; do  #2=Minotto, 4=Proposed
		  echo "exp_M M=""$m"" Q=""$q"" FDGPU""$fdgpu"
		  CheckError
		  rm -f ../../exp
		  CheckError
		  cp ../exes/"exp_M""$m""_Q""$q""_TD0_CC0_SRP0_FD1_SRP""$fdgpu" ../../exp
		  CheckError
		  for dir in 090 120 150 180; do
		    echo "dir==$dir"
			  rm -f ../../datFileListToProcess.txt
			  CheckError
			  cp ../datFileLists/datFileListToProcess_"$m"ch_"$dir".txt ../../datFileListToProcess.txt
			  CheckError
			  cd ../../
			  nvprof ./exp $dir 10 >> ./exp_total/result/"exp_M""$m""_Q""$q""_TD0_CC0_SRP0_FD1_SRP""$fdgpu"".log" 2>&1
#        nvprof --print-gpu-trace ./exp $dir 10 >> ./exp_total/result/"Detailed_exp_M""$m""_Q""$q""_TD0_CC0_SRP0_FD1_SRP""$fdgpu"".log" 2>&1   #Detailed profiling
			  CheckError
			  cd ./exp_total/result
			  CheckError
		  done		
	  done

	  #TD_GPU
	  ## copy necessary files
	  rm -f ../../ssc.bin
	  CheckError
	  cp ../tables/tdoa_tables/"TDOA_table_M""$m""_Q""$q"".bin" ../../TDOA_table.bin
	  CheckError
	  for tdcc in 3; do       #3=Proposed
	    for tdsrp in 43; do   #43=Proposed
		    echo "exp_M M=""$m"" Q=""$q"" TDGPU ""CC=""$tdcc"" SRP=""$tdsrp"
		    rm -f ../../exp
		    CheckError
		    cp ../exes/"exp_M""$m""_Q""$q""_TD1_CC""$tdcc""_SRP""$tdsrp""_FD0_SRP0" ../../exp
		    CheckError
		    for dir in 090 120 150 180; do
		      echo "dir==$dir"
			    rm -f ../../datFileListToProcess.txt
			    CheckError
			    cp ../datFileLists/datFileListToProcess_"$m"ch_"$dir".txt ../../datFileListToProcess.txt
			    CheckError
			    cd ../../
			    CheckError
			    nvprof ./exp $dir 10 >> ./exp_total/result/"exp_M""$m""_Q""$q""_TD1_CC""$tdcc""_SRP""$tdsrp""_FD0_SRP0.log" 2>&1
#			    nvprof --print-gpu-trace ./exp $dir 10 >> ./exp_total/result/"Detailed_exp_M""$m""_Q""$q""_TD1_CC""$tdcc""_SRP""$tdsrp""_FD0_SRP0.log" 2>&1
			    CheckError
			    cd ./exp_total/result
			    CheckError
		    done
		  done
	  done
	  
	  for tdcc in 13; do      #13=Minotto
	    for tdsrp in 41; do   #41=Minotto
		    echo "exp_M M=""$m"" Q=""$q"" TDGPU ""CC=""$tdcc"" SRP=""$tdsrp"
		    rm -f ../../exp
		    CheckError
		    cp ../exes/"exp_M""$m""_Q""$q""_TD1_CC""$tdcc""_SRP""$tdsrp""_FD0_SRP0" ../../exp
		    CheckError
		    for dir in 090 120 150 180; do
		      echo "dir==$dir"
			    rm -f ../../datFileListToProcess.txt
			    CheckError
			    cp ../datFileLists/datFileListToProcess_"$m"ch_"$dir".txt ../../datFileListToProcess.txt
			    CheckError
			    cd ../../
			    CheckError
			    nvprof ./exp $dir 10 >> ./exp_total/result/"exp_M""$m""_Q""$q""_TD1_CC""$tdcc""_SRP""$tdsrp""_FD0_SRP0.log" 2>&1
#			    nvprof --print-gpu-trace ./exp $dir 10 >> ./exp_total/result/"Detailed_exp_M""$m""_Q""$q""_TD1_CC""$tdcc""_SRP""$tdsrp""_FD0_SRP0.log" 2>&1
			    CheckError
			    cd ./exp_total/result
			    CheckError
		    done
		  done
	  done
	
  done
done

