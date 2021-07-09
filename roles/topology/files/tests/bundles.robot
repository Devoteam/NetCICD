*** Settings ***
Documentation     Testing the correct setting of links.

Library        ats.robot.pyATSRobot
Library        genie.libs.robot.GenieRobot
Library        genie.libs.robot.GenieRobotApis
Library        unicon.robot.UniconRobot
Library        collections

*** Variables ***
${C_HOSTNAME}       ${NODE}
${testbed}          pyats-topology.yaml

*** Tasks ***
Display calling arguments
    Show Arguments

Connect to node
    Use PyATS to connect to the local router
    Use PyATS to connect to the remote router

Retrieve link state
    Use PyATS to retrieve the link state

Validate link 
    Make sure links are connected to the correct remote interfaces

*** Keywords ***
Show arguments
    Log To Console    \n
    Log To Console    The node name is: ${NODE}
    Log To Console    The node CLI language is: ${LANG}
    Log To Console    The stage is: ${STAGE}
    Log To Console    \n

Use PyATS to connect to the local router
    use testbed "${testbed}"
    connect to device    ${NODE}
    Log to Console    Connecting to ${NODE}

Use PyATS to connect to the remote router
    use testbed "${testbed}"
    connect to device    ${remote}
    Log to Console    Connecting to ${remote}

Make sure links are connected to the correct remote interfaces