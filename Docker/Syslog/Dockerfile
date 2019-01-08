FROM alpine:latest

RUN apk add --update \
    openssh \
	rsyslog \
 && rm -rf /var/cache/apk/*
 
ADD rsyslog.conf /etc/rsyslog.conf
	
RUN echo -e """\
\n\
Host *\n\
    PasswordAuthentication yes\n\
    StrictHostKeyChecking no\n\
    UserKnownHostsFile=/dev/null\n\
""" >> /etc/ssh/ssh_config

RUN adduser -D jenkins && (echo "jenkins:jenkins" | chpasswd) && (echo "root:root" | chpasswd)
RUN chown -R jenkins:jenkins /home/jenkins

ADD docker-entrypoint.sh /usr/local/bin
RUN rm -rf /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_dsa_key

EXPOSE 22 
EXPOSE 514 514/udp 
VOLUME [ "/var/log", "/etc/rsyslog.d" ]

ENTRYPOINT ["docker-entrypoint.sh"]
