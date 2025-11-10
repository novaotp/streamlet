# Streamlet

Experimental YouTube-style web app for learning and testing.

## Getting Started

### Prerequisites

* NodeJS v24 (tested on v24.11.0)
* Elixir 1.19.1 and OTP 28
* Docker

### Development

1. Create a `.env` file based on `.env.example`.

    > You can generate a secret by running `mix phx.gen.secret` inside `server`.

2. Build the `docker-compose.dev.yml` file.

```sh
docker compose -f docker-compose.dev.yml build
```

3. Run the `docker-compose.dev.yml` file.

```sh
docker compose -f docker-compose.dev.yml up
```

4. Open your browser at https://localhost.
