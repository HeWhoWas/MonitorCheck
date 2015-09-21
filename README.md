# MonitorCheck
Test for an interview. Small monitoring script

## Environment

This application was developed and tested against Ruby 2.0.0. It may work on other versions of ruby, but is unsupported.

## Installation
1. Ensure you have Ruby 2.0.0 installed
2. Ensure that you have Bundler installed, either using system packages or a gem
3. Clone this repository
4. Run "bundle install" to install the dependencies.

## Usage
    ./run_check.rb -c <CHECK_NAME> CHECK_PARAM|CHECK_VAL CHECK_PARAM2|CHECK_VAL2

The script can be run as a standalone file from the commandline with stdout:

    ./run_check.rb -c CheckDisk 'path|/' 'threshold|90' -v; echo $?
    SUCCESS
    Total MB:       61389           Avail MB:       38014           Usage:  61.92%
    0

Or used to send notifications when scheduled with cron:
    
    ./run_check.rb -c CheckDisk 'path|/' 'threshold|90' -n EmailNotification 'to|bettridge.ben@example.com'
    SUCCESS

Alternatively it can notify an HTTP endpoint.

    ./run_check.rb -c HttpCheck 'url|http://www.google.com.au' 'response|302' -n HttpNotification 'notify_url|http://www.remoteserver.com/payload.php'
    SUCCESS

### Plugins
* Checks and notifications are plugins following the naming format: "NameCheck" or "NameNotification" and placed in the correct folder.
* All plugins must adhere to the Base_* class contract found in the same folder.

### Help
    -c, --check-name=<s>            The name of the check you wish to run
    -d, --delimiter=<s>             Delimiter to use when splitting params (default: |)
    -n, --notification-name=<s>     The name of the notification type you wish to send
    -v, --verbose                   Use verbose output
    -e, --version                   Print version and exit
    -h, --help                      Show this message
