*** Settings ***
Documentation     Testing the correct setting of the hostname.

Library        ats.robot.pyATSRobot
Library        genie.libs.robot.GenieRobot
Library        genie.libs.robot.GenieRobotApis
Library        unicon.robot.UniconRobot
Library        collections

*** Variables ***
${C_HOSTNAME}       ${NODE}
${testbed}          pyats-box.yaml

*** Tasks ***
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
    Log    The node name is: ${NODE}    console=yes
    Log    The node CLI language is: ${LANG}    console=yes
    Log    The stage is: ${STAGE}    console=yes

Use PyATS to connect to the router
    use testbed "${testbed}"
    connect to device    ${NODE}
    Log    Connecting to ${NODE}    console=yes

Use PyATS to retrieve the hostname
    Run Keyword If    '${LANG}'=='ios'      Get IOS prameters
    Run Keyword If    '${LANG}'=='iosxr'    Get IOSXR prameters
    Run Keyword If    '${LANG}'=='nxos'     Get NXOS prameters
    Log    The configured node name is: ${host}    console=yes

Compare configured name to given name
    Should Be Equal     ${host}    ${NODE}

Get IOS prameters
    ${response}=      parse "show version" on device "${NODE}"
    Log    ${response}    console=yes
    Set Suite Variable    ${host}    ${response['version']['hostname']}

Get IOSXR prameters
    ${response}=   get running config hostname  device=${NODE}
    Set Suite Variable    ${host}    ${response}

Get NXOS prameters
    ${response}=      parse "show version" on device "${NODE}"
    Log    ${response}    console=yes
    Set Suite Variable    ${host}    ${response['platform']['hardware']['device_name']}
