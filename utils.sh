#!/bin/bash

# get dimesions of single img_file, usage: get_dims img_file
alias dimensions_of='ffprobe -v error -select_streams v -show_entries stream=width,height -of csv=p=0:s=x'

# recursivley get dimensions of all files in dir
function get_dims() {
   header="(width x height)     file"
   if [[ -f "$1" ]]; then
      echo "${header}"
      echo "   $(dimensions_of ${1}): ${1}" && return 0
   elif [[ -d "$1" ]]; then
      CUR_DIR=$(pwd)
      #echo "Dimesions (width x height) of images in ${CUR_DIR}/${SEARCH_DIR}:"
      echo "${header}"
      echo "   "
      SEARCH_DIR=$1
      # remove trailing '/' if directory has ending '/'
      [[ "${SEARCH_DIR}" == */ ]] && SEARCH_DIR=$(sed 's,/,,g' <<< "${SEARCH_DIR}")

      # find these extensions (all CAPS too): .png, .jpg
      files=$(find "${SEARCH_DIR}" -type f \( -name "*.png" -o -name "*.PNG" -o -name "*.jpg" -o -name "*.JPG" \) -print)
      for f in ${files}; do
         echo "   $(dimensions_of ${f}): $(basename ${f})"
      done
   else
      echo "$dir is not a directory" && return 1
   fi
}

function scale_img() {
   # how to scale file.png to 400 x 500:
   #   scale_img file.png 400 500
   input_img=$1
   new_width="${2}"
   new_height="${3}"
   file_ext="${input_img##*.}"
   output_file="${input_img%%.*}_${new_width}x${new_height}.${file_ext}"
   ffmpeg -i "${input_img}" -vf scale="${new_width}:${new_height}" "${output_file}" &> /dev/null
   echo "Created ${output_file}"
}
