#!/usr/bin/env python
import os
import sys


def main():
    #os.chdir(os.environ.get('ZSW_DIR'))
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "zsw.zsw.settings")

    from django.core.management import execute_from_command_line

    execute_from_command_line(sys.argv)
