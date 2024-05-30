# Docker Image with Ubuntu 16.04 and Necessary Packages

This Docker image is based on Ubuntu 16.04 and includes the following packages: telnet, curl, and ffmpeg.

## Building the Image

To build the Docker image, navigate to the directory containing the Dockerfile and run the following command:

docker build -t ubuntu-16.04-packages

## Running a Container

To run a container from the built image, use the following command:

docker run -it ubuntu-16.04-packages


This will launch a bash shell inside the container.

## Additional Information

- Telnet, curl, and ffmpeg are installed in the image.
- The default command is set to bash.
