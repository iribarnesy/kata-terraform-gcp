# Terraform Kata

A little on how this Kata is structured. Each number header below is an iteration of your terraform file that will help introduce a new concept. [If you wish to view this document as more of a step by step guide, you can start here](Instructions/README.md). All of the content is the same, but some folks had an easier time following along with smaller documents.

The number folders in the [GitLab Repo](https://gitlab.ippon.fr/jscharf/terraformkata) serve as an answer key for the corresponding concept to check your answers, or give you a solution if you get stuck. You should create your own files throughout the Kata.

## What is Terraform

[Terraform by HashiCorp](https://www.terraform.io/) "is an open-source infrastructure as code software tool that provides a consistent CLI workflow to manage hundreds of cloud services. Terraform codifies cloud APIs into declarative configuration files."

What this really means is that Terraform allows you to use a consistent process to provision and manage your cloud infrastructure regardless of which cloud service you are using. Using HCL (HashiCorp Configuration Language), you can manage all of your infrastructure as code. This has the added benefit of no longer needing to know the intricacies of each service's api or use their native provisioning mechanism.

If you followed the guide, you may need to run `export AWS_PROFILE=ippon-aws` to set the active credentials

Terraform is a declarative technology, which means that you specify what your target state is and Terraform will work out how to achieve that state.

## Pre-Requisites

This demo assumes that you already have access to the Ippon AWS account. If you do not have access, Dennis has been a big help in getting access.

To install the AWS CLI, you can run `brew install awscli`

If you have access but have not used the AWS CLI, [use this guide](https://docs.google.com/document/d/1pHJD4wUIbYE2AR_0WfMxuo4bFc4DcwW-fzVNjU11q8w/edit#) to set up your AWS CLI. A few notes when following this guide, if you get a message that says `Invalid username or password` this means that you got the captcha incorrect. If you see the message `Something went wrong - Could not find SAML response...` your most likely typed your password incorrect. Also the token has a relatively short expiration, so you may have to refresh your credentials throughout the Kata. If you see that a command seems to be hanging, it may be time to get a new token.

If you do not have Terraform installed on your system, you can find the installation guide [here](https://learn.hashicorp.com/tutorials/terraform/install-cli).

Since at the time of writing, everyone is using a Mac, you can download Terraform with [homebrew](https://brew.sh/) using the following commands.

```
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

Run the following command and ensure you are on at least version v1.0.0 (Note this Kata was last validated using v1.0.7)

`terraform --version`

If you are not at the target version you can run `brew upgrade terraform` to get the latest version

For this kata, we will use IntelliJ and the CodeWithMe plugin so groups can easily work together.

Finally this Kata is heavily driven by the Terraform docs. There are many embedded links to specific pages in the docs that I encourage you to read for additional context, guidance, and syntax.

## 00

Before we get started there are a few useful concepts and commands you should know.about.

When using Terraform, it is very important with Terraform to make any infrastructure changes within Terraform. Terraform has the concept of a statefile. If changes are made manually, Terraform will no longer be able to easily manage the infrastructure.

Terraform is both constructive and destructive based on what is in the Terraform files. This means that every time you execute your Terraform commands, it will sync your infrastructure with what is in the file. Terraform will figure out if there needs to be infrastructure created, destroyed, or left in its current state.

`terraform validate` will check your terraform file to ensure that you are using proper syntax

`terraform plan` will give you a preview of what actions are going to happen based on your current Terraform file.

`terraform apply` will sync your infrastructure with the current state of the Terraform file

`terraform destroy` will clean up all infrastructure defined in Terraform file.

## 01

If you have not already, create a working directory where you will work on this Kata. Create a new file in this directory called `main.tf` and open this file in your IDE.

In this file we will add our [provider](https://www.terraform.io/docs/language/providers/index.html). Take a moment and review the docs about [Terraform Providers](https://www.terraform.io/docs/language/providers/index.html). The important concept to grasp here is that the provider allows you to interact between Terraform and the service you are using, this this case AWS.

Now we will add the [AWS Terraform provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) by adding the following block to our `main.tf`

```
terraform {
  required_providers {
    aws = {
    }
  }
}
provider "aws" {
  region = "us-east-1"
}
```

This block both tells Terraform that we are using AWS and that we are going to be deploying our infrastructure in to `us-east-1`.

After saving this file, run `terraform init`. [Terraform init](https://www.terraform.io/docs/cli/commands/init.html) initializes your working directory with a few different hidden files and directories that Terraform needs.

## 02

Now we are going to create an EC2 instance. These are called `aws_instance` in Terraform. [Using the docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) we can see that there are many fields for anything you could want to do with your instance, but we will start off with the basics.

We are going to create an EC2 instance that has

```
ami = "ami-0c2b8ca1dad447f8a"
instance_type = "t2.micro"
```

and with the following tags

```
Name = "your name"
User = "your name"
project = "TerraformDemo"
```

The `Name` tag will give your instance a name to make it easier to find, and the `User` and `project` tags are custom tags we will use as part of good AWS hygiene. [The documentation for tags can be found here](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/guides/resource-tagging) and can be applied to most AWS resources.

To create your instance we will add the following to `main.tf`. No other arguments or tags are needed for `01`

```
resource "aws_instance" "web" {
  //TODO add ami and instance type

  tags = {
  //TODO add tags
  }
}
```

Run `terraform validate` to validate that you have proper syntax. Run `terraform plan` to ensure that you are creating what you think you are. You should see `Plan: 1 to add, 0 to change, 0 to destroy.` at the bottom of the command. When you are happy, you can run `terraform apply`. You will see your plan again, and if everything looks good you can type `yes` to start your deployment. You will see updates every 10 seconds letting you know that Terraform and AWS are working on your infrastructure. Depending on the complexity of your infrastructure, this can take varying amounts of time. You should see the below block as your infrastructure provisions and completes.

```
aws_instance.web: Creating...
aws_instance.web: Still creating... [10s elapsed]
aws_instance.web: Still creating... [20s elapsed]
...
aws_instance.web: Creation complete after 53s [id=i-04834830fa7d3d3e3]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

You can view this in AWS as well through the UI by going to EC2 and searching for either the `id` that was displayed after creation or searching for the value in your `Name` tag.

If you look in your working directory, you will see a `terraform.tfstate` file. It is important to leave this file in place and not edit it's contents. This file is how terraform keeps track of what infrastructure it is managing.

## 03

Add the `count` argument to `aws_instance` to create 3 ec2 instances

Since you are going from 1 to 3 instances, when you run `terraform plan` you should see `Plan: 2 to add, 0 to change, 0 to destroy` since you have a net +2 in your instances.

After running `terraform apply` and seeing that you were able to create 3 instances, lower the count back to 1.

## 04

Now we are going to create a basic VPC. [Using the docs](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest) create a VPC with `cidr_block = "10.0.0.0/16"` as well as adding all of the same tags we added to the ec2 instance. This block can go below the block we added to create the ec2.

```
resource "aws_vpc" "main" {
  //TODO add cidr block
  //TODO add tags
}
```

`terraform apply` and validate that you see your vpc in the aws console

## 05

Now we will create a subnet. [Using the docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) we are going to create a subnet with `cidr_block = "10.0.1.0/24"`. Since subnets are tied to a vpc, we will use the id of the vpc we created in `vpc_id` argument. This can be done by referencing a variable that is storing the id of the vpc we created. `aws_vpc.main.id` will fill in as the if of the `main` vpc that we created in `04`. Be sure to add your tags as well.

```
resource "aws_subnet" "main_subnet" {
    //TODO vpc_id
    //TODO cidr_block
    //TODO tags
}
```

After you run `terraform apply`, if you look in the console at your new subnet, you should see that it is part of the vpc you created.

## 06

Using what you just learned about referencing a variable, edit your ec2 configuration with the `subnet_id` argument to tie your subnet to your ec2 instance.

To validate that your subnet is now tied to your ec2, go to the ec2 instance in the console, and validate that you see your subnet in the security tab.

## 07

Now we are going to look at a few different ways to dynamically pass parameters in to your terraform file.

Create a new file called `variables.tf`. In this file you declare what variables you plan on using. In our case lets create a variable for `aws_region` and `instance_count`

[Using the documentation](https://www.terraform.io/docs/language/values/variables.html) lets create both of these variables without the default values argument

Be sure to add a description for both variables. `aws_region` will be type `string` and `instance_count` will be type `number`

Before we try and apply this change, we also need to update our `main.tf` to reference these variables. This can be done by putting `var.aws_region` or `var.instance_count` in `main.tf`. Add these to the `aws_region` argument in the provider, and `instance_count` in the ec2 configuration.

Now when you run `terraform apply` you will be asked to enter a value for `aws_region` and `instance_count`. Since we are using a hard coded ami, your region should be `us-east-1`. For your instance count, lets create 5 instances. All of these instances will tie to your same subnet and vpc.

## 08

Since we are exclusively working in `us-east-1` lets go back to `variables.tf` and set that as the default value. We are also going to set the default value for `instance_count` to be 3 instances. When you run `terraform apply` you should no longer be asked for the region or how many instances you want.

## 09

Now that we can use variables, we don't want to have to rely on entering values are run time, nor do we want to be always tied to the default values. We are going to create a new file called `terraform.tfvars`. Where as `main.tf` allows you to define variables, `terraform.tfvars` is where you can set their value

[Using the docs](https://www.terraform.io/docs/language/values/variables.html#variable-definitions-tfvars-files), we can create a `terraform.tfvars` file to set our `instance_count` variable to 2 instances.

Since we are using the default variable file name we do not any additional command line arguments when we run `terraform apply`. When you run `terraform apply` you will end up wth 2 instances without being asked how many you want to provision

run `terraform destroy` to clean up all resources you have created

## 10

Finally lets put all of this, as well as a few other services in to practice and create a very basic website. We use a lot of different services in this section. While it is not important to know exactly what each service does and how they work together to create our webserver, I have provided a small blurb for some of the less commonly used services so you have some context. The important part of this exercise it to get some experience building out your terraform file.

Create a new directory and a new `main.tf` and add the aws provider. Make suer you run `terraform init` in the new directory

1. Create a VPC with argument `cidr_block = "10.0.0.0/16"` and your tags
2. Create an `aws_internet_gateway` with argument `vpc_id = YOUR_VPC_ID` and your tags. [Internet gateway docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway). Internet gateway allows your VPC to communicate with the internet
3. Create an `aws_route_table`. A route table tells AWS how to route network traffic from our subnet. in this case we are going to route all IPv4 and IPv6 traffic to our internet gateway

```
resource "aws_route_table" "route-table" {
  vpc_id = //TODO VPC id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = //TODO aws_internet_gateway id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = //TODO aws_internet_gateway id
  }
  //TODO Tags
}
```

4. Create a subnet with arguments `vpc_id = YOUR_VPC_ID` `cidr_block = "10.0.1.0/24"` and `availability_zone = "us-east-1a"` and your tags
5. Associate your subnet with your route table

```
resource "aws_route_table_association" "a" {
subnet_id = //TODO subnet id
route_table_id = //TODO aws_route_table id
}
```

6. Create a security group with ports 443, 80, and 22 open and your tags. We are using this security group to allow traffic from any IP address to enter through the HTTP, HTTPS, or SSH ports

```
resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow Web inbound traffic"
  vpc_id      = //TODO vpc id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

//TODO Tags
}
```

7. Create a network interface. A network interface can be thought of as a virtual network card.

```
resource "aws_network_interface" "web-server-nic" {
  subnet_id       = //TODO subnet id
  private_ips     = ["10.0.1.50"]
  security_groups = [//TODO security group id (note keep it in the square brackets as this can be a list)]
  //TODO tags
}
```

8. Assign an elastic IP. This section introduces the `depends_on` argument. This usually terraform is good at figuring out the provisioning order, but sometimes it needs some help. [This is usually clearly defined in the docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) "EIP may require IGW to exist prior to association. Use `depends_on` to set an explicit dependency on the IGW." Note: `depends_on` takes a list of dependencies, not IDs. For example, to set an explicit dependency for the security group we created in step 6 we would do `depends_on = [aws_security_group.allow_web]`. Assigning an elastic IP exposes the EC2 instance so that we can access it from the internet.

```
resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = //TODO network interface id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [//TODO internet gateway (Not the ID)]
//TODO tags
}
```

9. Finally we will create our EC2 instance.

```
resource "aws_instance" "web-server-instance" {
  ami               = "ami-085925f297f89fce1"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"

  network_interface {
    device_index         = 0
    network_interface_id = //TODO network interface id
  }

  user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                sudo bash -c 'echo I know some Terraform! > /var/www/html/index.html'
                EOF
//TODO Tags
}
```

10. Finally, terraform is able to print out some variable that it generates during its run such as an ip address, or instance id. We will add a few outputs at the bottom of our file

```
output "server_public_ip" {
  value = aws_eip.one.public_ip
}
output "server_private_ip" {
  value = aws_instance.web-server-instance.private_ip
}
output "server_id" {
  value = aws_instance.web-server-instance.id
}
```

11. If everything went well, when you run `terraform apply` you should be able to create a web server. When it finishes it should return you a public ip address you can go to, which should show you your new website.

12. When you are done, run `terraform destroy` to clean up everything

## Post

Congratulations. You completed the Terraform kata. This kata was small sample of what terraform can do. We looked exclusively at the AWS provider, but [there are providers for every major cloud service as well](https://registry.terraform.io/browse/providers).

Any feedback you have on the Kata is appreciated. Please reach out on slack if you wish to share privately. If you have any improvements that could make this kata better, please open a pull request.
