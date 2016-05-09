#! /bin/csh

docker build -t elasticsearch-for-loading-data build-for-loading-data/
docker run -d -p 9200:9200 -p 9300:9300 elasticsearch-for-loading-data

# Sleep to allow the elasticsearch containier to initialize:
sleep 10

# Check the status of the elasticsearch container:
curl 'http://localhost:9200/?pretty'
curl 'http://localhost:9200/_cluster/health?pretty'

# Load data.  For example:
#
# curl -X DELETE ${INDEX_URL}
# echo
# curl -X PUT -H ${JSON_CONTENT:q} --data @- ${INDEX_URL} <<EOF
# {
#  "settings": {
#   "number_of_shards": 1,
#   "number_of_replicas": 0
#  }
# }
# EOF
# echo
# Load JSON lines into the index, under the type "data":
# foreach jsonLine ("`cat ${TOPIC}.jl`")
#   curl -X POST -H ${JSON_CONTENT:q} --data ${jsonLine:q} ${INDEX_URL}/data/
#   echo
# end
#
# You MUST edit this script to load data.
echo "Edit this script to load data."
exit 1

# Check the status of the elasticsearch container. There should be more active
# shards now:

curl 'http://localhost:9200/?pretty'
curl 'http://localhost:9200/_cluster/health?pretty'

# Stop the container, commit it to an image, save and compress the image;

set CONTAINER=`docker ps -a | fgrep elasticsearch-for-loading-data | cut -f 1 -d " "`

if ${#CONTAINER} != 1 then
  echo "Unable to find the elastic search container."
  exit 1
endif

docker stop ${CONTAINER}
docker commit ${CONTAINER} preloaded-elasticsearch

docker save -o preloaded-elasticsearch.tar preloaded-elasticsearch

# Use --force to overwrite any existing file:
gzip --force --best preloaded-elasticsearch.tar
