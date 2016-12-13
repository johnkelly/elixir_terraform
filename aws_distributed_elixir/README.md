# Distributed Elixir

## How to Run the infrastructure
* Create an ssh key and upload it to AWS.
* Set the below env variables in your .bash_profile and source it.
* `cd packer`
* Run `packer validate elixir.json` fix any errors 
* Run `packer build elixir.json` to build an elixir AMI
* `cd terraform`
* Update variables.tf with your ami id
* Run `terraform plan` in the terraform directory and review the changes
* Run `terraform apply` in the terraform directory to review your changes
* **IMPORTANT** The default instance sizes in the files are t2.small and m3.large for spot instances. You will incur charges.
* Check AWS pricing to adjust according to your use case

## Required ENV Variables
* PACKER_meetup_aws_vpc_id
* TF_VAR_aws_access_key
* TF_VAR_aws_secret_key
* TF_VAR_aws_ssh_key_name
* PACKER_meetup_subnet_id

### Server 1
```
PUBLIC_HOSTNAME=$(curl http://169.254.169.254/latest/meta-data/public-hostname)
IEX_NAME="aws@$PUBLIC_HOSTNAME"

iex --name $IEX_NAME \
    --cookie monster \
    -r ~/hello.exs \
    --erl '-kernel inet_dist_listen_min 9100' \
    --erl '-kernel inet_dist_listen_max 9155'
Node.list
Node.connect :""
```

### Server 2
```
PUBLIC_HOSTNAME=$(curl http://169.254.169.254/latest/meta-data/public-hostname)
IEX_NAME="aws@$PUBLIC_HOSTNAME"

iex --name $IEX_NAME \
    --cookie monster \
    -r ~/hello.exs \
    --erl '-kernel inet_dist_listen_min 9100' \
    --erl '-kernel inet_dist_listen_max 9155'
Node.list
Node.connect :"server1"
Node.spawn_link :"server1", fn -> Hello.world end
```

### Server 3 - Spot Instance
```
PUBLIC_HOSTNAME=$(curl http://169.254.169.254/latest/meta-data/public-hostname)
IEX_NAME="aws@$PUBLIC_HOSTNAME"

iex --name $IEX_NAME \
    --cookie monster \
    -r ~/hello.exs \
    --erl '-kernel inet_dist_listen_min 9100' \
    --erl '-kernel inet_dist_listen_max 9155'

Node.list
Node.connect :"server1"
Node.spawn_link :"server2", fn -> Hello.world end
```

### Local
```
iex --name local \
    --cookie monster \
    --erl '-kernel inet_dist_listen_min 9100' \
    --erl '-kernel inet_dist_listen_max 9155'

Node.connect :""
Node.spawn_link :"", fn -> Hello.world end
```

### Connect on Instance (create a 2nd node)
```
PUBLIC_HOSTNAME=$(curl http://169.254.169.254/latest/meta-data/public-hostname)
IEX_NAME="someone@$PUBLIC_HOSTNAME"

iex --name $IEX_NAME \
    --cookie monster \
    -r ~/hello.exs \
    --erl '-kernel inet_dist_listen_min 9100' \
    --erl '-kernel inet_dist_listen_max 9155'
```
