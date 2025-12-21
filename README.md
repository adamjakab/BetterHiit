Better HIIT Datafield
=====================

**Better HIIT Datafield** is an activity data field for Garmin devices. It is geared towards people who need a single easy to read screen when sweat is rolling down their foreheads into their eyes and who do not have enough oxygen
to think about absurd exercise names given by Garmin ("Back Extension with Opposite Arm and Leg Reach" = "Bird Dog").


This data field is the successor of the app called [iHIIT](https://apps.garmin.com/apps/bc02f0f2-9d7d-4476-8aaf-ef99f2e78c33) which was written for devices which did not support HIIT workouts. 

## Setup

- Run `sdkmanager` to install SDKs and devices. Default library home is `~/.Garmin/ConnectIQ`.
- Put your developer key in `.Garmin/ConnectIQ/connectIQ_developer_key`.


## How to use

Once the environment is set up correctly, use the run.sh script with the `run` command:
> $ ./run.sh run

To run for a specific device (e.x.: Forerunner 965):
> $ ./run.sh --device fr965 run

To run tests (not implemented):
> $ ./run.sh test

The `help` command will list the available commands (you can also just omit it). 
> $ ./run.sh help

