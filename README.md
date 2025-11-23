My First Datascreen
=====================

## Setup

- Run `sdkmanager` to install SDKs and devices. Default library home is `~/.Garmin/ConnectIQ`.
- Put your developer key in `.Garmin/ConnectIQ/connectIQ_developer_key`.


## How to use

Once the environment is set up correctly, use the run.sh script with the `run` command:
> $ ./run.sh run

To run for a specific device (e.x.: fenix7):
> $ ./run.sh --device fenix7 run

To run tests (not implemented):
> $ ./run.sh test

The `help` command will list the available commands (you can also just omit it). 
> $ ./run.sh help

