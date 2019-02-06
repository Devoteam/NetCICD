# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

import subprocess

def run_ansible_command(context, node_string, command, stage, module):
    '''
    Takes in a list of ansible nodes and a command
    and executes an ansible ad hoc command.
    '''
    hosts_location = "../../../../vars/stage" + stage

    ansible_command_string = ["ansible", "-i", hosts_location, node_string, "-u", "cisco", "-m " + module + " " + command]
    print ("\n\t" + "  Ansible command: " + " ".join(ansible_command_string) + "\n\n")

    process = subprocess.Popen(ansible_command_string, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    ans_result = process.communicate()
    test_result = ans_result[0]

    if ans_result[1]:
        assert False, "\nCommand: " + " ".join(ansible_command_string) + "\n" + "Ansible Error: " + str(ans_result[1])

    return test_result

def run_ios_command(context, node_string, command, stage, module):
    '''
    Takes in a list of ansible nodes and a command
    and executes an ansible ad hoc command.
    Requires router to be configured with:
    username <USER> priv 15
    aaa new-model
    aaa authorization exec local
    
    and an SSH key using
    ip ssh pubkey-chain
    user cisco
    key-hash
    exit
    exit
    exit
    
    and the key-hash can be extracted from ~/.ssh/id_rsa.pub with 
    ssh-keygen -E MD5 -lf ~/.ssh/id_rsa.pub | awk '{ print $2}' | cut -n -c 5- | sed 's/://g'
    '''
    hosts_location = "../../../../vars/stage" + stage

    ansible_command_string = ["ansible", "-i", hosts_location, node_string, "-e", "ansible_connection=network_cli", "-u", "cisco", "-m", module, "-a", "commands='" + command + "'"]
    print ("\n\t" + "  Ansible command: " + " ".join(ansible_command_string) + "\n\n")
    
    process = subprocess.Popen(ansible_command_string, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    ans_result = process.communicate()
    test_result = ans_result[0]

    if ans_result[1]:
        assert False, "\nCommand: " + " ".join(ansible_command_string) + "\n" + "Ansible Error: " + str(ans_result[1])

    return test_result

def validate_route(data, route, proto, via, metric = ""):
    proto_ok = False
    via_ok = False
    metric_ok = False
    for i in range(1, len(data)):
        if route in data[i]:
            if proto == data[i].split(' ')[0]:
                proto_ok = True
            if data[i].split(' ')[5] == "is":
                #This is a directly connected route and the via is an interface name
                #In the split you need field 9
                if via == data[i].split(' ')[9]:
                    #found
                    via_ok = True
                    #no need to check metric
                    metric_ok = True
            for j in range(i, len(data)):
                if data[j].split(' ')[0] == '':
                    if via in data[j]:
                        #proto ='', this is not the first route in the list to that subnet
                        if via == data[j].split(' ')[23]:
                            #found
                            via_ok = True
                else:
                    if via == data[j].split(' ')[7]:
                        #found
                        via_ok = True
            if metric > "":
                #if a metric is given, check it
                for j in range(i, len(data)):
                    if data[j].split(' ')[0] == '':
                        #proto ='', this is not the first route in the list to that subnet
                        if "[" + metric in data[j]:
                            if metric == data[j].split(' ')[21][1:data[j].split(' ')[21].find('/')]:
                                #found
                                metric_ok = True
                    else:
                        if metric == data[j].split(' ')[5][1:data[j].split(' ')[5].find('/')]:
                            #found
                            metric_ok = True
            else:
                #no metric given
                metric_ok = True
    return (proto_ok and via_ok and metric_ok)

BEHAVE_DEBUG_ON_ERROR = False

def setup_debug_on_error(userdata):
    global BEHAVE_DEBUG_ON_ERROR
    BEHAVE_DEBUG_ON_ERROR = userdata.getbool("BEHAVE_DEBUG_ON_ERROR")

def before_all(context):
    setup_debug_on_error(context.config.userdata)

def after_step(context, step):
    if BEHAVE_DEBUG_ON_ERROR and step.status == "failed":
        # -- ENTER DEBUGGER: Zoom in on failure location.
        # NOTE: Use IPython debugger, same for pdb (basic python debugger).
        import ipdb
        ipdb.post_mortem(step.exc_traceback)