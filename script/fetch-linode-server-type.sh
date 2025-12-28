#/bin/bash

cd "$(dirname "$0")"/.. || exit 1

curl --request GET \
  --url 'https://api.linode.com/v4/databases/types?page=1&page_size=100' \
  --header 'accept: application/json' | jq | tee linode-server-type.json
