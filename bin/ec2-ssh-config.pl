#!/usr/bin/env -S perl -n

use v5.30;
use JSON::PP;
my %j = %{JSON::PP->new->decode($_)};

say <<"EOS";

# $j{name}
match host $j{id},$j{name},$j{ip} exec "aws ec2-instance-connect send-ssh-public-key --instance-id $j{id} --availability-zone $j{az} --instance-os-user ubuntu --ssh-public-key file://%d/.ssh/id_rsa.pub"

Host $j{id} $j{name}
    Hostname                 $j{ip}
    user                     ubuntu
    PreferredAuthentications publickey
    IdentityFile             ~/.ssh/id_rsa.pub
    ProxyCommand             sh -c "aws ssm start-session --target $j{id} --document-name AWS-StartSSHSession --parameters 'portNumber=%p'"
EOS
