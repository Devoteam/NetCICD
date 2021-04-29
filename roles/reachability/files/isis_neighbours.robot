*** Settings ***
Documentation    Suite description

Library        pyats.robot.pyATSRobot

*** Test Cases ***
# Creating test cases from available keywords.

Initialize
    # select the testbed to use
    use testbed "${testbed}"
    run testcase "IsisNeighbours.common_setup"

Verify all ISIS Neighbors are established
    run testcase "IsisNeighbours.IsisNeighbours"
