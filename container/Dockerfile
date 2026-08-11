FROM photon:5.0

# Copy the installation script
COPY install.sh /install.sh
COPY srv /srv

# Make the script executable and run it
RUN chmod +x /install.sh && /install.sh

# Set the default command (can be overridden)
CMD ["/bin/bash"]
