# syntax=docker/dockerfile:1

FROM golang:1.16-alpine AS build

# Install tools required for project

# Run `docker build --no-cache .` to update dependencies
RUN apk add --no-cache git
RUN go get github.com/golang/dep/cmd/dep

# List project dependencies with Gopkg.toml and Gopkg.lock

# These layers are only re-built when Gopkg files are updated

COPY Gopkg.lock Gopkg.toml /go/src/project/

WORKDIR /go/src/project/

# Install library dependencies
RUN dep ensure -vendor-only

# Copy the entire project and build it
# This layer is rebuilt when a file changes in the project directory
COPY . /go/src/project/
RUN go build -o /bin/project

# This results in a single layer image
FROM scratch
COPY --from=build /bin/project /bin/project
ENTRYPOINT ["/bin/project"]
CMD ["--help"]


Diff between RUN CMD Entrypoint

When you use a RUN command in your dockerfile, it always creates a new intermediate image layer on top of the previous ones

A CMD command is used to set a default command that gets executed once you run the Docker Container. 
In case you provide a command with the Docker run command, the CMD arguments get ignored from the dockerfile. 

An ENTRYPOINT command, unlike CMD, does not ignore additional parameters that you specify in your Docker run command. Executable
