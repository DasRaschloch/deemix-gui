# deemix-gui
An electron app that wraps deemix-webui and lets you use the deemix-js library

## Changes compared to the original Repo (https://gitlab.com/RemixDev/deemix-gui)
- Added the option to download albums and tracks released after a date specified by the user
- Added Docker support (The scripts are based on the Repo by Bockiii: https://gitlab.com/Bockiii/deemix-docker)

## Running from source
You need to use nodejs 16.x, using `yarn` is recommended.

If you're using git to get this repo you should use `git submodule update --init --recursive` as well. If you're just downloading the archive.zip, make sure you download and extract deemix-webui into the webui folder.

Install the dependencies using `yarn install-all` for production.
Install the dependencies using `yarn install-all-dev` for development.
Then you should be able to run the app with `yarn start`.
If you want to further develop deemix-gui and propose a PR, use `yarn dev`

Commands for easy setup:

```sh
# Production
git clone https://gitlab.com/RemixDev/deemix-gui.git . && git submodule update --init --recursive && yarn install-all
# Development
git clone https://gitlab.com/RemixDev/deemix-gui.git . && git submodule update --init --recursive && yarn install-all-dev
```

You can change the default port by setting the environment variable `PORT` to any other number before starting the app.

## Building the app
To build the app you need to have git installed and the repo cloned with `git`.
Make sure you've installed the dependencies for all packages (the root folder, `server` and `webui`).
Then from the root folder run `yarn dist` to make a distributable package for your current OS or `yarn dist-server` to make an executable for only the server.

## Docker (Credits go to Bockiii for this)

If you want to build the Dockerimage for yourself you dont need to pull the whole Repo. The image will always pull from the main branch and fetch the related submodules.
### Example for Build Command:
1. Download the dockerfile
2. Navigate to the folder where you downloaded the file into
3. Run the following command (Docker Desktop or Docker Engine need to be installed on the system):
```
docker build -t deemix .
```


### Example for Docker:
```
$ docker run -d --name Deemix \
				-v /your/storage/path/:/downloads \
				-v /your/config/location:/config \
				-e PUID=1000 \
				-e PGID=1000 \
				-e UMASK_SET=022 \
				-e DEEMIX_SINGLE_USER=true \
				-p 6595:6595 \
				deemix
```

### Example for Docker Compose:
```
version: '3.3'
services:
	deemix:
		image: deemix
		container_name: Deemix
		volumes:
			- /your/storage/path/:/downloads
			- /your/config/location:/config
		environment:
			- PUID=1000
			- PGID=1000
			- UMASK_SET=022
			- DEEMIX_SINGLE_USER=true
		ports:
			- 6595:6595
```

### Parameters:

| Parameter | Function |
| :----: | --- |
| `-v /your/storage/path/:/downloads` | Path for your music downloads |
| `-v /your/config/location:/config` | Path to your local configuration |
| `-e PUID=1000` | OPTIONAL: User ID of the user you want the container to run as in order to fix folder permission issues |
| `-e PGID=1000` | OPTIONAL: Group ID, see PUID |
| `-e UMASK_SET=022` | OPTIONAL: Setting UMASK for file permissions Default is 022 |
| `-e DEEMIX_LOCATION_BASE=/deemix/` | OPTIONAL: For subfolder reverse proxying, add the subdomain in this env variable |
| `-e DEEMIX_SINGLE_USER=true` | OPTIONAL: Similar to the ARL functionality in previous iterations. See below for details |
| `-p 6595:6595` | Port opened for the web interface |
| `-e INTPORT=3333` | EXTRA OPTIONAL: This changes the internal port of deemix. DON'T CHANGE THIS IF YOU DONT KNOW WHY YOU WOULD DO IT |
| `-e DISABLE_OWNERSHIP_CHECK=true` | EXTRA OPTIONAL: This disables the ownership check on the downloads folder. Can lead to download issues if the folder is not owned by the correct user. DON'T USE THIS IF YOU DONT KNOW WHY YOU WOULD NEED IT |
| `deemix` | The imagename used in the build command. In my examples this is always deemix |

To access the web interface, go to http://YOURSERVERIP:6595 

### DEEMIX_SINGLE_USER:

Setting this environment variable to true will enable a serverwide login. In this mode, only one user needs to log in and every session will use the same login. You do not need to provide an ARL to the container, deemix will store the login information in the config folder.

I also added a functionality that will enable Single_User mode when any ARL is configured at all. This will help legacy installations that still use old configuration parameters. As long as the ARL is set to anything, the mode is enabled. The provided ARL will NOT be processed, so you will need to login once using the web interface.

# License
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <https://www.gnu.org/licenses/>.
