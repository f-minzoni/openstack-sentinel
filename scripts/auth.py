#!/usr/bin/python

from keystoneauth1 import session
from keystoneauth1.identity import v3
from keystoneclient.v3 import client

auth = v3.Password(auth_url='https://sentinel.example.com:4567/identity/v3')
session = session.Session(auth=auth,
                          verify='/etc/sentinel/ssl/easy-rsa/easyrsa3/pki/ca.crt',
                          cert=('/etc/sentinel/ssl/easy-rsa/easyrsa3/pki/issued/127.0.0.1.crt',
                           '/etc/sentinel/ssl/easy-rsa/easyrsa3/pki/private/127.0.0.1.key'))
identity = client.Client(session=session)

users = identity.users.list()
