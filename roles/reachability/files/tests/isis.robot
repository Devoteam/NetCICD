*** Settings ***
Documentation     Testing the correct setting of ISIS.

Library        ats.robot.pyATSRobot
Library        genie.libs.robot.GenieRobot
Library        genie.libs.robot.GenieRobotApis
Library        unicon.robot.UniconRobot
Library        collections

*** Variables ***
${C_HOSTNAME}       ${NODE}
${testbed}          pyats-reachability.yaml

*** Tasks ***
Display calling arguments
    Show Arguments

Connect to node
    Use PyATS to connect to the router

Validate ISIS state
    Use PyATS to retrieve the ISIS state

Validate ISIS neighbors
    Use PyATS to see if all neighbors are up

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

Use PyATS to retrieve the ISIS state
    Run Keyword If    '${LANG}'=='ios'      Get IOS state
    Run Keyword If    '${LANG}'=='iosxr'    Get IOSXR state
    Run Keyword If    '${LANG}'=='nxos'     Get NXOS state
    Log To Console    The ISIS state is: ${state}

Use PyATS to see if all neighbors are up
    Run Keyword If    '${LANG}'=='ios'      Get IOS neighbors
    Run Keyword If    '${LANG}'=='iosxr'    Get IOSXR neighbors
    Run Keyword If    '${LANG}'=='nxos'     Get NXOS neighbors
    Log To Console    The ISIS neigbors: ${neighbors}

Get IOS state
    ${response}=      parse "show isis" on device "${NODE}"
    Log To Console    ${response}
    Set Suite Variable    ${state}    ${response['version']['hostname']}

Get IOSXR state
    ${response}=      parse "show isis" on device "${NODE}"
    Set Suite Variable    ${state}    ${response}

Get NXOS state
    ${response}=      parse "show isis" on device "${NODE}"
    Log To Console    ${response}
    Set Suite Variable    ${state}    ${response['platform']['hardware']['device_name']}

Get IOS neighbors
    ${response}=      parse "show isis topology" on device "${NODE}"
    Log To Console    ${response}
    Set Suite Variable    ${neighbors}    ${response}

Get IOSXR neighbors
    ${response}=   parse "show isis topology" on device "${NODE}"
    Set Suite Variable    ${neighbors}    ${response}

Get NXOS neighbors
    ${response}=      parse "show isis topology" on device "${NODE}"
    Log To Console    ${response}
    Set Suite Variable    ${neighbors}    ${response}
