# TIC-UNI2

> massar_t
> coquar_a


> Just a school project, nothing much.
> Please Prep'ETNA's students, no git-clone. Contact me I love to give advices.

## Summary

This project has the following containers:
- Haproxy server - proxy
- MariaDB servers - Built as replicas (master/slave)
- Two Wordpresses

### Haproxy

Haproxy redirects the requests trough either wp1 or wp2,
based on which one has the least connections open.

It has a /stats interface

Auth:
> haproxy:SomeStrongPassword


### MariaDB

Shared volume trough a container (no directory sharing)
Replica with master/slave properties

### Wordpresses

Two wordpresses sharing /var/www/html, trough a volume.

## Build

```bash
$ docker-compose up --build
```

## Usage

```bash
$ docker-compose up [-d]
```
