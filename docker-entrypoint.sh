#!/bin/sh
set -e

sed -i 's/localhost:8100/'"$BACKEND_HOST"':'"$BACKEND_PORT"'/' /webbkoll/config/prod.exs

MIX_ENV=prod PORT=4000 mix phx.server