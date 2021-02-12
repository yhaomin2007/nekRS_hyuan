#!/bin/sh
# Copyright 1998-2019 Lawrence Livermore National Security, LLC and other
# HYPRE Project Developers. See the top-level COPYRIGHT file for details.
#
# SPDX-License-Identifier: (Apache-2.0 OR MIT)

TNAME=`basename $0 .sh`
RTOL=$1
ATOL=$2

#=============================================================================
# no test comparison for now. Just a holder file with fake tests. Hard to
# develop tests because of the coarsening scheme.
#=============================================================================

tail -3 ${TNAME}.out.0 > ${TNAME}.testdata
tail -3 ${TNAME}.out.0 > ${TNAME}.testdata.temp
(../runcheck.sh ${TNAME}.testdata ${TNAME}.testdata.temp $RTOL $ATOL) >&2

#=============================================================================
tail -3 ${TNAME}.out.1 > ${TNAME}.testdata
tail -3 ${TNAME}.out.1 > ${TNAME}.testdata.temp
(../runcheck.sh ${TNAME}.testdata ${TNAME}.testdata.temp $RTOL $ATOL) >&2

#=============================================================================
tail -3 ${TNAME}.out.2 > ${TNAME}.testdata
tail -3 ${TNAME}.out.2 > ${TNAME}.testdata.temp
(../runcheck.sh ${TNAME}.testdata ${TNAME}.testdata.temp $RTOL $ATOL) >&2

#=============================================================================
# compare with baseline case
#=============================================================================

FILES="\
 ${TNAME}.out.0\
 ${TNAME}.out.1\
 ${TNAME}.out.2\
"

for i in $FILES
do
  echo "# Output file: $i"
  tail -3 $i
done > ${TNAME}.out

# Make sure that the output files are reasonable
CHECK_LINE="Iterations"
OUT_COUNT=`grep "$CHECK_LINE" ${TNAME}.out | wc -l`
SAVED_COUNT=`grep "$CHECK_LINE" ${TNAME}.saved | wc -l`
if [ "$OUT_COUNT" != "$SAVED_COUNT" ]; then
   echo "Incorrect number of \"$CHECK_LINE\" lines in ${TNAME}.out" >&2
fi

if [ -z $HYPRE_NO_SAVED ]; then
   (../runcheck.sh ${TNAME}.out ${TNAME}.saved $RTOL $ATOL) >&2
fi

#=============================================================================
# remove temporary files
#=============================================================================

rm -f ${TNAME}.testdata*
