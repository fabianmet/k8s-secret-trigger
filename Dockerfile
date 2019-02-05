FROM golang:latest 
RUN mkdir /app 
ADD . /app/ 
WORKDIR /app 
RUN go get -d -v github.com/fsnotify/fsnotify
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .


FROM scratch
COPY --from=0 /app/main .
CMD ["/main"]
