*** Comments ***
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.

*** Settings ***
Metadata            Version        2.0
Metadata            More Info      For more info on this test, see https://
Documentation       Test suite box specific
...                 Test setup and teardown in done in Ansible as part of the NetCICD playbook
...
Suite Setup         Test Box configuration    ${MESSAGE}
Force Tags          box

*** Variables ***
${MESSAGE}          Executing Box stage test suite.

*** Test Cases ***
Test Box configuration
    Log     ${MESSAGE}

Test Hostname
    Log     Hostname validation

Test Banners
    Log     Banner validation

Test Logging
    Log     Create log locally and validate existence in syslog server

Test Console configuration
    Log     Validate that login on the console is possible

Test Aux port configuration
    Log     Validate that login on the aux port is not possible

Test clock and time setup
    Log     Validate that ntp is configured, that the date and time are correct and that ntp is synced

Test Loopback configuration
    Log     Validate that The loopback interface is configured, up and in the mamangement vrf

Test SNMP setup
    Log     Validate that the device is manageable through SNMP for the basic actions
    ...     and that the device sends traps where needed

Test AAA setup
    Log     Validate that normal login goeds through AAA and local login on the console is possible without AAA

Test Hardening
    Log     Validate that all not-used services are disabled

*** Keywords ***