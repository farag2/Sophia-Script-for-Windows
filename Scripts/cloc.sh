# This scripts counts the lines of code and comments in all JavaScript files.
# The copyright-headers are substracted. It uses the command line tool "cloc".
# You can either pass --loc, --comments or  --percentage to show the respective values only.

# Exit the script when one command fails.
set -e

# Go to the repo root.
cd "$( cd "$( dirname "$0" )" && pwd )/.." || \
  { echo "ERROR: Could not find the repo root."; exit 1; }

# Run cloc - this counts code lines, blank lines and comment lines for the specified extensions.
# We are only interested in the summary, therefore the tail -1
# https://github.com/AlDanial/cloc#options-
SUMMARY="$(cloc --include-ext="psd1" --exclude-list-file=.clocignore . --md | tail -1)"

# The $SUMMARY is one line of a markdown table and looks like this:
# SUM:|101|3123|2238|10783
# We use the following command to split it into an array.
IFS='|' read -r -a TOKENS <<< "$SUMMARY"

# Store the individual tokens for better readability.
NUMBER_OF_FILES=${TOKENS[1]}
COMMENT_LINES=${TOKENS[3]}
LINES_OF_CODE=${TOKENS[4]}

# To make the estimate of commented lines more accurate, we have to substract the
# copyright header which is included in each file. This header has the length of five lines.
# As cloc does not count inline comments, the overall estimate should be rather conservative.
COMMENT_LINES=$((COMMENT_LINES - 5 * NUMBER_OF_FILES))

# Print all results if no arguments are given.
if [[ $# -eq 0 ]] ; then
  awk -v a="$LINES_OF_CODE" \
      'BEGIN {printf "Lines of source code: %6.1fk\n", a/1000}'
  awk -v a=$COMMENT_LINES \
      'BEGIN {printf "Lines of comments:    %6.1fk\n", a/1000}'
  awk -v a=$COMMENT_LINES -v b="$LINES_OF_CODE" \
      'BEGIN {printf "Comment Percentage:   %6.1f%\n", 100*a/(a+b)}'
  exit 0
fi

# Show lines of code.
if [[ "$*" == *--loc* ]]
then
  awk -v a="$LINES_OF_CODE" \
      'BEGIN {printf "%.1fk\n", a/1000}'
fi

# Show lines of comments.
if [[ "$*" == *--comments* ]]
then
  awk -v a=$COMMENT_LINES \
      'BEGIN {printf "%.1fk\n", a/1000}'
fi

# Show precentage of comments.
if [[ "$*" == *--percentage* ]]
then
  awk -v a=$COMMENT_LINES -v b="$LINES_OF_CODE" \
      'BEGIN {printf "%.1f\n", 100*a/(a+b)}'
fi
