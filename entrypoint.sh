#!/bin/bash

/usr/bin/env python3 /opt/quickstart/manage.py makemigrations
/usr/bin/env python3 /opt/quickstart/manage.py migrate
/usr/bin/env python3 /opt/quickstart/manage.py runserver 0:8080
