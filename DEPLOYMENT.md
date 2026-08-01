# Deployment

The application is built with [Railpack](https://railpack.com), which replaces the buildpack
configuration it previously relied on. Railpack detects the `Gemfile`, installs Ruby with mise,
runs `bundle install` and produces an OCI image — there is no Dockerfile to maintain. Asset
precompilation is skipped automatically because this is an API-only application.

Any host that supports Railpack (or the Railpack CLI directly) can build and run it.

## What lives in the repository

| File | Role |
| --- | --- |
| `railpack.json` | Build configuration: Ruby provider, extra runtime apt packages, default `RAILS_ENV`. |
| `Procfile` | Start commands. Railpack uses the `web` line; the worker overrides it. |

The Ruby provider installs `libyaml-dev` and `libjemalloc2` unconditionally, `libpq-dev` because of
the `pg` gem, and `libvips-dev` because `ruby-vips` (pulled in by `image_processing`) appears in the
lockfile. On top of that `railpack.json` adds:

- `curl`, so the host can run health checks from inside the container;
- `libyaml-dev` and `libvips-dev`, redundant today but pinned on purpose: the provider detects them
  with a substring match on the `Gemfile`/`Gemfile.lock`, so a dependency change could silently drop
  `libvips-dev` and break Active Storage variants at runtime.

The `"..."` entry in `deploy.aptPackages` is required — without it the list *replaces* the packages
Railpack detected instead of extending them.

Do **not** add `deploy.startCommand` to `railpack.json`: config-file values win over the
`RAILPACK_START_CMD` environment variable, which is how hosts expose a per-application start
command override — and the worker relies on that override.

## Processes

- **web** — `bundle exec rails db:prepare && bundle exec puma -C config/puma.rb`, listening on
  `$PORT` (`3000` by default). `db:prepare` loads the schema and seeds on the very first boot,
  then only migrates.
- **worker** — `bundle exec good_job start`. Run it as a separate instance from the same image,
  with the start command overridden via `RAILPACK_START_CMD` (or the host's equivalent field).

Keeping migrations in the web start command, and not the worker's, means they never run twice
concurrently. Railpack has no `release`/`postdeploy` hook, which is why they live there; if your
host offers a pre-deployment step, `bundle exec rails db:prepare` can move there instead — drop it
from the `Procfile` in that case.

## Health check

`GET /up` returns `200` when the application booted correctly. It is excluded from the
`force_ssl` redirect so it can be probed over plain HTTP from inside the container.

## Environment variables

The web and worker instances need the same set.

| Variable | Required | Notes |
| --- | --- | --- |
| `DATABASE_URL` | yes | PostgreSQL 17 connection URL. |
| `SECRET_KEY_BASE` | yes | Keep it stable across deployments — changing it invalidates every signed cookie and Devise reset token. |
| `RAILS_DEFAULT_HOST` | yes | Public hostname. Used for absolute URLs in routes and mailers. |
| `GOOD_JOB_USERNAME` | yes | Basic auth for the `/good_job` dashboard. The initializer raises if it is unset. |
| `GOOD_JOB_PASSWORD` | yes | Same. |
| `SCALEWAY_ACCESS_KEY_ID` | yes | Active Storage. |
| `SCALEWAY_ACCESS_KEY_SECRET` | yes | Active Storage. |
| `SCALEWAY_BUCKET_NAME` | yes | Active Storage. |
| `SCALEWAY_ENDPOINT` | yes | Active Storage. |
| `SCALEWAY_REGION` | yes | Active Storage. |
| `SMTP_FROM` | no | Sender address for Devise mailers (defaults to `test@xanyah.dev`). |
| `VAT_LAYER_API_KEY` | no | Only used by the `vat_rates:fetch` rake task. |
| `RAILS_ENV` | no | Defaults to `production` via `railpack.json`. |
| `RAILS_MAX_THREADS` | no | Puma threads and Active Record pool size, defaults to `5`. |
| `RAILS_LOG_LEVEL` | no | Defaults to `info`. |
| `PORT` | no | Puma falls back to `3000`. |

TLS is expected to be terminated by a reverse proxy forwarding `X-Forwarded-Proto`;
`config.force_ssl` redirects plain HTTP. Note that the `/good_job` dashboard is reachable on the
public domain, protected only by basic auth.

## Building locally

```sh
railpack build .
```
