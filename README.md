# Campo

Campo is an open source web forum application, it's design concept is lightweight, mobile friendly and easy to maintain.

Currently under active development, not recommended to deploy in production.

## Development

Campo use docker in development and deployment, it provides a consistent environment.

### Install Docker

Visit https://www.docker.com/community-edition and install docker for you operating system.

### Clone repo

```console
$ git clone https://github.com/getcampo/campo.git
$ cd campo
```

### Run dev server

```console
$ docker-compose up
```

Visit http://localhost:3000/ .

## Deployment

**Work in progress**

### Docker Compose

#### Install docker

Visit https://www.docker.com/community-edition and install docker on your server.

#### Create config

Create file `docker-compose.yml` with this content:

```
version: '3.0'
services:
  web:
    image: getcampo/campo:latest
    command: bin/rails server -b 0.0.0.0
    ports:
      - 3000:3000
    env_file: .env
    depends_on:
      - postgres
      - redis
  worker:
    image: getcampo/campo:latest
    command: sidekiq
    env_file: .env
    depends_on:
      - postgres
      - redis
  postgres:
    image: postgres:10
  redis:
    image: redis:3.2
```

This config setup all servive require by campo, including web server, worker, database, etc.

Create file '.env' in same directory with this content:

```
RAILS_ENV=production
# You should generate your secret key here
SECRET_KEY_BASE=xxx
DATABASE_URL=postgres://postgres@postgres/campo_production
REDIS_URL=redis://redis:6379/0
```

All ENV vars can be found in [.env](.env)

### Setup and Start

Run this command:

```console
$ docker-compose pull
```

Wait for pull complete, then run this command:

```console
$ docker-compose run web bin/setup
$ docker-compose up -d
```

Open http://{YOUR_SERVER_IP}:3000, campo is running.

TODO: SSL and load balance document.

## License

MIT License.
