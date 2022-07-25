## High level Overview
 Provision a Linux Ubuntu single Tesla V100 GPU VM in Azure cloud and access with SSH key.Which the specific user can levarage the OS update and install the packages to test the applications 
***********************************************************************************************************
## Tools used
install Terraform       ## refer https://learn.hashicorp.com/tutorials/terraform/install-cli
Azure cloud account
AzureRM provider
Ansible
Docker
shell
***********************************************************************************************************
                                ##Terraform
## Infra structure provision
```
*main.tf*    ---> refers all the resources and network configuration
*providers.tf*  ----> refers terraform version and Aurerm provider version
*variables.tf*  -----> refers the default varibles which will required for main.tf 
*output.tf*   ---> refers the output values 
```
***********************************************************************************************************
Execution of terrafrom scripts
                                    ## commands
 ```                                   
`terraform init`   - which it will intialize the required plugins, providers and modules
`terraform plan`   - which it will give plan of your infrastruture we can also use  `terrafrom plan -out plan.out` to output your plan
`terraform apply -auto-approve` or `Terrafrom apply plan.out -auto-approve`  - which it will apply the plan
`terraform destroy -auto-approve`   - which it will destroy your resources and infrastructure
`terrafrom.tfstate`  - it is a json file [log] which has the information of your resources creation with timstaps and many more

 During the infrastruture provsioning, what we can achieve:
 creation of `Virtual network`
 creation of `subnet`
 creation of `security group`
 creation of `nic`
 creation of `publicIP`
 creation of `public_SSH_KEY`
 passing the `script.sh` which it will install the `ansible` 
```
***********************************************************************************************************

## once the infra is provisioned we need to deploy `docker` and upgrade `GPU` using ansible
                                       ## Ansible
For now i have created some playbooks
```
`playbook.yml`  - which it will execute the to install docker and upgrade GPU this can be included with 2 different roles
`roles`
  *install_docker/tasks/main.yml*
  *upgrade_gpu/tasks/main.yml*
 ``` 
 excute the commands 
 `ansible-playbook -i all  playbook.yml`  - it will install docker and upgrade the gpu
    -for now i am limiting the commands and there is possibility to implement with more args
  ***********************************************************************************************************
  
                                        ## DOCKER
 To achieve the task
I have used following commands 
```
`FROM`  - it will refer which base OS image it has to be installed
`RUN`   - it will excute the commands to intall `Go` and `CPP`
`ENV`   - it will excute and create the ENV variables
`ARG`   -  it is used to pass multiple arguments
`ENTRYPOINT` `CMD` - which  it will excute the commands and scripts
```
******************************************************************************************************************

Note it will be enhanced based on the corrections and suggestions
