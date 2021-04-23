DepShield: [![DepShield Badge](https://depshield.sonatype.org/badges/Devoteam/NetCICD/depshield.svg)](https://depshield.github.io)

# NetCICD #
## About ##
NetCICD is an Ansible based toolset to facilitate continuous (…) for infrastructure. In the infrastructure realm, Continuous Development (CI/CD) is not yet common practice. This is partly caused by lack of familiarity with the CI/CD paradigm and the complexity of setting up such an environment. 

We think practices used in DevOps and CI/CD can be adapted for infrastructure and add significant value. NetCICD is our attempt to make these practices accessible for infrastructure, and networking in particular.

NetCICD takes an industrial automation approach to network development and service deployment, with as ultimate goal: to be able to do CI/CD/CD: 

- Continous Integration of new functionality, including automated testing
- Continuous Delivery of new, tested functionality for deployment to production 
- Continuous Deployment: all new templates and workflows are automagically deployed to production
#### Background ####
The first implementation was made in 2018 and was presented at [Cisco Live 2018 in Barcelona](https://www.ciscolive.com/c/dam/r/ciscolive/emea/docs/2019/pdf/BRKSDN-2158.pdf). The video of the session can be seen after logging in.

Since then, we used the toolchain, but in that process we experienced that maintaining a tool chain supporting NetCICD remains a challenge. As a result, the [NetCICD Developer Toolbox](https://github.com/Devoteam/NetCICD-developer-toolbox) was created, which is being developed by DevOps Engineers within Devoteam. It contains all tools required (git, Jenkins, Nexus and Keycloak for SSO) to make the NetCICD environment run locally. The tools are configured for NetCICD.

In addition, tools to support service development and automation are included, like Jupyter Notebook and Node Red. We are working to include [Argos](https://www.argosnotary.com/) to include a continuous auditing mechanism so that it becomes possible to prove that the deployment (git commit) you are running operationally is actually the version tested and for which the test report can be found in you local Nexus repo.

Both NetCICD and the NetCICD Developer Toolbox are aimed towards local deployment, for example on your laptop or within the walled garden of your operations environment. For more information, please contact networkautomation at devoteam.nl.

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

