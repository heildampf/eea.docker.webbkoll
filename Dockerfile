FROM elixir

COPY ./docker-entrypoint.sh /


RUN mkdir -p /sassc && cd /sassc && \
    git clone https://github.com/sass/sassc.git && \
    . sassc/script/bootstrap && \
    make -C sassc -j4

RUN apt update
RUN apt install rsync -y

RUN git clone https://github.com/andersju/webbkoll.git

WORKDIR /webbkoll

RUN mix local.hex --force && \
    mix deps.get --only prod && \
    mix local.rebar --force && \
    MIX_ENV=prod mix compile && \
    mkdir -p priv/static/css priv/static/fonts priv/static/images priv/static/js && \
    /sassc/sassc/bin/sassc --style compressed assets/scss/style.scss priv/static/css/app.css && \
    cat assets/static/js/* > priv/static/js/webbkoll.js && \
    rsync -av assets/static/*  priv/static && \
    MIX_ENV=prod mix phx.digest


ENTRYPOINT ["/docker-entrypoint.sh"]
