My First Datascreen
=====================

## Setup

- Run `sdkmanager` to install SDKs and devices. Library home is `~/:Garmin/ConnectIQ`.
- ...


## How to use

Once the environment is set up correctly, run the [run.sh](run.sh) script with the `run` command:
> $ ./run.sh run

To run in debug mode on a [compatible Garmin device](#compatible-devices), e.g., a fenix7:
> $ ./run.sh --device fenix7 run

To run in release mode on a [compatible Garmin device](#compatible-devices), eg fenix7 one:
> $ ./run.sh --device fenix7 --release run

To run tests on a [compatible Garmin device](#compatible-devices), eg fenix7 one:
> $ ./run.sh --device fenix7 test

The `help` command will list the available commands.
> $ ./run.sh help
  ```
  help     Display this help message
  build    Build the datafield for a device
  simu     Start the simulator
  run      Run in the simulator
  debug    Debug with the simulator
  test     Run tests
  clean    Remove bin directory - useful if the simulator is unresponsive
  doc      Generate documentation - in `/bin/doc/`
  pack     Build the datafield as a Connect IQ package
  ```

See `Description > run.sh` for more informations.

Another method to run the project is explained in [Your First Connect IQ App](https://developer.garmin.com/connect-iq/connect-iq-basics/your-first-app/), but is less convenient than using the script.