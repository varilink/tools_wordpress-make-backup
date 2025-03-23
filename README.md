# Tools - WordPress Make Backup

David Williamson @ Varilink Computing Ltd

-----

Docker Compose based tool that creates the `database.sql.gz` and `html.tar.gz` files, which contain the backup of the database and files for a WordPress site, within the `backup/` folder of a project repository. It sources these from a backup that has been restored to the *hub* host using the Varilink [Tools - WordPress Restore](git@github.com:varilink/tools_wordpress-restore.git) tool, so using that tool is a precursor to using this one.

This tool can be used within either the `_ansible` or `_docker` suffixed repositories for a Varilink WordPress site project. Within the `_ansible` suffixed repository it is typically used by the `restore-wordpress-site.yml` playbook from the Varilink [Libraries - Ansible Playbooks](https://github.com/varilink/libraries_ansible-playbooks) repository, so that the backup may be restored to an instance of the project's WordPress site, which is usually for a different subdomain and/or on a different host to those corresponding to the instance of the project's WordPress site that the original backup was taken from. Within the `_docker` suffixed repository it is typically used so that the Varilink [Tools - WordPress](https://github.com/varilink/tools_wordpress) tool can use the backup files to restore to a simulation of the project's WordPress site running on the local, client desktop.

## Contents

| File(s) / Directory or Director                            ies | Description                                                                    |
| -------------------------------------------------------------- | ------------------------------------------------------------------------------ |
| `docker-compose.yml`<br>`docker-entrypoint.sh`<br>`Dockerfile` | Configuration for this tool, which is implemented as a Docker Compose service. |

## Installation

Install as a submodule of either the `_ansible` or `_docker` suffixed repositories for a WordPress site project at the path `tools/wordpress-make-backup` and concatenate this tool's `docker-compose.yml` file into the `COMPOSE_FILE` paths for the repository.

Build this tool's image:

```sh
docker-compose build wp-make-backup
```

## Usage

Run this tool:

```sh
docker-compose run --rm -e SUBDOMAIN=$SUBDOMAIN wp-make-backup
```

You must provide the value for `$SUBDOMAIN` on the command line; for example, *www*, *staging*, *test*, etc. Remember that first there must be restored files present on the *hub* host that have been created using the Varilink [Tools - WordPress Restore](git@github.com:varilink/tools_wordpress-restore.git) tool.
