# MonitorCheck
Test for an interview. Small monitoring script

##Environment

This application was developed and tested against Ruby 2.0.0. It may work on other versions of ruby, but is unsupported.

##Installation
1. Ensure you have Ruby 2.0.0 installed
2. Ensure that you have Bundler installed, either using system packages or a gem
3. Clone this repository
4. Run "bundle install" to install the dependencies.

##Usage
    ./run_check.rb -c <CHECK_NAME> CHECK_PARAM|CHECK_VAL CHECK_PARAM2|CHECK_VAL2

###Examples
    ./run_check.rb -c CheckDisk 'path|/' 'threshold|90'
    ./run_check.rb -c HttpCheck 'url|http://www.google.com.au' 'response|302'
    
###Help
    -c, --check-name=<s>    The name of the check you wish to run              
    -d, --delimiter=<s>     Delimiter to use when splitting params (default: |)
    -v, --verbose           Use verbose output                                 
    -e, --version           Print version and exit                             
    -h, --help              Show this message                                  

###Detecting Success or Failure
All checks will return:

* 0 = Success
* 1 = Failure
* 2 = Argument/Check Error

As well as each check printing the word "SUCCESS" or "FAILURE" to stdout as the first line.
