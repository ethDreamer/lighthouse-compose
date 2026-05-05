ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG PROCESS_UID
ARG PROCESS_GID
ARG USER=boost

USER root
RUN getent group ${PROCESS_GID}  || addgroup -g ${PROCESS_GID} -S ${USER}
RUN getent passwd ${PROCESS_UID} || adduser  -S ${USER} -G ${USER} -u ${PROCESS_UID}

WORKDIR /home/${USER}/run
RUN chown -R ${PROCESS_UID}:${PROCESS_GID} /home/${USER}

USER ${PROCESS_UID}

ENTRYPOINT ["./execute.sh"]

