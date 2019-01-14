#!/usr/bin/env python
# -- coding: utf-8 --
# Copyright 2017 Reactive Ops Inc.
#
# Licensed under the Apache License, Version 2.0 (the “License”);
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an “AS IS” BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import os
import sys
import glob
from setuptools import setup, find_packages

try:
    from setuptools import setup, find_packages
except ImportError:
    print("setup tools required. Please run: "
          "pip install setuptools).")
    sys.exit(1)

__version__ = '7.22.2'
__author__ = 'ReactiveOps, Inc.'


bin_files = glob.glob('./bin/*')

setup(name='rok8s-scripts',
      version=__version__,
      description='Bash scripts for deploying and managing applications in Kubernetes',
      author=__author__,
      author_email='reactive@reactiveops.com',
      url='http://reactiveops.com/',
      license='Apache2.0',
      include_package_data=True,
      install_requires=[],
      classifiers=[
          'Development Status :: 5 - Production/Stable',
          'Environment :: Console',
          'Intended Audience :: Developers',
          'Intended Audience :: Information Technology',
          'Intended Audience :: System Administrators',
          'License :: OSI Approved :: Apache License, Version 2.0',
          'Natural Language :: English',
          'Operating System :: POSIX',
          'Programming Language :: Python :: 2.6',
          'Programming Language :: Python :: 2.7',
          'Topic :: System :: Installation/Setup',
          'Topic :: System :: Systems Administration',
          'Topic :: Utilities',
      ],
      scripts=bin_files
      )
