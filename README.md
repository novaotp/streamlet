# Streamlet

Experimental YouTube-style web app for learning and testing.

## Getting Started

### Prerequisites

* NodeJS v24 (tested on v24.11.0)
* Elixir 1.19.1 and OTP 28
* Docker

### Development

1. Create a `.env` file based on `.env.example`.

    > You can generate a secret for `SECRET_KEY_BASE` by running `mix phx.gen.secret` inside `server`.

2. Create a `garage.toml` file based on `garage.toml.example`.

    > All secrets must be 32 bytes hex string.

3. Build the `docker-compose.dev.yml` file.

    ```sh
    docker compose -f docker-compose.dev.yml build
    ```

4. Run the `docker-compose.dev.yml` file.

    ```sh
    docker compose -f docker-compose.dev.yml up
    ```

    > Wait until everything is ready before proceeding to the next step.

5. Create and apply a cluster layout for `garage`.

    ```sh
    # See our node's ID
    docker exec -it streamlet-s3 /garage status

    # Assign our node to zone `lon1` with `50 GB` of capacity
    docker exec -it streamlet-s3 /garage layout assign <first-four-node-id> -z lon1 -c 50G

    # (Optional) View the layout
    docker exec -it streamlet-s3 /garage layout show

    # Apply the layout
    docker exec -it streamlet-s3 /garage layout apply --version 1
    ```

6. Create the necessary buckets.

    ```sh
    # Create a bucket named `video-bucket` to store our videos
    docker exec -it streamlet-s3 /garage bucket create videos-bucket

    # (Optional) Check that everything went well
    docker exec -it streamlet-s3 /garage bucket list
    docker exec -it streamlet-s3 /garage bucket info videos-bucket
    ```

7. Create an access and secret key, and use the values inside `.env`.

    ```sh
    # Create a master key for API access
    # Use these values for the access and secret key inside `.env`
    docker exec -it streamlet-s3 /garage key create master-key

    # (Optional) Check that everything went well
    docker exec -it streamlet-s3 /garage key list
    docker exec -it streamlet-s3 /garage key info master-key

    # Give permissions to the key on the bucket
    docker exec -it streamlet-s3 /garage bucket allow --read --write --owner videos-bucket --key master-key
    ```

8. Open your browser at https://localhost.
