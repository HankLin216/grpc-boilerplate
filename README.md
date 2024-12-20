# grpc-boilerplate
## subtitle
---
## Requirements
- protoc
- docker (better have)

## Features

- one
- two
- three

## Tech

TODO

- [Something] - for Something!

## Installation
TODO...

## Plugins

| Plugin | README.md |
| ------ | ------ |
| Some | Thing |

## Development
- VSCode Run Task for Windows:
  - Search protos:
    - Search Proto Files (win)
  - Generate proto:
    - Specific folder: Generate Proto Files (win)  
    - API folder: Generate API Proto Files (win)
  - Dependency injection
    - Generate Wire

- Makefile for Linux:
  - Install golang, protoc and related tools: make install
  - Generate proto:
    - generate api proto: make api
    - generate conf proto: make config
  - Dependency injection
    - make generate

#### Building for source
- VSCode Run Task for windows:
  - Build (win)
    - Select: Development, Production
- Makefile for Linux:
  - Build Development: make dev-build
  - Build Production: make build

## Docker
- VSCode Run Task for windows:
  - Build Image (win)
    - Select: Development, Production
  - Run Image (win)
    - Select: Development, Production
- Makefile for Linux:
  - Build Development Image: make dev-build-image
  - Build Production: make build-image
  - Run Development Image: make run-image
  - Run Production Image: make dev-run-image

## Docker-Compose
- Makefile for Linux:
  - ELK Stack with Production: docker-compose
  - ELK Stack with Development: dev-docker-compose
---
## License

This program is open-sourced software licensed under the [MIT license](./LICENSE).