# Use Ubuntu 16.04 as base image
FROM ubuntu:16.04

# Install necessary packages
RUN apt-get update && \
    apt-get install -y telnet curl ffmpeg && \
    apt-get clean

# Set the default command to bash when running a container
CMD ["bash"]


