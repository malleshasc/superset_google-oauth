#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
FROM centos:1

RUN useradd --user-group --create-home --no-log-init --shell /bin/bash superset

RUN yum -y upgrade python-setuptools
RUN yum -y install gcc gcc-c++ libffi-devel python-devel python-pip python-wheel openssl-devel libsasl2-devel     openldap-devel

RUN curl -sL https://rpm.nodesource.com/setup_10.x | bash - \
	&& yum install -y nodejs
RUN yum install -y wget

RUN mkdir -p /etc/superset

WORKDIR /home/superset

COPY requirements.txt .
COPY requirements-dev.txt .

RUN pip3 install -r requirements.txt -r requirements-dev.txt \
    && rm -rf /root/.cache/pip

RUN chown -R superset:superset /etc/superset

COPY --chown=superset:superset superset superset

ENV PATH=/home/superset/superset/bin:$PATH \
	PYTHONPATH=/home/superset/superset/:$PYTHONPATH

RUN rm -rf superset/static && wget -O /tmp/static.zip https://github.com/mhk4tech/superset_static/archive/master.zip && \
	unzip /tmp/static.zip -d /home/superset && mv /home/superset/superset_static-master/static /home/superset/superset/ && rm -rf /home/superset/superset_static-master

ENV GUNICORN_BIND=0.0.0.0:8088 \
    GUNICORN_LIMIT_REQUEST_FIELD_SIZE=0 \
    GUNICORN_LIMIT_REQUEST_LINE=0 \
    GUNICORN_TIMEOUT=60 \
    GUNICORN_WORKERS=2 \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PYTHONPATH=/etc/superset:/home/superset/superset:$PYTHONPATH \
    SUPERSET_REPO=apache/incubator-superset \
    SUPERSET_VERSION=0.34 \
    SUPERSET_HOME=/home/superset
ENV GUNICORN_CMD_ARGS="--workers ${GUNICORN_WORKERS} --timeout ${GUNICORN_TIMEOUT} --bind ${GUNICORN_BIND} --    limit-request-line ${GUNICORN_LIMIT_REQUEST_LINE} --limit-request-field_size ${GUNICORN_LIMIT_REQUEST_FIELD_SIZE}"

EXPOSE 8088
HEALTHCHECK CMD ["curl", "-f", "http://localhost:8088/health"]
CMD ["gunicorn", "superset:app"]
USER superset
