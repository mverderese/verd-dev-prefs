#!/bin/bash

if [[ -z "$1" ]]; then
    echo "Usage: $0 ENV [HOST_INDEX]"
    exit 1
fi

env=$1
key_name=$3
filter="Name=tag:environment,Values=$env"
query="Reservations[].Instances[?PublicDnsName!=\`\`].[Tags[?Key==\`class\`].Value|[0], PublicDnsName, InstanceId][]"

cmd="aws ec2 describe-instances --filters '$filter' --query '$query' --output text | column -t | sort | awk '{printf \"%d\t%s\n\", NR, \$0}'"

if [[ -n "$2" ]]; then
    hostname=$(eval "$cmd" | head -"$2" | tail -1 | awk '{print $3}')
    exec ssh -A -i ~/.ssh/${key_name:-renew_${env}.pem} ubuntu@${hostname}
else
    eval "$cmd"
fi

