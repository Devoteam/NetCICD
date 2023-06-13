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
    Use PyATS to retrieve the motd banner

Validate banner
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
    Run Keyword If    '${LANG}'=='ios'      Get IOS banner
    Run Keyword If    '${LANG}'=='iosxr'    Get IOSXR banner
    Run Keyword If    '${LANG}'=='nxos'     Get NXOS banner
    Log    The configured banner is: ${banner}    console=yes

Compare configured name to given name
    Should Be Equal     ${banner}    ${motd_banner}

Get IOS prameters
    ${response}=      parse "show banner motd" on device "${NODE}"
    Log    ${response}    console=yes
    Set Suite Variable    ${banner}    ${response['version']['hostname']}

Get IOSXR prameters
    ${response}=   parse "show banner motd" on device ${NODE}
    Set Suite Variable    ${banner}    ${response}

Get NXOS prameters
    ${response}=      parse "show banner motd" on device "${NODE}"
    Log    ${response}    console=yes
    Set Suite Variable    ${banner}    ${response['platform']['hardware']['device_name']}
