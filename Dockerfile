FROM golang:1.15-alpine3.14 as builder

LABEL maintainer="cncf-falco-dev@lists.cncf.io"

RUN apk add --no-cache make bash git build-base
RUN export CXX=/usr/local/go/pkg/tool/linux_arm64/link
RUN  export LD_LIBRARY_PATH=/go/bin:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/go/pkg/tool/linux_arm64/link${LD_LIBRARY_PATH}
WORKDIR /event-generator
COPY . .

RUN make

FROM alpine:3.14

COPY --from=builder /event-generator/event-generator /bin/event-generator

# Need to have this for helper.RunShell
RUN apk add bash

# Need to have this for syscall.WriteBelowRpmDatabase
RUN mkdir -p /var/lib/rpm/

ENTRYPOINT ["/bin/event-generator"]
