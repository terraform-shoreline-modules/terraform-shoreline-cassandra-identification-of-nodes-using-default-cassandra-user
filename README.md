
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Identification of Nodes Using Default Cassandra User
---

This incident type refers to the identification of nodes in a Cassandra database that are using the default Cassandra user. This leaves the database vulnerable to security breaches, as the default user has wide-ranging access to the database. If this issue is not addressed, it can lead to data theft or unauthorized access to sensitive information. Proper configuration and management of user permissions is essential to mitigate this risk.

### Parameters
```shell
export CASSANDRA_CONNECTION_SCRIPT="PLACEHOLDER"

export CASSANDRA_LOGS="PLACEHOLDER"

export NEW_PASSWORD="PLACEHOLDER"

export NEW_USERNAME="PLACEHOLDER"
```

## Debug

### 1. Check if Cassandra is running
```shell
systemctl status cassandra
```

### 2. Check the Cassandra configuration file
```shell
cat /etc/cassandra/cassandra.yaml
```

### 3. Check if the default user is enabled
```shell
grep 'authenticator: AllowAllAuthenticator' /etc/cassandra/cassandra.yaml
```

### 4. Check if the default user is being used to connect to Cassandra
```shell
grep 'cassandra' ${CASSANDRA_CONNECTION_SCRIPT}
```

### 5. Check if any other users are being used to connect to Cassandra
```shell
grep 'username' ${CASSANDRA_CONNECTION_SCRIPT}
```

### 6. Check if any unauthorized access has been made to Cassandra
```shell
grep 'Authentication error' ${CASSANDRA_LOGS}
```

### 7. Check if any unauthorized access has been made to the system
```shell
grep 'Failed password' /var/log/auth.log
```

## Repair

### Change the default username and password of the Cassandra database to a unique, complex, and secure one.
```shell
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


```