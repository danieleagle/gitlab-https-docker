# v1.6.0

- Updated GitLab CE to the latest version.
- Changed port mapping, environment variables, and added network alias to docker-compose.yml.
- Updated the docs to include updated instructions.
- Added Azure files to complement [this article](https://danieleagle.com/2017/10/setting-up-a-private-cicd-solution-in-azure/).

# v1.5.0

- Changed port mapping from 9150 to 51203 (HTTPS) and 9151 to 51204 (SSH).
- Updated GitLab CE to version 9.0.2-ce.0.
- Added .dockerignore rule to ignore .md files.

# v1.4.2

- Updated GitLab CE to version 9.0.0-ce.0.
- Minor documentation changes.

# v1.4.1

- Added .gitattributes to enforce LF line endings.
- Updated GitLab CE to version 8.17.3-ce.0.
- Updated docker-compose.yml to version 3.

# v1.4.0

- Updated relevant documentation.
- Removed copying of SSL files into image (see [this article](https://developer.atlassian.com/blog/2016/06/common-dockerfile-mistakes/)). Please review updated README.md.
- Removed Dockerfile as it's no longer needed after making the changes from the previous bullet point.
- Removed dummy SSL files.
- Changed volume mapping for SSL files.
- Updated GitLab CE to version 8.17.2-ce.0.
- Updated .gitignore to remove old config folder.

# v1.3.0

- Updated relevant documentation.
- Updated GitLab CE to version 8.16.4-ce.0.

# v1.2.0

- Updated relevant documentation.
- Updated GitLab CE to version 8.16.1-ce.0.

# v1.1.0

- Updated relevant documentation.
- Updated GitLab CE to version 8.16.0-rc6.ce.0.

# v1.0.1

- Updated relevant documentation.

# v1.0.0

- Initial release
