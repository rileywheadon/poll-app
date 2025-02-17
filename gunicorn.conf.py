# Gunicorn configuration file:
# https://docs.gunicorn.org/en/stable/configure.html
# https://docs.gunicorn.org/en/stable/settings.html

import os

# Note: When changing the number of dynos/workers/threads you will want to make sure you
# do not exceed the maximum number of connections to external services such as DBs:
# https://devcenter.heroku.com/articles/python-concurrency-and-database-connections
worker_class = "gthread"

# gunicorn will start this many worker processes. 
# The Python buildpack automatically sets a  default for WEB_CONCURRENCY at dyno boot, 
# based on the number of CPUs and available RAM:
# https://devcenter.heroku.com/articles/python-concurrency
workers = os.environ.get("WEB_CONCURRENCY", 1)

# Each `gthread` worker process will use a pool of this many threads.
threads = 5

# Workers silent for more than this many seconds are killed and restarted.
# Note: This only affects the maximum request time when using the `sync` worker.
# For all other worker types it acts only as a worker heartbeat timeout.
timeout = 20

# After receiving a restart signal, workers have this much time to finish serving 
# requests. This should be set to a value less than the 30 second Heroku dyno shutdown 
# timeout: https://devcenter.heroku.com/articles/dyno-shutdown-behavior
graceful_timeout = 20

# Enable logging of incoming requests to stdout.
accesslog = "-"

# Adjust which fields are included in the access log, and make it use the Heroku logfmt
# style. The `X-Request-Id` and `X-Forwarded-For` headers are set by the Heroku Router:
# https://devcenter.heroku.com/articles/http-routing#heroku-headers
access_log_format = 'gunicorn method=%(m)s path="%(U)s" status=%(s)s duration=%(M)sms request_id=%({x-request-id}i)s fwd="%({x-forwarded-for}i)s" user_agent="%(a)s"'

if os.environ.get("ENVIRONMENT") == "development":

    # Automatically restart gunicorn when the app source changes in development.
    reload = True

    # Fix the port so that the supabase auth callback works on development
    bind = "127.0.0.1:3000"

    # Add the certfile and keyfile
    certfile = "cert.pem"
    keyfile = "key.pem"

else:

    # Set a valid port for both IPV4 and IPV6 interfaces
    bind = ["[::]:{}".format(os.environ.get("PORT", 5006))]

    # Load the app before the worker processes are forked
    # We don't enable this in development, since it's incompatible with `reload = True`.
    preload_app = True

    # Use `SO_REUSEPORT` on the listening socket, which allows for more even request
    # distribution between workers. See: https://lwn.net/Articles/542629/
    # We don't enable this in development, since it makes it harder to notice when
    # duplicate gunicorn processes have accidentally been launched (eg in different
    # terminals), since the "address already in use" error no longer occurs.
    reuse_port = True

    # Trust the `X-Forwarded-Proto` header set by the Heroku Router during TLS termination
    # (https://devcenter.heroku.com/articles/http-routing#heroku-headers) so that HTTPS 
    # requests are correctly marked as secure. This allows the WSGI app to distinguish
    # between HTTP and HTTPS requests for features like HTTP->HTTPS URL redirection.
    forwarded_allow_ips = "*"
