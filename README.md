# Dockerfile for Ubuntu 22.04 with Additional Software

This Dockerfile is used to create a Docker image based on Ubuntu 22.04 with additional software and configurations.

## Features

- Installs essential packages and dependencies.
- Configures SSH access for the "ubuntu" user.
- Installs MongoDB Mongosh.
- Enables systemd for system-level management.

## Prerequisites

- Docker: Ensure you have Docker installed on your system.

## Build the Docker Image

To build the Docker image, use the following command in the directory containing this Dockerfile:

```bash
docker build -t ubuntu-ssh .
```

## Start the Docker Container

You can use the provided `setup.sh` script to build and start the Docker container. This script ensures proper container setup and configuration.

1. Make the script executable:

   ```bash
   chmod +x setup.sh
   ```

2. Execute the script to build and start the container:

   ```bash
   ./setup.sh
   ```

The script performs the following actions:

- Stops and removes any existing container named "ubuntu-ssh."
- Builds the Docker image using the Dockerfile.
- Runs the Docker container in detached mode with privileged access, allowing systemd to work correctly.
- Maps host port 22 to the container's SSH port.

## SSH Access

You can SSH into the running container as the "ubuntu" user with the following command:

```bash
ssh ubuntu@localhost -p 22
```

Password: `ubuntu`

## Note

- This Dockerfile is for demonstration purposes and may need further customization for production use.
- Ensure that you use secure SSH keys for authentication in a production environment.

## License

This project is licensed under the GPLv3 License - see the [LICENSE](LICENSE) file for details.
