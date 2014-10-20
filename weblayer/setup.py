# -*- coding: utf-8 -*-

from __future__ import unicode_literals
from setuptools import setup, find_packages


setup(
    name='zsw',
    version='0.1.0',
    author='Dawid Jaskot, Karolina Kowalik, Bartosz Łęcki',
    package_dir={'': b'src'},
    packages=find_packages(b'src'),
    entry_points='''
[console_scripts]
manage = zsw.manage:main
''',
    install_requires=[
        'Django',
    ]
)
