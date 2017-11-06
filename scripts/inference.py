#!/usr/bin/python
import os
import sys

from keystoneauth1 import session
from keystoneauth1.identity import v3
from keystoneclient.v3 import client

auth = v3.Password(auth_url='https://sentinel.example.com:5000/v3',
                   username='admin',
                   password='password',
                   user_domain_name='Default',
                   project_name='admin',
                   project_domain_name='Default')
session = session.Session(auth=auth,verify=False)
keystone = client.Client(session=session)
keystone.inference_rules.create(sys.argv[1], sys.argv[2])