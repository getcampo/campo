# Campo

Campo is an open source web forum application, it's design concept is lightweight, mobile friendly and easy to maintain.

Currently under active development, not recommended to deploy in production.

## Development

Campo use docker in development and deployment, it provides a consistent environment.

### Install Docker

Visit https://www.docker.com/community-edition and install docker for you operating system.

### Install docker-sync

```console
$ gem install docker-sync
```

### Clone repo

```console
$ git clone https://github.com/getcampo/campo.git
$ cd campo
```

### Run dev server

Start docker sync:

```console
$ docker-sync start
```

Open a new console and run:

```console
$ docker-compose run web bin/setup
```

Start docker services:

```console
$ docker-compose up
```

Visit http://localhost:3000/ .

## License

MIT License.
