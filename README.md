# LANCache-Prefill in Docker optimized for Unraid
This container will download and install [BattleNetPrefill](https://github.com/tpill90/Battlenet-lancache-prefill),  [EpicPrefill](https://github.com/tpill90/epic-lancache-prefill) and [SteamPrefill](https://github.com/tpill90/steam-lancache-prefill), and run them on a nightly schedule using cron.

# Table of contents

- [Initial Setup](#initial-setup)
- [Need Help?](#need-help)
- [Updating](#updating)
- [Run Example](#run-example)

# Initial Setup

> [!NOTE]
> This guide was written using SteamPrefill as an example, since it is the most popular of the prefills.  If you would like to like to use BattleNetPrefill or EpicPrefill as well, repeat these steps replacing **SteamPrefill** with **BattleNetPrefill** or **EpicPrefill**

SteamPrefill needs to be configured to work properly.  Please enter the following commands and follow the prompts, afterwards you can close the window when you are finished:

1. Open up a container console
2. Type in `su $USER` (case sensitive!) and press ENTER
3. Type in `cd ${DATA_DIR}/SteamPrefill` and press ENTER
4. Type in `./SteamPrefill select-apps` and press ENTER
5. Follow the steps displayed to enter your credentials.
6. Select the apps you want to prefill.
7. Done

If you ever want to change the apps you've selected then follow these steps again.

## Additional Configuration

### Network
It is recommended to run this container in the same network mode as **LANCache-DNS**, which by default is set to **br0**. please change that if you have your LANCache server configured to work network wide on your LAN to the correct network type for your configuration.

### DNS
It is strongly recommended that you set the DNS manually to use **LANCache-DNS** if you haven't configured it to be network wide on your LAN. To do that turn on the advanced view (toggle switch in the top right corner) and at the extra parameters append: `--dns=XXX.XXX.XXX.XXX` (of course replace *XXX.XXX.XXX.XXX* with the IP address of your LANCache-DNS).

# Need Help?
Support Thread: https://forums.unraid.net/topic/83786-support-ich777-application-dockers/

It is also recommended to read the full documentation for each individual prefill, both on [Github](https://github.com/tpill90/steam-lancache-prefill) as well as the [project wiki](https://tpill90.github.io/steam-lancache-prefill/)

The container log will also have additional output that can help you diagnose what is wrong with the container.

# Updating
By default, updates will automatically be checked on container start/restart for BattleNetPrefill, EpicPrefill and SteamPrefill.  If desired, this can be disabled by setting the environment variable `UPDATES` to **false**.

# Environment Variables

### General
| Name              | Description | Default |
| ----------------- | ----------- | ------- |
| DATA_DIR          | Path where the data and configuration will be stored  | /lancacheprefill |
| UID               | User Identifier                                       | 99 |
| GID               | Group Identifier                                      | 100 |
| UPDATES           | When enabled, will check for any LancachePrefill updates on container startup. | true |
| LOGCLEANUP        | Set to **true** to clean up the .../logs directory on each start or restart of the container. | true |
| CRON_SCHED_GLOBAL | Specifies a cron schedule that will override any individual schedules for BattlenetPrefill, EpicPrefill, and SteamPrefill.  Each prefill will be run sequentially on the given schedule. | 0 2 * * * |
| PREFILL_ONSTARTUP | When enabled, will run a prefill every time the container starts (or restarts), rather than waiting for the cron job to trigger.  Note that this is not generally not needed, and should only be enabled in some very specific scenarios.  | false |

### BattleNetPrefill
| Name     | Description | Default |
| -------- | ----------- | ------- |
| ENABLE_BN | Set to **true** or **false** to enable or disable BattleNetPrefill. | false |
| CRON_SCHED_BN | Sets the cron schedule for BattleNetPrefill, if it is enabled. By default it is set to 5am, head over to [crontab guru](https://crontab.guru/) to create your own if you want to customize it. |  |

### EpicPrefill
| Name     | Description | Default |
| -------- | ----------- | ------- |
| ENABLE_EPIC | Set to **true** or **false** to enable or disable EpicPrefill | false |
| PREFILL_PARAMS_EPIC | Specifies additional options for EpicPrefill.  You can get a full list of options from the [project wiki](https://tpill90.github.io/epic-lancache-prefill/Detailed-Command-Usage/#prefill) |  |
| CRON_SCHED_EPIC | Sets the cron schedule for EpicPrefill, if it is enabled. By default it is set to 4am, head over to [crontab guru](https://crontab.guru/) to create your own if you want to customize it. |  |

### SteamPrefill
| Name     | Description | Default |
| -------- | ----------- | ------- |
| ENABLE_STEAM | Set to **true** or **false** to enable or disable SteamPrefill | true |
| PREFILL_PARAMS_STEAM | Specifies additional options for SteamPrefill.  You can get a full list of options from the [project wiki](https://tpill90.github.io/steam-lancache-prefill/detailed-command-usage/Prefill/#options).  The default value of `--recent` will prefill your most recently played games in addition to selected apps.  If you want to only prefill your selected apps then leave this variable empty. | --recent |
| CRON_SCHED_STEAM | Sets the cron schedule for SteamPrefill, if it is enabled. By default it is set to 2am, head over to [crontab guru](https://crontab.guru/) to create your own if you want to customize it. |  |


# Run example
```
docker run --name LANCache-Prefill -d \
	--env 'ENABLE_BN=true' \
	--env 'ENABLE_EPIC=true' \
	--env 'ENABLE_STEAM=true' \
	--env 'PREFILL_PARAMS_STEAM=--recent' \
	--env 'CRON_SCHED_GLOBAL=0 2 * * *' \
	--env 'UPDATES=true' \
	--env 'FORCE_UPDATE=false' \
	--env 'LOGCLEANUP=true' \
	--env 'UID=99' \
	--env 'GID=100' \
	--env 'UMASK=0000' \
	--env 'DATA_PERM=770' \
	--volume /path/to/lancacheprefill:/lancacheprefill \
	ich777/lancache-prefill
```

This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!