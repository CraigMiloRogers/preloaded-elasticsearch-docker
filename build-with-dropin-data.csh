#! /bin/csh

# Before executing this script, you must install the
# drop-in data files:
if ! -e build-with-dropin-data/data/elasticsearch then
   echo "Install the drop-in data before running this script."
   exit 1
endif

docker build -t preloaded-elasticsearch build-with-dropin-data/

# Use --force to overwrite any existing file:
gzip --force --best preloaded-elasticsearch.tar
