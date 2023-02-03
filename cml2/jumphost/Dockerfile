FROM ciscotestautomation/pyats:latest-alpine

ENV JAVA_HOME "/usr"

RUN apk add --update \
    openjdk11 \
    git \
    openssh \
    openssh-keygen \
    openssl \
    libxml2-dev \
    libxslt-dev \
    sshpass \
    wget \
    curl
RUN pip3 install --upgrade pip
RUN apk --update add --virtual \
        .build-deps \
        gcc \
        libffi-dev \
        openssl-dev \
        build-base \
 && pip3 install --upgrade \
        cffi \
        ncclient \
        behave\
        cmlutils\
        pyats[full] \
        paramiko \
        ansible \
 && apk del \
        .build-deps \
 && rm -rf /var/cache/apk/*

RUN echo -e """\
\n\
Host *\n\
    PasswordAuthentication yes\n\
    StrictHostKeyChecking no\n\
    UserKnownHostsFile=/dev/null\n\
""" >> /etc/ssh/ssh_config
 
RUN adduser -D jenkins && (echo "jenkins:jenkins" | chpasswd) && (echo "root:root" | chpasswd)

ADD .ansible.cfg /home/jenkins/
ADD .profile /home/jenkins/

RUN chown -R jenkins:jenkins /home/jenkins

ADD docker-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
RUN rm -rf /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_dsa_key
EXPOSE 22 
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]
