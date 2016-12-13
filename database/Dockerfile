FROM openshift/postgresql-92-centos7

USER root

RUN echo "" >> /usr/share/container-scripts/postgresql/openshift-custom-postgresql.conf.template
RUN echo "max_wal_senders = 5" >> /usr/share/container-scripts/postgresql/openshift-custom-postgresql.conf.template
RUN echo "wal_level = hot_standby" >> /usr/share/container-scripts/postgresql/openshift-custom-postgresql.conf.template
RUN echo "archive_mode = on" >> /usr/share/container-scripts/postgresql/openshift-custom-postgresql.conf.template
RUN echo "archive_command = '/bin/true'" >> /usr/share/container-scripts/postgresql/openshift-custom-postgresql.conf.template

USER 26
