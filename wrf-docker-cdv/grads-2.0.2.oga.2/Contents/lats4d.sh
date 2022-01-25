#!/bin/bash
#
# Simple sh(1) script to start GrADS and LATS4D, exiting from GrADS
# upon completion.
#
# Revision history:
#
# 29dec1999   da Silva  First crack. 
# 05jan1999   da Silva  Minor mod.
# 04oct2005   Todling   Added pointer for lats4d.gs in the build
# 10may2006   da Silva  Auto detection of install dir
# 15Nov2008   da Silva  Added gradsdap, simplified; renamed 
#                       lats4d --> lats4d.sh
#
#-------------------------------------------------------------------------

# Find where is script really is (handles syminks)

if ! garoot=`dirname $0`; ! garoot=`$garoot/opengrads --whereami`
then
     echo "lats4d.sh: inconsistent OpenGrADS Bundle installation" 
     exit 1
fi

# Find latest v1 and v2, if available
v1=(`cd $garoot/*/Versions; /bin/ls -dr 1.* `)
# v2=(`cd $garoot/*/Versions; /bin/ls -dr 2.* `)

gaversion=$GAVERSION 

# Use the top Bundle Contents. dir to derive paths

gradsbin="$garoot/grads" # perl wrapper
lats4dgs="lats4d.gs"     # GASCRP will be set accordingly by wrapper

if [ $#0 -lt 1 ]; then
	echo "          "
	echo "NAME"
	echo "     lats4d - file conversion and subsetting utility"
	echo "          "
        echo "SYNOPSIS"
        echo "     lats4d.sh [OPTIONS] option(s)"
	echo "          "
	echo "DESCRIPTION"
	echo "     lats4d is a command line interface to GrADS"
        echo "     and the lats4d.gs script. It starts either"
        echo "     grads (by default) or gradshdf/gradsdods depending "
        echo "     on whether the options -hdf/-dods were specified."
        echo "     It then runs lats4d.gs, and exits from GrADS upon"
        echo "     completion.     "
	echo "          "
	echo "     For additional information on LATS4D enter: lats4d -h"
	echo "          "
	echo "OPTIONS"
	echo " -hdf       for producing GRIB or HDF-SDS files (GrADS v1.x)"
	echo " -dods      for reading OPeNDAP URLs with gradsdods (GrADS v1.x)"
	echo " option(s)  for a list of lats4d options enter: lats4d -h"
	echo "          "
	echo "IMPORTANT"
	echo "     You must specify the input file name with "
        echo "     the \"-i\" option."
	echo "          "
        echo "SEE ALSO  "
        echo "     http://opengrads.org/wiki/index.php?title=LATS4D"
	echo "          "
	exit 1
fi

if [ "$1" = "-nc" ];  then
	gradsbin="grads"
	shift
elif [ "$1" = "-hdf" ]; then
	gradsbin="gradshdf"
        if [ "x$v1" = "x" ]; then
           echo "lats4d.sh: this option requires GrADS v1.x"
           exit 1
        else
           $gaversion=$v1
        fi
	shift
elif [ "$1" = "-dods" ]; then
	gradsbin="grads"
        if [ "x$v1" = "x" ]; then
           echo "lats4d.sh: this option requires GrADS v1.x"
           exit 1
        else
           $gaversion=$v1
        fi
	shift
elif [ "$1" = "-dap" ]; then
	gradsbin="grads"
	shift
fi

# Set GrADS version

   if test "x$gaversion" != "x" ; then 
         export GAVERSION=$gaversion
   fi

echo $gradsbin -blc \'run $lats4dgs -q $@ \'
eval $gradsbin -blc \'run $lats4dgs -q $@ \'
