FROM photon:5.0

# Copy the installation script
COPY install.sh /install.sh
COPY salt-firstboot.sh /salt-firstboot.sh
COPY srv /srv

# Make the script executable and run it
RUN chmod +x /install.sh && /install.sh && rm -f /install.sh /salt-firstboot.sh

# Copy the entrypoint that generates/accepts the minion's key on every container start
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
