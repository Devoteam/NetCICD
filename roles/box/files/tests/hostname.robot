*** Settings ***
Documentation     Testing the correct setting of the hostname.

Library        pyats.robot.pyATSRobot
Library        genie.libs.robot.GenieRobot
Library        unicon.robot.UniconRobot

*** Variables ***
${C_HOSTNAME}       ${NODE}
${testbed}          pyats-box.yaml

*** Test Cases ***
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
    Log To Console    The node name is: ${NODE}
    Log To Console    The node CLI language is: ${LANG}
    Log To Console    The stage is: ${STAGE}
    Log To Console    \n

Use PyATS to connect to the router
    use testbed "${testbed}"
    connect to device    ${NODE}
    Log to Console    Connecting to ${NODE}

Use PyATS to retrieve the hostname
    ${C_HOSTNAME}=    parse    "show hostname"     on device     ${NODE}
    Log To Console    The configured node name is:     ${C_HOSTNAME}

Compare retrieved hostname to given node
    Should Be Equal   ${C_HOSTNAME}    ${NODE}
