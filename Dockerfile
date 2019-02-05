FROM alpine:3.5

RUN apk add --update \
    python \
    python-dev \
    py-pip \
    build-base \
    bash \
  && pip install --upgrade pip \
  && pip install watchdog \
  && rm -rf /var/cache/apk/*



WORKDIR /app

COPY ./app /app
RUN mkdir /app/statefiles

CMD ["python -u", "main.py"]
