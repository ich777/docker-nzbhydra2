# NZBHydra2 in Docker optimized for Unraid
NZBHydra2 is a meta search for newznab indexers and torznab trackers. It provides easy access to newznab indexers and many torznab trackers via Jackett. You can search all your indexers and trackers from one place and use it as an indexer source for tools like Sonarr, Radarr, Lidarr or CouchPotato.

**UPDATE:** The container will check on every start/restart if there is a newer version available.

**MANUAL VERSION:** You can also set a version manually by typing in the version number that you want to use for example: '3.4.3' (without quotes).


## Env params
| Name | Value | Example |
| --- | --- | --- |
| DATA_DIR | Folder for configfiles and the application | /nzbhydra2 |
| NZBHYDRA2_REL | Select if you want to download a stable or prerelease | latest |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| UMASK | Umask value for new created files | 0000 |
| DATA_PERMS | Data permissions for config folder | 770 |

## Run example
```
docker run --name NZBHydra2 -d \
	-p 5076:5076 \
	--env 'NZBHYDRA2_REL=latest' \
	--env 'UID=99' \
	--env 'GID=100' \
	--env 'UMASK=0000' \
	--env 'DATA_PERMS=770' \
	--volume /mnt/cache/appdata/nzbhydra2:/nzbhydra2 \
	--volume /mnt/user/Downloads:/mnt/downloads \
	ich777/nzbhydra2
```

This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!
 
#### Support Thread: https://forums.unraid.net/topic/83786-support-ich777-application-dockers/