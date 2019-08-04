# Campo

Campo is an open source web forum application, it's design concept is lightweight, mobile friendly and easy to maintain.

Currently under active development, not recommended to deploy in production.

## Development

Campo use docker in development and deployment, it provides a consistent environment.

### Install Docker

Install Docker, visit https://docs.docker.com/install/ .

### Install docker-sync

Campo use docker-sync to speed up docker volume IO. install Docker-sync:

```console
$ gem install docker-sync
```

### Clone repo

```console
$ git clone https://github.com/getcampo/campo.git
$ cd campo
```

### Start dev server

Start docker sync:

```console
$ docker-sync start
```

Setup dev environment:

```console
$ docker-compose run web bin/setup
```

Start docker services:

```console
$ docker-compose up
```

Visit http://localhost:3000/ .

### console

```console
$ docker-compose run web bash
```

You can run other rails command in this console, for example `bin/rails test`.

## License

MIT License.
