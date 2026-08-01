# Xanyah API


## Installation

- Clone this repo
- Copy `.env.example` into `.env` (or `.env.test` depending on your environments)
- Install gems: `bundle install`
- Install packages: `yarn` or `npm install`
- Set up your database:
  - Create it with Docker-Compose by running `docker-compose up`
  - Run the migrations: `rake db:migrate`
- You're all set ! :tada:

## Generating docs

- `yarn docs`

## Deployment

Built with [Railpack](https://railpack.com) — no Dockerfile needed. Deployable on any
Railpack-compatible host; see [DEPLOYMENT.md](DEPLOYMENT.md) for the processes, health check
and environment variables.

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template?template=https%3A%2F%2Fgithub.com%2Fxanyah%2Fapi)

## Our stack

- Ruby on Rails

## Contributing

:+1::tada: Pull requests are welcome ! :tada::+1:
