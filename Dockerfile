FROM python:3.7.11-alpine
MAINTAINER Andrew Fitzpatrick

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /requirements.txt

# permanent dependencies
RUN apk add --update --no-cache postgresql-client jpeg-dev

# dependencies used just for inatalling PIP package
RUN apk add --update --no-cache --virtual .tmp-build-deps \
        gcc libc-dev linux-headers postgresql-dev musl-dev \
        zlib zlib-dev
RUN pip install -r /requirements.txt
RUN apk del .tmp-build-deps

RUN mkdir /app
WORKDIR /app
COPY ./app /app

RUN mkdir -p /vol/web/media
RUN mkdir -p /vol/web/static
RUN adduser -D user
RUN chown -R user:user /vol/
RUN chmod -R 755 /vol/web
USER user
