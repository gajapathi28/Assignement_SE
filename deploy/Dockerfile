#base os image
FROM centos:7.5
#install gcc, libtools,latest release updates
RUN yum -y install gcc libtool && \
    yum -y install epel-release && \
    yum clean all
# install latest package 
ENV GOLANG_VERSION 1.18.4
ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256 4525aa6b0e3cecb57845f4060a7075aafc9ab752bb7b6b4cf8a212d43078e1e4
RUN curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
    && echo "$GOLANG_DOWNLOAD_SHA256  golang.tar.gz" | sha256sum -c - \
	&& tar -C /usr/local -xzf golang.tar.gz \
	&& rm golang.tar.gz
ENV PATH /usr/local/go/bin:$PATH
WORKDIR /root
# pass 2 different arguments to the entrypoint which can be excuted based the arguments
ARG MY_GO
ARG MY_CPP
ENV MY_GO=$MY_GO \
         MY_CPP=$MY_CPP
ENTRYPOINT echo ${MY_GO} ${MY_CPP}
ADD ${ARG}.runme /code/${MY_GO} ${MY_CPP}
# run the executable
CMD [${"ARG".runme}]
