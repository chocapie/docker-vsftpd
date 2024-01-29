FROM rockylinux:9

ARG USER_ID=14
ARG GROUP_ID=50
ARG USERNAME=ftp

LABEL Description="vsftpd Docker image based on RockyLinux 9. This is a fauria/vsftpd fork."

RUN yum -y update && yum clean all
RUN yum install -y \
	vsftpd \
	iproute && yum clean all

RUN usermod -u ${USER_ID} ${USERNAME}
RUN groupmod -g ${GROUP_ID} ${USERNAME}

ENV FTP_USER **String**
ENV FTP_PASS **Random**
ENV PASV_ADDRESS **IPv4**
ENV PASV_ADDR_RESOLVE NO
ENV PASV_ENABLE YES
ENV PASV_MIN_PORT 21100
ENV PASV_MAX_PORT 21110
ENV XFERLOG_STD_FORMAT NO
ENV LOG_STDOUT **Boolean**
ENV FILE_OPEN_MODE 0666
ENV LOCAL_UMASK 077
ENV REVERSE_LOOKUP_ENABLE YES
ENV PASV_PROMISCUOUS NO
ENV PORT_PROMISCUOUS NO

COPY vsftpd.conf /etc/vsftpd/
COPY vsftpd_virtual /etc/pam.d/
COPY run-vsftpd.sh /usr/sbin/

RUN chmod +x /usr/sbin/run-vsftpd.sh
RUN mkdir -p /home/vsftpd/
RUN chown -R ${USERNAME}:${USERNAME} /home/vsftpd/

VOLUME /home/vsftpd
VOLUME /var/log/vsftpd

EXPOSE 20 21

CMD ["/usr/sbin/run-vsftpd.sh"]
