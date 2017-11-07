## BUILD & RUN 
docker-compose build

docker-compose up -d mysql rabbit

docker-compose up -d keystone

docker-compose exec keystone bash

## SETUP ENV

export OS_TOKEN=xyz  
export OS_URL=https://sentinel.example.com:35357/v3  
export OS_IDENTITY_API_VERSION=3  

## BOOTSTRAP

keystone-manage bootstrap --bootstrap-password password --bootstrap-admin-url https://sentinel.example.com:35357/v3/ --bootstrap-internal-url https://sentinel.example.com:35357/v3/   --bootstrap-public-url https://sentinel.example.com:5000/v3/ --bootstrap-region-id RegionOne

## ADMIN ENV

unset OS_TOKEN OS_URL  
export OS_USERNAME=admin  
export OS_PASSWORD=password  
export OS_PROJECT_NAME=admin  
export OS_USER_DOMAIN_NAME=Default  
export OS_PROJECT_DOMAIN_NAME=Default  
export OS_AUTH_URL=https://sentinel.example.com:35357/v3  
export OS_IDENTITY_API_VERSION=3  

## CONFIG

openstack --insecure domain create my.trusted.idp.com

vi /etc/sentinel/domain_map.json

apache2ctl restart

openstack --insecure role create --domain my.trusted.idp.com user

## USAGE

Via python-keystoneclient:  

```python
from keystoneauth1 import session
from keystoneauth1.identity import v3
from keystoneclient.v3 import client

auth = v3.Password(auth_url='https://sentinel.example.com:4567/identity/v3')
session = session.Session(auth=auth,
                          verify='/etc/sentinel/ssl/easy-rsa/easyrsa3/pki/ca.crt',
                          cert=('/etc/sentinel/ssl/easy-rsa/easyrsa3/pki/issued/127.0.0.1.crt',
                           '/etc/sentinel/ssl/easy-rsa/easyrsa3/pki/private/127.0.0.1.key'))
identity = client.Client(session=session)

project = identity.projects.create(name="project1", description="federated project",
domain="my.trusted.idp.com", enabled=True)

user = identity.users.create(name="user1", password="password", enabled=True)

group = identity.groups.create(name="group1")

identity.users.add_to_group(user, group)

role = identity.roles.list()[0] 

identity.roles.grant(role=role,group=group,project=project)
```
