# Lab 5 Instructor Guide

On your IBM i, please ensure that public ssh key authentication is set up for the user and that the prerequisites are installed on the IBM i system (https://github.com/IBM/ansible-for-i: 5733SC1 Base and Option 1, 5770DG1, python3, python3-itoolkit, python3-ibm_db)

0. SSH into the IBM i server
`ssh -i path/to/pem_user_privatekey_download.pem <OS_USER_NAME>@<IBMi_IP_ADDRESS>`

1. Generate an ssh key on your local
`ssh-keygen -t rsa -b 4096 -C "identifier e.g. ibmi-liam"`

2. Copy the key to your IBM i machine
```
ssh -i path/to/pem_user_privatekey_download.pem \
  -L 8076:localhost:8076 \
  cecuser@<IBMi_IP>
```

3. Test the connection, you shouldn't be prompted for a password this time
`ssh <USERNAME>@<IBMi_IP>`

If you need to set one up...

2. Verify installations
```
/QOpenSys/pkgs/bin/python3.9 --version
/QOpenSys/pkgs/bin/yum search python39-itoolkit
/QOpenSys/pkgs/bin/yum search python39-ibm_db
```

If not installed, install the missing package/s:
```
/QOpenSys/pkgs/bin/yum install python3.9 
/QOpenSys/pkgs/bin/yum install python39-itoolkit
/QOpenSys/pkgs/bin/yum install python39-ibm_db
```
