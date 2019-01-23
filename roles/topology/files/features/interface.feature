# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

Feature: Testing if an interface works 

  Scenario: interface is up
    Given the interface is just configured
     When we execute the command "sh interface"
     Then we see the interface status as up

  Scenario: interface is pingable
    Given the interface is just configured
     When we execute the command "ping interface"
     Then we see !!!!!
