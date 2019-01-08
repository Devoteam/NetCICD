# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

Feature: Banners on connecting to a device and when changing privilege levels. Banners configured are exec and motd.

  Scenario: User connects to a box with ssh and gets the correct banner
    Given I ssh to the box
      And I capture the first lines
     Then I see the banner <BANNER>

  Scenario: User provides credentials and is greeted with the correct MOTD banner
    Given I have logged into the box
     When I capture the first lines
     Then I see the banner <BANNER>
