#! /bin/sh -eu

# Copy files from /usr/share/sbt/ref into ${SBT_CONFIG} and ${IVY_CONFIG}
# So the initial ~/.sbt is set with expected content.
# Don't override, as this is just a reference setup

copy_reference_files() {
  local log="$SBT_CONFIG/copy_reference_file.log"
  local ref="/usr/share/sbt/ref"

  if mkdir -p "${IVY_CONFIG}/cache" && mkdir -p "${SBT_CONFIG}" && touch "${log}" > /dev/null 2>&1 ; then
      cd "${ref}"
      local reflink=""
      if cp --help 2>&1 | grep -q reflink ; then
          reflink="--reflink=auto"
      fi
#      if [ -n "$(find "${IVY_CONFIG}/cache" -maxdepth 0 -type d -empty 2>/dev/null)" ] ; then
          # destination is empty...
          echo "--- Copying all files to ${IVY_CONFIG} at $(date)" >> "${log}"
          cp -rvn ${reflink} .ivy2/cache "${IVY_CONFIG}" >> "${log}"

          echo "--- Copying all files to ${SBT_CONFIG} at $(date)" >> "${log}"
          cp -rvn ${reflink} .sbt/* "${SBT_CONFIG}" >> "${log}"

##          echo "--- Copying all files to ${COURSIER_CONFIG} at $(date)" >> "${log}"
##          cp -rv ${reflink} v1/* "${COURSIER_CONFIG}" >> "${log}"
#      else
#          # destination is non-empty, copy file-by-file
#          echo "--- Copying individual files to ${IVY_CONFIG} at $(date)" >> "${log}"
#          find .ivy2/cache -type f -exec sh -eu -c '
#              log="${1}"
#              shift
#              reflink="${1}"
#              shift
#              for f in "$@" ; do
#                  if [ ! -e "${IVY_CONFIG}/${f}" ] || [ -e "${f}.override" ] ; then
#                      mkdir -p "${IVY_CONFIG}/$(dirname "${f}")"
#                      cp -rv ${reflink} "${f}" "${IVY_CONFIG}/cache/${f}" >> "${log}"
#                  fi
#              done
#          ' _ "${log}" "${reflink}" {} +
#          # FIXME: FALTA
#      fi
      echo >> "${log}"
  else
    echo "Can not write to ${log}. Wrong volume permissions? Carrying on ..."
  fi
}

owd="$(pwd)"
copy_reference_files
unset SBT_CONFIG
unset IVY_CONFIG

cd "${owd}"
unset owd

exec "$@"