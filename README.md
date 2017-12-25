# Requires:

- Ansible
- Terraform

## Provision infrastructure

```
cd terraform
terraform plan
terraform apply
```

## Configure OpenVPN

Copy `roles/ca/files/pki_vars.sample` to `roles/ca/files/pki_vars`. Update `pki_vars` with your desired values for your Certificate Authority.

Next, run `ansible-playbook` to configure OpenVPN on your ec2 instance.

Where `1.1.2.2` is the IP address of the ec2 instance brought up in the previous step:

```
ansible-playbook \
    -e 'build_ca=true' \
    -e 'build_clients=true' \
    -e '{"client_names": ["ryan"]}' \
    -i "1.1.2.2," \
    -u ec2-user \
    provision.yml
```

## Provision keys and certs for more clients

ansible-playbook \
    -e 'build_clients=true' \
    -e '{"client_names": ["another_client", "and_another"]}' \
    -i "1.1.2.2," \
    -u ec2-user \
    provision.yml

## More information

Based on: [How to make your own free VPN with Amazon Web Services](https://www.comparitech.com/blog/vpn-privacy/how-to-make-your-own-free-vpn-using-amazon-web-services/)

See the blog post for information regarding configuration of your VPN client.
