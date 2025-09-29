FROM alpine:3.21

# Following instructions will be executed here
WORKDIR /usr/src/app

COPY hello.sh .

# Build commands
RUN touch additional.txt; chmod +x hello.sh

# Command to run when docker container is run
CMD ./hello.sh
