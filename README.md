# BigBlueButton Docker

[Changelog](CHANGELOG.md) | [Issues](https://github.com/alangecker/bigbluebutton-docker/issues)

## Features
- Easy installation
- Greenlight included
- TURN server included
- Fully automated HTTPS certificates
- Runs on almost any major linux distributon (Debian, Ubuntu, CentOS,...)
- Full IPv6 support

## Install
1. Install docker-ce & docker-compose
    1. follow instructions
        * Debian: https://docs.docker.com/engine/install/debian/
        * CentOS: https://docs.docker.com/engine/install/centos/
        * Fedora: https://docs.docker.com/engine/install/fedora/
        * Ubuntu: https://docs.docker.com/engine/install/ubuntu/
    2. Ensure docker works with `$ docker run hello-world`
    3. Install docker-compose: https://docs.docker.com/compose/install/
    4. Ensure docker-compose works: `$ docker-compose --version`
2. Clone this repository
   ```sh
   $ git clone --recurse-submodules https://github.com/alangecker/bigbluebutton-docker.git bbb-docker
   $ cd bbb-docker
   ```
3. Run setup: for creating .env file
   ```bash
   $ ./scripts/setup
   ```
   Please modify .env file if you need. 
   If you use greenlight, add "GREENLIGHT_ENDPOINT=https://www.example.com/bigbluebutton/api" in .env file.
   Please also check the following:https://docs.bigbluebutton.org/dev/api.html#overview
4. Start each container by implementing the following docker-compose commands separately: 
    ```bash
    $ docker-compose up -d
    $ docker-compose -f docker-compose.greenlight.yml up -d
    $ docker-compose -f ..... up -d
    $ .....
    ```
5. If you use greenlight, after starting greenlight containers, create an admin account:
    ```bash
    $ ./scripts/compose exec greenlight bundle exec rake admin:create
    ```

## How-To's
- [Upgrade](docs/upgrading.md)
- [Behind NAT](docs/behind-nat.md)
- [BBB-Docker Development](docs/development.md)
- [Integration into an existing web server](docs/existing-web-server.md)

## Special thanks to
- @dkrenn, whos dockerized version (bigbluebutton#8858)(https://github.com/bigbluebutton/bigbluebutton/pull/8858) helped me a lot in understand and some configs.
