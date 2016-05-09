#! /bin/csh

# Before executing this script, you must install the
# drop-in data files:
if ! -e build-with-dropin-data/data/elasticsearch then
   echo "Install the drop-in data before running this script."
   exit 1
endif

echo "Building elasticsearch for Docker"
docker build -t preloaded-elasticsearch build-with-dropin-data/

echo "Saving the preloaded elasticsearch Docker image."
docker save -o preloaded-elasticsearch.tar preloaded-elasticsearch

echo "Compressing the saved elasticsearch Docker image."
# Use --force to overwrite any existing file:
gzip --force --best preloaded-elasticsearch.tar

echo "Done."
