# Clearance

[![Build Status](https://travis-ci.org/tobinquadros/clearance.svg?branch=master)](https://travis-ci.org/tobinquadros/clearance)

A simple Go app investigating the methods behind providing user access. (WIP)

Current working on support for:
- user database (postgres)

Future extensions:
- ldap
- OAuth

# Setup

Spin up a local development environment with docker-compose:
```
make local-dev
```

Run tests:
```
make tests
```

Create fresh build of app container and run health-check:
```
make check
```

Clean up the Docker environment:
```
make clean
```

**NOTE:** There are other targets recipes available in the [Makefile](Makefile)
