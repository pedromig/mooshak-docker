# Mooshak Docker

## About
A Dockerfile for building a Docker image with Mooshak! 

Mooshak is a system for managing programming contests on the Web. Mooshak's basic features include automatic judging of submitted programs, answering to clarification questions about problem descriptions, reevaluation of programs, tracking printouts, among many others.

## Requirements
  * docker
  * docker-compose (optional)

## How To Run

### Using docker-compose (**TLDR**)

```sh
docker compose up -d
```

`OR`

```sh
docker-compose up -d
```

### Manually
```sh
# Build Image
docker build . -t mooshak

# Run Image (container)
docker run --rm -it \
  -p ${HTTP_PORT}:80 \
  -v ${MOOSHAK_DATA_VOLUME}:/home/mooshak/data \
  -v ${APACHE2_DATA_VOLUME}:/etc/apache2 \
  mooshak:latest
```

## Attaching a shell

```sh
docker exec -it <container> /bin/bash 
```

## Contributing 

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are greatly appreciated.

* Fork the Project
+ Create your Feature Branch (git checkout -b feature/AmazingFeature)
* Commit your Changes (git commit -m 'Add some AmazingFeature') Push to the Branch (git push origin feature/AmazingFeature) 
* Open a Pull Request

## License
This project is distributed under the [MIT](LICENSE) License.

## Collaborators 

* [Samuel Carinhas](https://github.com/SamuelCarinhas)