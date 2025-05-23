<h1 align="center">BeeStation 13 Codebase</h1>

[![forthebadge](data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyMzIuNTEyNTEyMjA3MDMxMjUiIGhlaWdodD0iMzUiIHZpZXdCb3g9IjAgMCAyMzIuNTEyNTEyMjA3MDMxMjUgMzUiPjxyZWN0IHdpZHRoPSI4Ny45ODc1MDMwNTE3NTc4MSIgaGVpZ2h0PSIzNSIgZmlsbD0iIzRhOTBlMiIvPjxyZWN0IHg9Ijg3Ljk4NzUwMzA1MTc1NzgxIiB3aWR0aD0iMTQ0LjUyNTAwOTE1NTI3MzQ0IiBoZWlnaHQ9IjM1IiBmaWxsPSIjZjhlNzFjIi8+PHRleHQgeD0iNDMuOTkzNzUxNTI1ODc4OTA2IiB5PSIyMS41IiBmb250LXNpemU9IjEyIiBmb250LWZhbWlseT0iJ1JvYm90bycsIHNhbnMtc2VyaWYiIGZpbGw9IiNGRkZGRkYiIHRleHQtYW5jaG9yPSJtaWRkbGUiIGxldHRlci1zcGFjaW5nPSIyIj5NQURFIEJZPC90ZXh0Pjx0ZXh0IHg9IjE2MC4yNTAwMDc2MjkzOTQ1MyIgeT0iMjEuNSIgZm9udC1zaXplPSIxMiIgZm9udC1mYW1pbHk9IidNb250c2VycmF0Jywgc2Fucy1zZXJpZiIgZmlsbD0iI0ZGRkZGRiIgdGV4dC1hbmNob3I9Im1pZGRsZSIgZm9udC13ZWlnaHQ9IjkwMCIgbGV0dGVyLXNwYWNpbmc9IjIiPkEgVE9UQUwgTk9PQjwvdGV4dD48L3N2Zz4=)](https://forthebadge.com)
[![forthebadge](https://forthebadge.com/images/featured/featured-made-with-crayons.svg)](https://forthebadge.com)
[![forthebadge](https://forthebadge.com/images/badges/built-with-resentment.svg)](https://forthebadge.com) [![forthebadge](https://forthebadge.com/images/badges/contains-technical-debt.svg)](https://user-images.githubusercontent.com/8171642/50290880-ffef5500-043a-11e9-8270-a2e5b697c86c.png) [![forinfinityandbyond](https://user-images.githubusercontent.com/5211576/29499758-4efff304-85e6-11e7-8267-62919c3688a9.gif)](https://www.reddit.com/r/SS13/comments/5oplxp/what_is_the_main_problem_with_byond_as_an_engine/dclbu1a)
[![Build Status](https://github.com/BeeStation/BeeStation-Hornet/workflows/Run%20tests/badge.svg)](https://github.com/BeeStation/BeeStation-Hornet/actions?query=workflow%3A%22Run+tests%22)
![Open Issues](https://isitmaintained.com/badge/open/BeeStation/BeeStation-Hornet.svg)

**Website:** http://beestation13.com
**Code:** https://github.com/beestation/beestation-hornet
**Wiki:** https://wiki.beestation13.com/view/Main_Page


## DOWNLOADING

There are a number of ways to download the source code. Some are described here, an alternative all-inclusive guide is also located at https://wiki.beestation13.com/view/Downloading_the_source_code

Option 1:
Follow this: https://wiki.beestation13.com/view/Guide_to_git
Clone the repository using `git clone`.

Option 2: Download the source code as a zip by clicking the ZIP button in the
code tab of https://github.com/beestation/beestation-hornet
(note: this will use a lot of bandwidth if you wish to update and is a lot of
hassle if you want to make any changes at all, so it's not recommended.)

Option 3: Use our docker image that tracks the master branch (See commits for build status. Again, same caveats as option 2)

```
docker run -d -p <your port>:1337 -v /path/to/your/config:/beestation/config -v /path/to/your/data:/beestation/data beestation/beestation <dream daemon options i.e. -public or -params>
```

## INSTALLATION

**You can no longer compile the codebase simply through Dream Maker**.

**Building Beestation in Dream Maker directly is now deprecated and might produce errors**, such as `'tgui.bundle.js': cannot find file`.

### Building with VSCode (Preferred)

**[How to compile in VSCode and other build options](tools/build/README.md).**

### Building without VSCode
You will find `BUILD.bat` in the root folder of BeeStation, double-clicking it will initiate the build. It consists of multiple steps and might take around 1-5 minutes to compile (particularly the first time). Unix users can directly call ./tools/build/build.

If you see any errors or warnings, something has gone wrong - possibly a corrupt
download or the files extracted wrong. If problems persist, ask for assistance
in https://discord.gg/Vh8TJp9 or https://discord.gg/z9ttAvA

Once that's done, open up the config folder. You'll want to edit config.txt to
set the probabilities for different gamemodes in Secret and to set your server
location so that all your players don't get disconnected at the end of each
round. It's recommended you don't turn on the gamemodes with probability 0,
except Extended, as they have various issues and aren't currently being tested,
so they may have unknown and bizarre bugs. Extended is essentially no mode, and
isn't in the Secret rotation by default as it's just not very fun.

You'll also want to edit config/admins.txt to remove the default admins and add
your own. "Game Master" is the highest level of access, and probably the one
you'll want to use for now. You can set up your own ranks and find out more in
config/admin_ranks.txt

The format is

```
byondkey = Rank
```

where the admin rank must be properly capitalised.

This codebase also depends on a native library called rust-g. A precompiled
Windows DLL is included in this repository, but Linux users will need to build
and install it themselves. Directions can be found at the [rust-g
repo](https://github.com/tgstation/rust-g).

Finally, to start the server, run Dream Daemon and enter the path to your
compiled beestation.dmb file. Make sure to set the port to the one you
specified in the config.txt, and set the Security box to 'Safe'. Then press GO
and the server should start up and be ready to join. It is also recommended that
you set up the SQL backend (see below).

## UPDATING

Just use git, or see the following subsection.

### Manual Update

To update an existing installation, first back up your /config and /data folders
as these store your server configuration, player preferences and banlist.

Then, extract the new files (preferably into a clean directory, but updating in
place should work fine), copy your /config and /data folders back into the new
install, overwriting when prompted except if we've specified otherwise, and
recompile the game.  Once you start the server up again, you should be running
the new version.

## HOSTING

Hosting requires the [Microsoft Visual C++ 2015 Redistributable](https://www.microsoft.com/en-us/download/details.aspx?id=52685). Specifically,
`vc_redist.x86.exe`. *Not* the 64-bit version. There is a decent chance you already have it if you've installed a game on Steam.

If you'd like a more robust server hosting option, check out tgstation's server tools suite at
https://github.com/tgstation/tgstation-server

## MAPS

BeeStation currently comes equipped with these maps.

* [BoxStation](https://wiki.beestation13.com/view/Boxstation)
* [CorgStation](https://wiki.beestation13.com/view/CorgsStation)
* [DeltaStation](https://wiki.beestation13.com/view/DeltaStation)
* [FlandStation](https://wiki.beestation13.com/view/FlandStation)
* [KiloStation](https://wiki.beestation13.com/view/KiloStation)
* [MetaStation (default)](https://wiki.beestation13.com/view/MetaStation)
* [RadStation](https://wiki.beestation13.com/view/RadStation)
* [RuntimeStation (used for debugging)](https://wiki.beestation13.com/view/RuntimeStation)

All maps have their own code file that is in the base of the _maps directory. Maps are loaded dynamically when the game starts. Follow this guideline when adding your own map, to your fork, for easy compatibility.

The map that will be loaded for the upcoming round is determined by reading data/next_map.json, which is a copy of the json files found in the _maps tree. If this file does not exist, the default map from config/maps.txt will be loaded. Failing that, BoxStation will be loaded. If you want to set a specific map to load next round you can use the Change Map verb in game before restarting the server or copy a json from _maps to data/next_map.json before starting the server. Also, for debugging purposes, ticking a corresponding map's code file in Dream Maker will force that map to load every round.

If you are hosting a server, and want randomly picked maps to be played each round, you can enable map rotation in [config.txt](config/config.txt) and then set the maps to be picked in the [maps.txt](config/maps.txt) file.

Anytime you want to make changes to a map it's imperative you use the [Map Merging tools](https://wiki.beestation13.com/view/Map_Merger)

## AWAY MISSIONS

BeeStation supports loading away missions however they are disabled by default.

Map files for away missions are located in the _maps/RandomZLevels directory. Each away mission includes it's own code definitions located in /code/modules/awaymissions/mission_code. These files must be included and compiled with the server beforehand otherwise the server will crash upon trying to load away missions that lack their code.

To enable an away mission open `config/awaymissionconfig.txt` and uncomment one of the .dmm lines by removing the #. If more than one away mission is uncommented then the away mission loader will randomly select one the enabled ones to load.

## SQL SETUP

The SQL backend requires a MariaDB server running 10.2 or later. MySQL is not supported. The database is required for the library, stats tracking, admin notes, bans, and persistent characters/preferences. Your server details go in `/config/dbconfig.txt`, and the SQL schema is in `/SQL/beestation_schema.sql`.

More detailed setup instructions are located here: https://wiki.beestation13.com/view/Working_with_the_database#Database_Setup

## WEB/CDN RESOURCE DELIVERY

Web delivery of game resources makes it quicker for players to join and reduces some of the stress on the game server.

1. Edit compile_options.dm to set the `PRELOAD_RSC` define to `0`
1. Add a url to config/external_rsc_urls pointing to a .zip file containing the .rsc.
    * If you keep up to date with BeeStation you could reuse our rsc cdn at http://rsc.beestation13.buzz/beestation.zip. Otherwise you can use cdn services like CDN77 or cloudflare (requires adding a page rule to enable caching of the zip), or roll your own cdn using route 53 and vps providers.
	* Regardless even offloading the rsc to a website without a CDN will be a massive improvement over the in game system for transferring files.

## IRC BOT SETUP

Included in the repository is a python3 compatible IRC bot capable of relaying adminhelps to a specified
IRC channel/server, see the /tools/minibot folder for more

## CONTRIBUTING

Please see [CONTRIBUTING.md](.github/CONTRIBUTING.md)

## LICENSE

All code after [commit 333c566b88108de218d882840e61928a9b759d8f on 2014/31/12 at 4:38 PM PST](https://github.com/tgstation/tgstation/commit/333c566b88108de218d882840e61928a9b759d8f) is licensed under [GNU AGPL v3](https://www.gnu.org/licenses/agpl-3.0.html).

All code before [commit 333c566b88108de218d882840e61928a9b759d8f on 2014/31/12 at 4:38 PM PST](https://github.com/tgstation/tgstation/commit/333c566b88108de218d882840e61928a9b759d8f) is licensed under [GNU GPL v3](https://www.gnu.org/licenses/gpl-3.0.html).
(Including tools unless their readme specifies otherwise.)

See LICENSE and GPLv3.txt for more details.

tgui clientside is licensed as a subproject under the MIT license.
Font Awesome font files, used by tgui, are licensed under the SIL Open Font License v1.1
tgui assets are licensed under a [Creative Commons Attribution-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-sa/4.0/).
The TGS3 API is licensed as a subproject under the MIT license.

See tgui/LICENSE.md for the MIT license.
See tgui/assets/fonts/SIL-OFL-1.1-LICENSE.md for the SIL Open Font License.
See the footers of code/\_\_DEFINES/server\_tools.dm, code/modules/server\_tools/st\_commands.dm, and code/modules/server\_tools/st\_inteface.dm for the MIT license.

All assets including icons and sound are under a [Creative Commons 3.0 BY-SA license](https://creativecommons.org/licenses/by-sa/3.0/) unless otherwise indicated.

# Other Codebase Credits
- /tg/, for the codebase.
- CEV Eris, for the PDA sprites
- TGMC, for the custom keybinds base
- Citadel, for their beautiful lighting
