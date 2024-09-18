# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    gnupg \
    lsb-release \
    ca-certificates \
    apt-transport-https \
    software-properties-common \
    git \
    sudo \
    systemd \
    systemd-sysv \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user with a password
RUN useradd -m testuser && \
    echo "testuser:testpassword" | chpasswd && \
    echo "testuser ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/testuser

# Switch to the non-root user
USER testuser
WORKDIR /home/testuser

# Download marauder.sh
RUN wget --no-cache https://raw.githubusercontent.com/myriadsocial/myriad-infrastructure/main/linux/marauder.sh

# Make the script executable
RUN chmod +x marauder.sh

# Modify marauder.sh to change the final run_script command
RUN sed -i 's/run_script "setup_myriad_service.sh"/run_script "run_docker_compose.sh"/' marauder.sh

# Create a startup script
RUN echo '#!/bin/bash\n\
echo "Welcome to the Marauder test container!"\n\
echo "The marauder.sh script is located in the current directory."\n\
echo "To run it, use: sudo ./marauder.sh"\n\
exec /bin/bash' > startup.sh && \
chmod +x startup.sh

# Set the entrypoint to run as testuser
ENTRYPOINT ["/bin/bash", "/home/testuser/startup.sh"]