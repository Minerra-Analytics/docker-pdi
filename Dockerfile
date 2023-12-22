FROM openjdk:8
# LABEL org.opencontainers.image.authors="Andre Pereira andrespp@gmail.com"
LABEL org.opencontainers.image.authors="Herman Tan hermandr@gmail.com"

# Set Environment Variables
# PDI Related
ENV PDI_VERSION=9.2 
ENV PDI_BUILD=9.2.0.0-290 
ENV	PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/data-integration 
ENV	KETTLE_HOME=/data-integration 
# JDBC Driver versions
ENV	MARIADB_JDBC_VERSION=2.3.0
ENV POSTGRES_JDBC_VERSION=42.2.5
# Git Related
ARG GIT_USER
ARG GIT_PASS
ARG GIT_ORG
ARG GIT_REPO

# Copy repo files into /jobs

# Install git
RUN apt-get install -y git

# Download PDI
RUN wget --progress=dot:giga https://privatefilesbucket-community-edition.s3.us-west-2.amazonaws.com/${PDI_BUILD}/ce/client-tools/pdi-ce-${PDI_BUILD}.zip \
	&& unzip -q *.zip \
	&& rm -f *.zip 

# Aditional Drivers
WORKDIR $KETTLE_HOME

# Mariadb Driver
RUN cd lib \
 && wget https://repo.mavenlibs.com/maven/org/mariadb/jdbc/mariadb-java-client/${MARIADB_JDBC_VERSION}/mariadb-java-client-${MARIADB_JDBC_VERSION}.jar 

# Postgres Driver
RUN cd lib \
 && wget https://repo1.maven.org/maven2/org/postgresql/postgresql/${POSTGRES_JDBC_VERSION}/postgresql-${POSTGRES_JDBC_VERSION}.jar

# Clone the repo using the credentials in build-arg and place the files in the jobs folder
RUN mkdir /jobs \
 && git clone https://${GIT_USER}:${GIT_PASS}@github.com/${GIT_ORG}/${GIT_REPO}.git \
 && mv ${GIT_REPO} /jobs

# First time run
RUN pan.sh -file ./plugins/platform-utils-plugin/samples/showPlatformVersion.ktr \
 && kitchen.sh -file samples/transformations/files/test-job.kjb

# Install xauth
RUN apt-get update && apt-get install -y xauth

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["help"]

