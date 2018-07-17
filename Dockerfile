FROM nginx:stable-alpine
LABEL maintainer="dat.tran@idealo.de"

RUN apk --update --repository http://dl-4.alpinelinux.org/alpine/edge/community add \
    bash \
    git \
    curl \
    ca-certificates \
    bzip2 \
    unzip \
    sudo \
    libstdc++ \
    glib \
    libxext \
    libxrender \
    tini \
    supervisor \
    && curl -L "https://github.com/andyshinn/alpine-pkg-glibc/releases/download/2.25-r0/glibc-2.25-r0.apk" -o /tmp/glibc.apk \
    && curl -L "https://github.com/andyshinn/alpine-pkg-glibc/releases/download/2.25-r0/glibc-bin-2.25-r0.apk" -o /tmp/glibc-bin.apk \
    && curl -L "https://github.com/andyshinn/alpine-pkg-glibc/releases/download/2.25-r0/glibc-i18n-2.25-r0.apk" -o /tmp/glibc-i18n.apk \
    && apk add --allow-untrusted /tmp/glibc*.apk \
    && /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib \
    && /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8 \
    && rm -rf /tmp/glibc*apk /var/cache/apk/*

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    curl https://repo.continuum.io/miniconda/Miniconda3-4.3.27-Linux-x86_64.sh -o ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -f -b -p /opt/conda && \
    rm ~/miniconda.sh

ENV PATH /opt/conda/bin:$PATH

RUN mkdir /run/nginx/ \
    && mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bak

ADD conf/nginx.conf /etc/nginx/conf.d/
ADD conf/supervisor.ini /etc/supervisor.d/

COPY environment.yml /
RUN conda env create -f=environment.yml -n myapp
ENV PATH /opt/conda/envs/myapp/bin:$PATH

COPY ./src/ /app
WORKDIR /app

# support running as arbitrary user which belogs to the root group
RUN chmod -R 777 /var/cache/nginx /var/run /var/log/
RUN chmod -R 777 /etc/supervisord.conf
RUN chmod -R 777 /app
RUN sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf

EXPOSE 8081

USER 1001

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
