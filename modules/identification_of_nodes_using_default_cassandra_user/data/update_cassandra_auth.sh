bash

#!/bin/bash



# Define variables

NEW_USERNAME=${NEW_USERNAME}

NEW_PASSWORD=${NEW_PASSWORD}



# Stop Cassandra service

sudo systemctl stop cassandra



# Update cassandra.yaml configuration file

sudo sed -i "s/authenticator: org.apache.cassandra.auth.AllowAllAuthenticator/authenticator: org.apache.cassandra.auth.PasswordAuthenticator/" /etc/cassandra/cassandra.yaml



# Generate password hash

PASSWORD_HASH=$(echo -n $NEW_PASSWORD | md5sum | awk '{print $1}')



# Update cassandra-users.properties file

sudo bash -c "echo $NEW_USERNAME:$PASSWORD_HASH >> /etc/cassandra/cassandra-users.properties"



# Start Cassandra service

sudo systemctl start cassandra



# Verify Cassandra service is running

sudo systemctl status cassandra