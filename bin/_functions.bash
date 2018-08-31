#!/bin/bash

# scrub_secret_data()
# This function will find lines in a string and remove anything that contains
# a "kind":"Secret". The default behavior of kubectl is to output the object
# that failed into one line of the stderr. We're trying to find oneliners that
# contain magical keywords that we can remove from the content.
function scrub_secret_data() {
  if [ "${#}" -ne 1 ]; then
    echo "COULD NOT SCRUB DATA, TOO MANY ARGUMENTS"
    exit 1
  fi

  echo -e "$1" | sed -r 's/.*(.?"kind.?":.?"Secret.?"|.?"stringData.?": ?).+$/REDACTED OBJECT/'
}
