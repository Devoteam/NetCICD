# NetCICD #
## About ##
NetCICD is an Ansible based toolset to facilitate continuous (…) for infrastructure. 

We think practices used in DevOps and CI/CD can be adapted for infrastructure and add significant value. NetCICD is our attempt to make these practices accessible for infrastructure, and networking in particular.

NetCICD takes an industrial automation approach to network development and service deployment, with as ultimate goal: to be able to do CI/CD/CD: 

- Continous Integration of new functionality, including automated testing
- Continuous Delivery of new, tested functionality for deployment to production 
- Continuous Deployment: all new templates and workflows are automagically deployed to production
## Use ##
There are two ways of using NetCICD:

* Within the [NetCICD Developer Toolbox](https://github.com/Devoteam/NetCICD-developer-toolbox)
* Locally with CML

### Within the [NetCICD Developer Toolbox](https://github.com/Devoteam/NetCICD-developer-toolbox) ###
To use NetCICD within the toolbox, just install the toolbox as per the installation instructions and you are good to go.

### Locally ###
If you do not want to install the local toolset and just want to play with NetCICD and CML, you can import the labs in the cml2 directory tp play with. The labs all habe a desktop configured as jumphost.
### More info ###
For more detailed info, see the wiki.
## Background ##
The first implementation was made in 2018 and was presented at [Cisco Live 2018 in Barcelona](https://www.ciscolive.com/c/dam/r/ciscolive/emea/docs/2019/pdf/BRKSDN-2158.pdf). The video of the session can be seen after logging in.

Since then, we used the toolchain, but in that process we experienced that maintaining a tool chain supporting NetCICD remains a challenge. As a result, the [NetCICD Developer Toolbox](https://github.com/Devoteam/NetCICD-developer-toolbox) was created, which is being developed by DevOps Engineers within Devoteam. It contains all tools required (git, Jenkins, Nexus and Keycloak for SSO) to make the NetCICD environment run locally (a supported commercial version is available too, contact networkautomation at devoteam.nl for more information). The tools are configured for NetCICD.

We are working to include [Argos](https://www.argosnotary.com/) to include a continuous auditing mechanism so that it becomes possible to prove that the deployment (git commit) you are running operationally is actually the version tested and for which the test report can be found in you local Nexus repo.

Both NetCICD and the NetCICD Developer Toolbox are aimed towards local deployment, for example on your laptop or within the walled garden of your operations environment.

If you feel you can add to the framework, please do so. 
#### License ###
This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.
#### Copyright ####
(c) Mark Sibering

## Installation ##
Installation should be done by installing the [NetCICD Developer Toolbox](https://github.com/Devoteam/NetCICD-developer-toolbox). This repo can be found in the Gitea environment under the organisation Infraautomator. 
## Environment ##
NetCICD is developed on a Ubuntu 20.04.1 Desktop laptop with CML Personal edition version 2.1. 

For more information see the wiki attached to this repo.

