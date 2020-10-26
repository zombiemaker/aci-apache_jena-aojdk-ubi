#!/bin/bash

# Container image user can:
#
# - use the default entrypoint-specified application using the default parameters (Default ENTRYPOINT + Default CMD)
# - use the default entrypoint-specified application using user defined arguments (Default ENTRYPOINT + User Defined CMD)
# - use a user-specified entrypoint application with user defined arguments (User Defined ENTRYPOINT)

# if default
if [ "$1" = 'default' ]
then
    # Execute default actions
    echo "Running with defaults"
    # Insert your application execute code here
else
    # Execute user supplied args
    echo "Running with user supplied args"
    "$@"
fi

