FROM centos:8

COPY requirements.txt ./

RUN dnf -y install python3 && pip3 --no-cache-dir install -r requirements.txt && dnf -y clean all

COPY quickstart /opt/quickstart/
COPY entrypoint.sh /

WORKDIR /opt/quickstart/

ENTRYPOINT [ "/entrypoint.sh" ]
