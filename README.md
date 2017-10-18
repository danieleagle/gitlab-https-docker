# GitLab with HTTPS on Docker

This repository contains custom Docker files for [GitLab CE](https://gitlab.com/gitlab-org/gitlab-ce). Everything is setup to run on HTTPS using a self-signed certificate ([this needs to be created](./README.md#generating-self-signed-certificate)) and includes commonly used features specified as environment variables in the included Docker Compose file.

Be sure to see the [change log](./CHANGELOG.md) if interested in tracking changes leading to the current release. In addition, please refer to [this article](http://danieleagle.com/2017/01/gitlab-ce-with-https-using-docker/) for even more details about this project.

Also, if you wish to setup a highly available complete CICD solution running in Azure using this solution, see [this article](https://danieleagle.com/2017/10/setting-up-a-private-cicd-solution-in-azure/). It contains a plethora of information that will greatly complement the text within. The Azure specific GitLab files can be found in the [azure](./azure/) folder within this repository.

## Assumed Environment

It is assumed that the environment being used is Linux for installation purposes. The instructions within have been tested successfully on [Ubuntu](https://www.ubuntu.com/) 16.10 and 17.04. Additional instructions will be applicable to Windows.

## Getting Started

1. Ensure [Docker Compose](https://docs.docker.com/compose/) is installed along with [Docker Engine](https://docs.docker.com/engine/installation/).

2. Clone this repository into the desired location.

3. Modify the GitLab CE settings to meet the needs of the particular context. These settings are found in the [docker-compose.yml](./docker-compose.yml) file. Information on these settings are found below. Also, change the **network alias** to the FQDN of your choice if you wish to use that later with any other Docker containers.

4. [Generate a self-signed certificate](./README.md#generating-a-self-signed-certificate) to use with the GitLab CE instance.

5. Run the following command:

   `sudo docker-compose up -d`

Please read the rest of the content found within in order to understand additional configuration options.

## Settings Specified in Docker Compose File

Below is a list of the settings (more settings may exist in the docker-compose.yml file) that are specified in [docker-compose.yml](./docker-compose.yml). Some of these settings will need to be changed in order to meet specific goals. Additional settings can be added here or existing settings removed. For more information on available configuration options, go [here](https://docs.gitlab.com/omnibus/settings/configuration.html). In addition, for more information on the logrotate settings, go [here](http://www.linuxcommand.org/man_pages/logrotate8.html).

1. **external_url** - This is the URL used to access the GitLab CE instance externally. Links in emails will use this URL along with certain uploaded assets (e.g. images specified for groups, etc.). Be sure to specify the port used externally to access the GitLab CE instance from Docker (e.g. port 9150 which maps to the internal Docker port of 443).

2. **gitlab_rails['time_zone']** - Specifies the desired timezone in order for the correct time to show up in the logs, amongst other things.

3. **gitlab_rails['smtp_enable']** - Enables SMTP so emails can be sent out on certain events (e.g. new user registrations, etc.).

4. **gitlab_rails['smtp_address']** - The SMTP server address used for sending emails.

5. **gitlab_rails['smtp_port']** - The port used for SMTP (e.g. port 587 for TLS to ensure emails are sent securely).

6. **gitlab_rails['smtp_user_name']** - The username used for sending emails via SMTP (e.g. user@example.com).

7. **gitlab_rails['smtp_password']** - The password used for the SMTP email account.

8. **gitlab_rails['smtp_domain']** - The domain used for sending emails via SMTP (e.g. example.com).

9. **gitlab_rails['smtp_authentication']** - Specifies the SMTP authentication mode.

10. **gitlab_rails['smtp_enable_starttls_auto']** - Enables TLS to ensure the transfer of secure email messages.

11. **gitlab_rails['gitlab_email_from']** - Specifies the *from* email address shown in the sent email.

12. **gitlab_rails['backup_keep_time']** - Specifies how long in seconds to keep each backup (e.g. 14515200 for roughly 6 months).

13. **logging['logrotate_frequency']** and **nginx['logrotate_frequency']** - Specifies how often logs should be rotated for GitLab CE or NGINX (e.g. daily, weekly, etc.).

14. **logging['logrotate_rotate']** and **nginx['logrotate_rotate']** - Specifies the the value used by the frequency setting above (e.g. if frequency is weekly and rotate interval is set to 7, logs will rotate every 7 weeks) for GitLab CE or NGINX.

15. **logging['logrotate_compress']** and **nginx['logrotate_compress']** - Specifies whether logs should be compressed when rotated for GitLab CE or NGINX.

16. **logging['logrotate_method']** and **nginx['logrotate_method']** - Specifies the method used when logs are rotated (e.g. copytruncate) for GitLab CE or NGINX.

17. **logging['logrotate_delaycompress']** and **nginx['logrotate_delaycompress']** - Specifies whether compression should be delayed when rotating logs for GitLab CE or NGINX.

18. **nginx['listen_port']** - Specifies the port (e.g. port 443 used internally by container) used to force NGINX to listen on. This should be specified if supplying a port to the *external_url* setting. This is because if a port is detected in the external URL, GitLab CE will instruct NGINX to listen on that port unless specifying this setting which acts as an override.

19. **nginx['redirect_http_to_https']** - Redirects HTTP requests to HTTPS, preventing the use of insecure communications.

20. **nginx['ssl_certificate']** - Specifies which SSL certificate to use via a file path. This is an internal container path.

21. **nginx['ssl_certificate_key']** - Specifies which SSL certificate key to use via a file path. This is an internal container path.

## Generating a Self-Signed Certificate

In order to generate a self-signed certificate (using OpenSSL) to secure all HTTP traffic, follow these instructions.

1. Run the command `sudo openssl genrsa -out server-key.pem 4096` which will generate a secure server key.

2. Run the command `sudo openssl req -new -key server-key.pem -out server.csr` which will generate the certificate signing request.

3. The above command will request input in the following areas shown below.

    ``` bash
    Country Name (2 letter code) [AU]:
    State or Province Name (full name) [Some-State]:
    Locality Name (eg, city) []:
    Organization Name (eg, company) [Internet Widgits Pty Ltd]:
    Organizational Unit Name (eg, section) []:
    Common Name (e.g. server FQDN or YOUR name) []:
    Email Address []:

    Please enter the following 'extra' attributes
    to be sent with your certificate request
    A challenge password []:
    An optional company name []:
    ```

   It's important that for *Common Name (e.g. server FQDN or YOUR name)* to enter the domain that GitLab CE will use (e.g. the value specified for external URL in *docker-compose.yml* without the port such as **gitlab.dev.internal.example.com**).

4. Run the command `sudo openssl x509 -req -days 365 -in server.csr -signkey server-key.pem -out server-cert.pem` to create the signed certificate. The certificate will be valid for one year unless the value used for days is different.

5. Delete the leftover certificate signing request file: `sudo rm server.csr`.

6. Create a folder named `./volume_data/ssl` by typing the following command: `sudo mkdir -p /volume_data/ssl`. Be sure to run this command in the root of the folder where you cloned this repository.

7. Copy both **server.crt** and **server.key** into `./volume_data/ssl`. These files will be used to enable HTTPS.

## Container Network

The network specified (can be changed to the desired value) by this Docker container is named `development`. It is assumed that this network has already been created prior to using the included Docker Compose file. The reason for this is to avoid generating a default network so that other Docker containers can access the GitLab CE instance (e.g. Jenkins for CICD, etc.) using the [Docker embedded DNS server](https://docs.docker.com/engine/userguide/networking/#/docker-embedded-dns-server).

If no network has been created, run the following Docker command: `sudo docker network create network-name`. Be sure to replace *network-name* with the name of the desired network. For more information on this command, go [here](https://docs.docker.com/engine/reference/commandline/network_create/).

## Port Mapping

The external ports used to map to the internal ports that GitLab CE uses are 50443 (maps to 443 for HTTPS) and 50022 (maps to 22 for SSH). These ports can certainly be changed but please be mindful of the effects. Changing the port mapped to HTTPS will require changing it on the *external_url* setting found in the Docker Compose file.

However, if the external port for HTTPS is set to the same port used internally (e.g. 443), then the port can be omitted from the *external_url* setting and the *nginx['listen_port']* setting can be omitted as it will no longer be required.

## Data Volumes

It is possible to change the data volume folders mapped to the container to something other than `volume_data/x` if desired. It is recommended to choose a naming scheme that is easy to recognize.

## Configuring Git to Work with a Self-Signed Certificate

For Git to work with a self-signed certificate, a few configuration options need to be specified. There are two ways to do this explained here and one may be better suited to the given situation than the other. Read through the options and pick the best one for the given circumstances.

### Option 1 - Modify the Global Git Configuration

To configure Git to always use the self-signed certificate for all HTTPS transactions, modify the Git configuration (global .gitconfig file) and add the following (geared toward Windows). This file is usually found at `C:\Users\jsmith\.gitconfig` and be sure to replace the user folder `jsmith` with the correct one suited to the given context.

``` bash
[http]
  sslCAinfo = C:\\Users\\jsmith\\certificates\\gitlab\\server-cert.pem
```

This assumes the certificate has been copied into a different directory (e.g. c:\Users\jsmith\certificates) and then referenced in the global Git configuration file. This directory can be changed to something else if desired.

### Option 2 - Specify the Self-Signed Certificate Upon Git Clone Operation

This option, while being more manual in nature, specifies the self-signed certificate to use when performing a Git Clone operation. Once the repository has been cloned, additional transactions made against it will use this certificate. One benefit to this approach is having the ability to interact with other repositories that do not use a self-signed certificate (e.g. public GitHub repos). For most people, this will be the best option.

Run the following command to clone a repository and specify the self-signed certificate to use for it (geared toward Windows):

`git clone -c http.sslCAPath="C:\\Users\\jsmith\\certificates\\gitlab" -c http.sslCAInfo="C:\\Users\\jsmith\\certificates\\gitlab\\server-cert.pem" -c http.sslVerify=1 https://git.example.com/jsmith/gitlab-ce.git`

Please see **Option 1** above for more details on the path used with this command. This path will be different depending upon the context.

### Further Reading

For information making this change on platforms other than Windows or for extra details, please go [here](http://stackoverflow.com/questions/11621768/how-can-i-make-git-accept-a-self-signed-certificate).
