# Railpack reads this file to pick the container start command. It only knows
# about `web` (used by default) and `worker` (fallback when there is no `web`);
# there is no `release`/`postdeploy` hook, so the web process runs migrations on
# boot. `db:prepare` loads the schema and seeds on the very first deploy, then
# migrates on every subsequent one.
#
# The worker runs as a separate instance of the same image, with its start
# command overridden to the `worker` line below (RAILPACK_START_CMD).
web: bundle exec rails db:prepare && bundle exec puma -C config/puma.rb
worker: bundle exec good_job start
