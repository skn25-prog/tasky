# Building the binary of the App
FROM golang:1.19 AS build

WORKDIR /go/src/tasky
COPY . .
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /go/src/tasky/tasky


FROM alpine:3.17.0 as release

ENV MONGODB_URI="mongodb://admin:admin@192.168.3.34:27017"
ENV SECRET_KEY="secret123"
WORKDIR /app
COPY wizexercise.txt .
COPY --from=build  /go/src/tasky/tasky .
COPY --from=build  /go/src/tasky/assets ./assets
EXPOSE 80
ENTRYPOINT ["/app/tasky"]


