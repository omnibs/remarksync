FROM erlang:18

# elixir expects utf8.
ENV ELIXIR_VERSION="v1.2.5" \
	LANG=C.UTF-8

RUN set -xe \
	&& ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/archive/${ELIXIR_VERSION}.tar.gz" \
	&& curl -fSL -o elixir-src.tar.gz $ELIXIR_DOWNLOAD_URL \
	&& mkdir -p /usr/local/src/elixir \
	&& tar -xzC /usr/local/src/elixir --strip-components=1 -f elixir-src.tar.gz \
	&& rm elixir-src.tar.gz \
	&& cd /usr/local/src/elixir \
	&& make install clean

RUN set -xe \
  && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
  && apt-get install -y nodejs

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new-1.1.4.ez

RUN mkdir -p /remarksync/src
RUN mkdir -p /remarksync/bin
WORKDIR /remarksync/src

COPY . /remarksync/src

RUN mix deps.get
RUN mix compile

RUN npm install

RUN node node_modules/brunch/bin/brunch build

CMD ["iex -S mix phoenix.server"]
