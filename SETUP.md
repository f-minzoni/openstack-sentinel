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

openstack --insecure domain create sentinel.example.com

vi /etc/sentinel/domain_map.json

apache2ctl restart

openstack --insecure role create --domain sentinel.example.com user
