# Clearance

[![Build Status](https://travis-ci.org/tobinquadros/clearance.svg?branch=master)](https://travis-ci.org/tobinquadros/clearance)

A simple Go app investigating methods for providing user access. (WIP)

Currently working on support for:
- user database (PostgreSQL)

Possible future extensions:
- LDAP
- OAuth 2.0

# Setup

Spin up the full local development environment with docker-compose:

```
make local-dev
```

Re-compile the binary and restart the container:

```
make restart
```

Run tests:

```
make tests
```

Creates a new build of the docker image, starts a container from it,
continuously runs `curl http://localhost:8000/health-check` until it's
successful or it times out (30 sec), then cleans up running containers and
dangling images:

```
make check
```

Clean up the Docker environment:

```
make clean
```

**NOTE:** There are other targets recipes available in the [Makefile](Makefile)
