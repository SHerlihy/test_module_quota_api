#!/bin/sh

terraform output -json endpoint_list | jq -c '.[]' | while read -r endpoint_obj; do
  endpoint=$(echo "$endpoint_obj" | jq -r '.endpoint')
    method=$(echo "$endpoint_obj" | jq -r '.method')
    api_key=$(echo "$endpoint_obj" | jq -r '.api_key')

echo "$method on $endpoint"

curl --fail --silent --show-error \
  --header "x-api-key: ${api_key}" \
  --request "$method" \
  "$endpoint"

echo "\n"
done

