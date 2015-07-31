## **Postgres db management**

#### **Requirements to run:**

1. Jenkins installed on host computer
      * Given root access
      * Added to list of suddoers that don't require password
      * Install plugins
          * Git plugin
          * Copy artifact plugin
          * NodeJS Plugin
          * Packer
          * Patameterized Trigger plugin

2. Packer installed on host computer
      * Path to packer given to Jenkins user
      * Post processors addon added to packer file

3. Terraform installed on host computer with path visible to Jenkins
      * Path to terraform given to Jenkins user

4. Amazon AWS account

#### **Setup**

* You will use [these files](https://github.com/mmastro94/packer_postgres) to run Packer
* You will use [these files](https://github.com/mmastro94/terraform_postgres) to run Terraform

**Once you have met all reguirements:**

1. Create a new job in jenkins _"Your\_packer\_job\_name"_

2. Under **Source Code Manaagement** select _git_ and use the url:

        https://github.com/mmastro94/packer_postgres.git

3. Under **Build** click on _add build step_ and select _Execute shell_ then enter the following:

        mkdir -p target
        ( [ -r target/terraform.tfvars.json ] || echo '{ "ami_id" : "" }' >target/terraform.tfvars.json )

4. Create another **build step** to _Execute shell_ and enter the following:

        packer build "Your_packer_job_name"

5. Under **Post-build Actions** select _Archive the artifacts_ and input the filename:

        terraform.tfvars.json

6. Save and return to the Jenkins dashboard

7. Create a new job in jenkins _"Your\_terraform\_job\_name"_

8. Under **Source Code Manaagement** select _git_ and use the url:

        https://github.com/mmastro94/terraform_postgres.git

9. Under **Build Triggers** check _Build after other projects are built
    * Within _Projects to watch_ enter in _"Your\_packer\_job\_name"_ in the text box

10. Under **Build** select _Copy artifacts from another project_ and in _project name_ use:

        "Your_packer_job_name"
    Set it to use the Latest seccessful build and check Stable build only and
    under _artifacts to copy_ insert\

        terraform.tfvars.json

11. Under **Build** click on _add build step_ and select _Execute shell_ then enter the following:

        terraform destroy -force -target=aws_instance.web
        TF_LOG=1 terraform apply

12. Save and return to the Jenkins dashboard

**For an exampe environment click [here](http://ec2-52-4-45-221.compute-1.amazonaws.com/)**
#### **Usage**

Once you have completed the above steps, simply click on the build now button to the right of your packer project and watch the builds complete.

![Imgur](http://i.imgur.com/CcR3JA8.png)