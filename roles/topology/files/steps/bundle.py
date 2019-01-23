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

@given('the bundle is just configured')
def step_impl(context):
    global node, c_lang, stage
    node = context.config.userdata.get("node")
    c_lang = context.config.userdata.get("c_lang")
    stage = context.config.userdata.get("stage")
    print("\n\tHost investigated after configuration trigger: " + node + " for stage" + stage)
    print("\n\tDefined configuration language: " + c_lang + "\n\n")
    assert True

@when('we execute the command "{command}"')
def step_impl(context, command):                                                                                                                                                                                            
    #Get the state from the node                                                                                                                                                                                            
    global node, stage, test_result, c_lang, temp_result                                                                                                                                                                    
                                                                                                                                                                                                                            
    if (c_lang == "ios" or c_lang == "iosxe"):                                                                                                                                                                              
        temp_result = run_ios_command(context, node, command, stage, "ios_command")                                                                                                                                                        
    elif (c_lang == "iosxr"):
        temp_result = run_ios_command(context, node, command, stage, "iosxr_command")                                                                                                                                                        
    elif (c_lang == "nxos"):
        temp_result = run_ios_command(context, node, command, stage, "nxos_command")                                                                                                                                                        
    else: 
        temp_result = run_ansible_command(context, node, command, stage, "raw")
    assert True                           

@then('we see the bundle status as up')
def step_impl(context):
    global node, test_result
    if ("UNREACHABLE" in test_result): 
        print(temp_result)
        assert False, "\n\tHost unreachable!\n"
    else: 
        print("\n\tHost is reachable\n")
        mystring = temp_result.decode("utf-8")
        if (c_lang == "ios" or c_lang == "iosxe" or c_lang =="iosxr" or c_lang=="nxos"):                                                                                                                                                                              
            # iterate over lines, and print out line numbers which contain                                                                                                                                                      
            # the word of interest.                                                                                                                                                                                             
            for i,line in enumerate(mystring.split("\n")):                                                                                                                                                                   
                if ("hostname" in line.strip()): # or word in line.split() to search for full words                                                                                                                               
                    test_result = line.strip('"').split()[1]                                                                                                                                                                        
                    print("The hostname found is: " + test_result + "\n")

        if (test_result == node): 
            print("\n\tHostname is correctly set\n")
            assert True

        else: 
            print(temp_result)
            assert False, "\n\t Hostname is incorrect"

@then('we see !!!!!')
def step_impl(context):
    global node, test_result
    if ("UNREACHABLE" in test_result): 
        print(temp_result)
        assert False, "\n\tHost unreachable!\n"
    else: 
        print("\n\tHost is reachable\n")
        mystring = temp_result.decode("utf-8")
        if (c_lang == "ios" or c_lang == "iosxe" or c_lang =="iosxr" or c_lang=="nxos"):                                                                                                                                                                              
            # iterate over lines, and print out line numbers which contain                                                                                                                                                      
            # the word of interest.                                                                                                                                                                                             
            for i,line in enumerate(mystring.split("\n")):                                                                                                                                                                   
                if ("hostname" in line.strip()): # or word in line.split() to search for full words                                                                                                                               
                    test_result = line.strip('"').split()[1]                                                                                                                                                                        
                    print("The hostname found is: " + test_result + "\n")

        if (test_result == node): 
            print("\n\tHostname is correctly set\n")
            assert True

        else: 
            print(temp_result)
            assert False, "\n\t Hostname is incorrect"