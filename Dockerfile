FROM golang AS build-env

MAINTAINER yanorei32

RUN go get -u github.com/labstack/echo/ && \
	go get -u github.com/labstack/echo/middleware

COPY ./src /work/

RUN CGO_ENABLED=0 \
	GOOS=linux \
	GOARCH=amd64 \
	go build \
		-ldflags "-s -w" \
		-o /work/app \
		/work/main.go

FROM alpine
RUN apk --no-cache add ca-certificates
COPY --from=build-env /work/app /usr/local/bin/app

ENTRYPOINT ["/usr/local/bin/app"]


