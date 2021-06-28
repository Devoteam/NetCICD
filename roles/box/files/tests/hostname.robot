*** Settings ***
Documentation     Testing the correct setting of the hostname.

*** Tasks ***
Display calling arguments
    Show Arguments

Connect to node
    Use PyATS to connect to the router

Retrieve hostname
    Use PyATS to retrieve the hostname

Validate hostname
    Compare retrieved hostname to given node

*** Keywords ***
Show arguments
    Log To Console    \n
    Log To Console    The node name is:              ${NODE}
    Log To Console    The node CLI language is:      ${LANG}
    Log To Console    The stage is:                  ${STAGE}
    Log To Console    \n

Use PyATS to connect to the router
    Log to Console    Connecting to                  ${NODE}

Use PyATS to retrieve the hostname
    Log To Console    The configured node name is:   ${NODE}

Compare retrieved hostname to given node
    Should Be Equal   ${NODE}    ${NODE}
