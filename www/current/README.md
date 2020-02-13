# README

## Quick Setup

```shell
ruby bin/setup
```

## Deployment

```shell
# Using integration as an example:
cap integration deploy

# Used to generate documentation from the tests and then copy them to a shared
# folder on integration which is symlinked to all the other apps. This provides
# the API documentation for Apitome.
RAILS_ENV=test bin/rails docs:generate
scp -r docs/api deploy@rideflag-integration.devbbq.com:www/shared/docs
```
