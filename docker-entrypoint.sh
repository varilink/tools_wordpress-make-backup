# ------------------------------------------------------------------------------
# docker-entrypoint.sh
# ------------------------------------------------------------------------------

# This script prepares backup files locally that can be used by the wordpress
# tool to restore to a copy of the website running on the desktop. It sources
# the files from a run of the "WordPress - Restore" tool.

# ------

# Validate that the SUBDOMAIN and DOMAIN environment variables have been
# provided.
if [[ -z "${SUBDOMAIN}" ]]; then

    echo                                                                       \
      'You must set the SUBDOMAIN environment variable using the '             \
      '"-e KEY=VAL" argument to the docker-compose command2'
    exit

else

    if [[ -z "${DOMAIN}" ]]; then

        echo                                                                   \
          'You must set the DOMAIN environment variable for the '              \
          'wp-make-backup service in your docker-compose.yml file'

    fi

fi

if [ -f "database.sql.gz" -a -f "html.tar.gz" ]; then

  echo "Found an existing backup, moving it into a subfolder before proceeding"
  # We generate a hash based on the current timestamp to ensure uniqueness
  random_string=$(date +%s%N | md5sum | cut -c 1-16)
  mkdir $random_string
  mv database.sql.gz html.tar.gz $random_string/.
  echo "The existing backup has been moved to the $random_string subfolder"

fi

# Copy the restored files locally.
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null                \
  -r hub:/tmp/bacula-restores/wp-sites/${SUBDOMAIN}.${DOMAIN}/. .

# Tar and/or zip the files.
gzip -cvf $(ls *.sql) > database.sql.gz
tar -czvf html.tar.gz html

# Remove the local copy of original files prior to the tar and/or zip.
rm -rf html
rm $(ls *.sql)

# Remove the restored files from the hub host.
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null hub << EOF
sudo rm -rf /tmp/bacula-restores/wp-sites/${SUBDOMAIN}.${DOMAIN}
EOF
