#!/bin/sh
## iostat csv generator ##
# This script converts iostat output every second in one line and generates a csv file.

# Settings
COMMAND_OUTPUT=`iostat -t -x`
PASTE_OFFSET=2
TITLE_LINE_OFFSET=6
TITLE_LINE_HEADER="Date Time"


# Count command output line number
COMMAND_OUTPUT_LINE_NUMBER=`wc -l <<EOF
${COMMAND_OUTPUT}
EOF`

# Calcurate how many lines to concatenate in each second
PASTE_LINE_NUMBER=`expr ${COMMAND_OUTPUT_LINE_NUMBER} - ${PASTE_OFFSET}`

# Print " -" for ${PASTE_LINE_NUBER} times to concatenate output lines by using paste command
PASTE_LINE_HYPHENS=`seq -s' -' ${PASTE_LINE_NUMBER} | tr -d '[:digit:]'`


# Generate title line for csv
TITLE_AVG_CPU=`grep avg-cpu <<EOF
${COMMAND_OUTPUT}
EOF`
TITLE_EACH_DEVICE=`grep "Device" <<EOF
${COMMAND_OUTPUT}
EOF`
DEVICE_LINE_NUMBER=`expr ${COMMAND_OUTPUT_LINE_NUMBER} - ${TITLE_LINE_OFFSET}`
TITLE_DEVICES=`seq -s"${TITLE_EACH_DEVICE} " ${DEVICE_LINE_NUMBER} | tr -d '[:digit:]'`

echo "${TITLE_LINE_HEADER} ${TITLE_AVG_CPU} ${TITLE_DEVICES}" \
 | awk 'BEGIN {OFS=","} {$1=$1;print $0}' | sed 's/avg-cpu//g;s/://g;s/,,/,/g'


# Main part
LANG=C; iostat -t -x 1 | grep -v -e avg-cpu -e Device -e Linux \
 | paste ${PASTE_LINE_HYPHENS} | awk 'BEGIN {OFS=","} {$1=$1;print $0}'

# tail -n +3
#  => Output after 3rd lines of the iostat output

# grep -v -e avg-cpu -e avgqu-sz
#  => Exclude title columns

# paste ${PASTE_LINE_HYPHENS}
#  => Concatenate output lines in each second to one line

# awk 'BEGIN {OFS=","} {$1=$1;print $0}'
#  => Separate each value by comma
