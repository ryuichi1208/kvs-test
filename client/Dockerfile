FROM alpine:3.12

ENV PATH $PATH:/usr/local/tools/
RUN apk --no-cache add \
	busybox-extras \
	curl \
	gcc \
	libc-dev \
	libewf-dev \
	make \
	tzdata \
	perl \
	perl-app-cpanminus \
	perl-dev \
	wget \
	&& cpanm String::Random \
	&& cpanm Cache::Memcached::Fast
