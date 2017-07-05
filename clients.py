# Copyright 2017 DataCentred Ltd
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.

"""
Simple wrappers around OpenStack client libraries
"""

from keystoneauth1 import session
from keystoneauth1.identity import v3
from keystoneclient.v3 import client as kc
from novaclient import client as nc
import pecan

class Clients(object):
    """Obtain various OpenStack clients"""

    @staticmethod
    def _session():
        """Creates an OpenStack session from configuration data"""
        conf = pecan.request.context['conf']
        auth = v3.Password(auth_url=conf.get('keystone_authtoken', 'auth_uri'),
                           username=conf.get('keystone_authtoken', 'username'),
                           password=conf.get('keystone_authtoken', 'password'),
                           user_domain_name=conf.get('keystone_authtoken', 'user_domain_name'),
                           project_name=conf.get('keystone_authtoken', 'project_name'),
                           project_domain_name=conf.get('keystone_authtoken', 'project_domain_name'))
        return session.Session(auth=auth)

    @classmethod
    def keystone(cls):
        """Creates a Keystone client"""
        return kc.Client(session=cls._session())

    @classmethod
    def nova(cls):
        """Creates a Nova client"""
        return nc.Client(2, session=cls._session())

# vi: ts=4 et:
