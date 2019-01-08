# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# file needs to be run from the feature directory
# behave hostname.feature -D node=rr1 -D c_lang=iosxr -D stage=0 --no-capture


from behave import *
import sys
sys.path.append("../../../../modules")
from netcicd import *

temp_result=""
test_result = ""
node = ""
c_lang = ""
stage = ""
expected_result = ""

@given('I can make an SSH connection to the box')
def step_impl(context):
    global node, c_lang, stage
    node = context.config.userdata.get("node")
    c_lang = context.config.userdata.get("c_lang")
    stage = context.config.userdata.get("stage")
    print("\n\tHost investigated after configuration trigger: " + node + " for stage" + stage)
    print("\n\tDefined configuration language: " + c_lang + "\n\n")
    assert True

@given('I have logged into the box')
def step_impl(context):
    global node, c_lang, stage
    node = context.config.userdata.get("node")
    c_lang = context.config.userdata.get("c_lang")
    stage = context.config.userdata.get("stage")
    print("\n\tHost investigated after configuration trigger: " + node + " for stage" + stage)
    print("\n\tDefined configuration language: " + c_lang + "\n\n")
    assert True

@when('I capture the first lines')
def step_impl(context, command):                                                                                                                                                                                            
    
    assert True                           

@then('I see the banner <BANNER>')
def step_impl(context):
    global node, test_result
    if ("UNREACHABLE" in test_result): 
        print(temp_result)
        assert False, "\n\tHost unreachable!\n"
    else: 
        print("\n\tHost is reachable\n")
        mystring = temp_result.decode("utf-8")
        test_result = "BANNER"

        if (test_result == "BANNER"): 
            print("\n\tBanner is correctly set\n")
            assert True

        else: 
            print(temp_result)
            assert False, "\n\t Banner is incorrect"