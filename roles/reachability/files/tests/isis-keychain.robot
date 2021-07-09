*** Settings ***
Documentation     Testing the correct setting of the ISIS keychain.

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

Validate ISIS keychain
    Use PyATS to retrieve the ISIS keychain

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

Use PyATS to retrieve the ISIS keychain
    Run Keyword If    '${LANG}'=='ios'      Get IOS keychain
    Run Keyword If    '${LANG}'=='iosxr'    Get IOSXR keychain
    Run Keyword If    '${LANG}'=='nxos'     Get NXOS keychain
    Log To Console    The ISIS keychain is: ${keychain}

Get IOS keychain
    ${response}=      parse "show isis keychain" on device "${NODE}"
    Log To Console    ${response}
    Set Suite Variable    ${keychain}    ${response}

Get IOSXR keychain
    ${response}=      parse "show isis keychain" on device "${NODE}"
    Log To Console    ${response}
    Set Suite Variable    ${keychain}    ${response}

Get NXOS keychain
    ${response}=      parse "show isis keychain" on device "${NODE}"
    Log To Console    ${response}
    Set Suite Variable    ${keychain}    ${response}
