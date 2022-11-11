# LANCache-Prefill in Docker optimized for Unraid
This container will download and install BattleNetPrefill and/or SteamPrefill and run the prefill on a cron schedule.

**Network:** It is recommended to run this container in the same network mode as the LANCache-DNS if used, by default it is set to br0 please change that if you have your LANCache server configured to work network wide on your LAN to the correct network type for your configuration.

**DNS:** I would strongly recommend that you set the DNS manually to the LANCache-DNS if you haven't it configured to be network wide on your LAN, to do that turn on the advanced view (toggle switch in the top right corner) and at the extra parameters append: --dns=yourLANcacheSERVER (of course replace 'yourLANcacheSERVER' with the address of your LANCache-DNS).

**Update Notice:** The container will check by default on each start/restart on new updates for BattleNetPrefill and/or SteamPrefill, this can be disabled if really wanted.

**Steam Prefill Notice:** Steam Prefill needs to be configured to work properly, please enter the following commands and follow the prompts afterwards, you can close the window when you are finished:
1. Open up a container console
2. Type in 'su $USER' (case sensitive!) and press ENTER
3. Type in 'cd ${DATA_DIR}/SteamPrefill' and press ENTER
4. Type in './SteamPrefill select-apps' and press ENTER
5. Enter your Steam credentials and follow the steps displayed
6. Select the apps you want to prefill (you don't have to select any)
7. Done

(these stepps are also displayed in the container log when Steam isn't configured yet)

If you ever want to change the apps you've selected then follow these steps again.

## Env params
| Name | Value | Example |
| --- | --- | --- |
| DATA_DIR | Main data path | /lancacheprefill |
| ENABLE_BN | Set to 'true' or 'false' to enable or disable BattleNetPrefill | true |
| PREFILL_PARAMS_BN | You can get a full list of parameters over here: [Click](https://github.com/tpill90/battlenet-lancache-prefill#detailed-command-usage) | --products s1 |
| CRON_SCHED_BN | Set your cron schedule for the BattleNetPrefill if enabled (by default it is set to 05:00 - head over to [crontab guru](https://crontab.guru/) to create your own if you want to customize it) | 0 5 * * * |
| ENABLE_STEAM | Set to 'true' or 'false' to enable or disable SteamPrefill (please note that you have to configure SteamPrefill first - to get a tutorial on how to do that please open up the container console after the first start and follow the on screen instructions). | true |
| PREFILL_PARAMS_STEAM | You can get a full list of parameters over here: [Click](https://tpill90.github.io/steam-lancache-prefill/Detailed-Command-Usage/) (if you want to only prefill your selected apps then leave this variable empty) | --recent |
| CRON_SCHED_STEAM | Set your cron schedule for SteamPrefill if enabled (by default it is set to 05:00 - head over to https://crontab.guru/ to create your own if you want to customize it) | 0 2 * * * |
| UPDATES | Set to 'true' to enable to check for updates from BattleNetPrefill/SteamPrefill on container start/restart or disable it by setting it to 'false'. | true |
| FORCE_UPDATE | Set to 'true' to force a Prefill on every container start/restart (please be carefull with this option and enable only when you know what you are doing!) | false |
| LOGCLEANUP | Set to 'true' to clean up the .../logs directory on each start/restart from the container. | true |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |

## Run example
```
docker run --name LANCache-Prefill -d \
	--env 'ENABLE_BN=true' \
	--env 'PREFILL_PARAMS_BN=--products s1' \
	--env 'CRON_SCHED_BN=0 5 * * *' \
	--env 'ENABLE_STEAM=true' \
	--env 'PREFILL_PARAMS_STEAM=--recent' \
	--env 'CRON_SCHED_STEAM=0 2 * * *' \
	--env 'UPDATES=true' \
	--env 'FORCE_UPDATE=false' \
	--env 'LOGCLEANUP=true' \
	--env 'UID=99' \
	--env 'GID=100' \
	--env 'UMASK=0000' \
	--env 'DATA_PERM=770' \
	--volume /path/to/lancacheprefill:/lancacheprefill \
	ich777/ich777/lancache-prefill
```

This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!

#### Support Thread: https://forums.unraid.net/topic/83786-support-ich777-application-dockers/