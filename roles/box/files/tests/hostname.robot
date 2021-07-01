*** Settings ***
Documentation     Testing the correct setting of the hostname.

Library        ats.robot.pyATSRobot
Library        genie.libs.robot.GenieRobot
Library        unicon.robot.UniconRobot
Library        collections

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
    Compare configured name to given name

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
    Run Keyword If    '${LANG}'=='ios'      Get IOS prameters
    Run Keyword If    '${LANG}'=='iosxr'    Get IOSXR prameters
    Run Keyword If    '${LANG}'=='nxos'     Get NXOS prameters
    Log To Console    The configured node name is: ${host}

Compare configured name to given name
    Should Be Equal     ${host}    ${NODE}

Get IOS prameters
    ${response}=      parse "show version" on device "${NODE}"
    Log To Console    ${response}
    Set Suite Variable    ${host}    ${response['version']['hostname']}

Get IOSXR prameters
    ${response}=      parse "show version" on device "${NODE}"
    Log To Console    ${response}
    Set Suite Variable    ${host}    ${response['version']['hostname']}

Get NXOS prameters
    ${response}=      parse "show version" on device "${NODE}"
    Log To Console    ${response}
    Set Suite Variable    ${host}    ${response['platform']['hardware']['device_name']}
