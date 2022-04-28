# Terraform Kata

Un petit mot sur la façon dont ce Kata est structuré. Chaque en-tête numérique ci-dessous est une itération de votre fichier terraform qui vous aidera à introduire un nouveau concept.[Si vous souhaitez considérer ce document comme un guide pas à pas, vous pouvez commencer ici](Instructions/README.md). Tout le contenu est le même, mais certaines personnes ont eu plus de facilité à suivre les petits documents.

Les numéros de dossier dans le [GitLab Repo](https://gitlab.ippon.fr/jscharf/terraformkata) servent de réponse pour le concept correspondant afin de vérifier vos réponses ou de vous donner une solution si vous êtes bloqué. Vous devriez créer vos propres dossiers tout au long du Kata.

## Qu'est-ce que Terraform ?

[Terraform by HashiCorp](https://www.terraform.io/) "est un outil logiciel open-source d'infrastructure en tant que code qui fournit un flux de travail CLI cohérent pour gérer des centaines de services en nuage. Terraform codifie les API de nuage dans des fichiers de configuration déclaratifs."

Ce que cela signifie réellement, c'est que Terraform vous permet d'utiliser un processus cohérent pour approvisionner et gérer votre infrastructure en nuage, quel que soit le service en nuage que vous utilisez. Grâce au HCL (HashiCorp Configuration Language), vous pouvez gérer l'ensemble de votre infrastructure en tant que code. Cela présente l'avantage supplémentaire de ne plus avoir besoin de connaître les subtilités de l'API de chaque service ou d'utiliser leur mécanisme de provisionnement natif.

Terraform est une technologie déclarative, ce qui signifie que vous spécifiez l'état que vous souhaitez atteindre et Terraform se charge de le faire.

## Pré-requis

https://cloud.google.com/docs/terraform/get-started-with-terraform?hl=fr

### **Sélectionner ou créer un projet**

Dans Google Cloud Console, accédez à la page de sélection du projet.

[Accéder au sélecteur de projet](https://console.cloud.google.com/projectselector2/home/dashboard?hl=fr&_ga=2.26325172.807002807.1651086738-997347237.1649762783&_gac=1.27728206.1650559456.Cj0KCQjwgYSTBhDKARIsAB8Kuku36Hk2k82u55xBcNxRZuEwWaaWKMf3eQJAJPWz86oC2T2Ipje-V_oaAisTEALw_wcB)

Sélectionnez ou créez un projet Google Cloud.

Vérifier que la facturation a bien été mise en place sur le projet. Sélectionner l'onglet Facturation puis Vue d'ensesemble.

### **Configurer les autorisations**

Assurez-vous que vous disposez des autorisations Compute Engine nécessaires sur votre compte utilisateur:

compute.instance._
compute.firewalls._

[Accéder à la page IAM](https://console.cloud.google.com/iam-admin/iam?hl=fr&_ga=2.26325172.807002807.1651086738-997347237.1649762783&_gac=1.27728206.1650559456.Cj0KCQjwgYSTBhDKARIsAB8Kuku36Hk2k82u55xBcNxRZuEwWaaWKMf3eQJAJPWz86oC2T2Ipje-V_oaAisTEALw_wcB)

### **Activer les API**

Activer les API Compute Engine and OS Login.

[Activer les API](https://console.cloud.google.com/flows/enableapi?apiid=compute.googleapis.com%2Coslogin.googleapis.com&hl=fr&_ga=2.24680627.807002807.1651086738-997347237.1649762783&_gac=1.91281768.1650559456.Cj0KCQjwgYSTBhDKARIsAB8Kuku36Hk2k82u55xBcNxRZuEwWaaWKMf3eQJAJPWz86oC2T2Ipje-V_oaAisTEALw_wcB)

### **Installer la CLI gcloud**

https://cloud.google.com/sdk/docs/install

Télécharger le fichier d'archive **Linux 64 bits** à l'aide de la commande ci-dessous

```
curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-382.0.0-linux-x86_64.tar.gz
```

Extrayez le contenu du fichier vers n'importe quel emplacement de votre système de fichiers (de préférence votre répertoire d'accueil).

```
tar -xf google-cloud-cli-382.0.0-linux-x86_64.tar.gz
```

Exécutez le script (à partir de la racine du dossier dans lequel vous l'avez extrait) à l'aide de la commande suivante :

```
./google-cloud-sdk/install.sh
```

Ouvrez un nouveau terminal pour que les modifications prennent effet.

Pour initialiser gcloud CLI, exécutez la commande gcloud init :

```
./google-cloud-sdk/bin/gcloud init
```

Si Terraform n'est pas installé sur votre système, vous pouvez trouver le guide d'installation [here](https://learn.hashicorp.com/tutorials/terraform/install-cli).

Étant donné qu'au moment de la rédaction de cet article, tout le monde utilise un Ubuntu, vous pouvez télécharger Terraform avec en utilisant les commandes suivantes.

```
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform
```

Exécutez la commande suivante et assurez-vous que vous êtes au moins sur la version v1.0.0 (Notez que ce Kata a été validé pour la dernière fois en utilisant la v1.0.7).

`terraform --version`

## 00

Avant de commencer, il y a quelques concepts et commandes utiles que vous devez connaître.

Lorsque vous utilisez Terraform, il est très important d'effectuer tout changement d'infrastructure au sein de Terraform. Terraform a le concept d'un fichier d'état. Si des modifications sont effectuées manuellement, Terraform ne sera plus en mesure de gérer facilement l'infrastructure.

Terraform est à la fois constructif et destructif en fonction de ce qui se trouve dans les fichiers Terraform. Cela signifie que chaque fois que vous exécutez vos commandes Terraform, il synchronise votre infrastructure avec ce qui se trouve dans le fichier. Terraform déterminera si l'infrastructure doit être créée, détruite ou laissée dans son état actuel.

`terraform validate` vérifiera votre fichier terraform pour s'assurer que vous utilisez la bonne syntaxe.

`terraform plan` vous donnera un aperçu des actions qui vont se produire en fonction de votre fichier Terraform actuel.

`terraform apply` synchronisera votre infrastructure avec l'état actuel du fichier Terraform.

`terraform destroy` nettoiera toute l'infrastructure définie dans le fichier Terraform.

## 01

Si vous ne l'avez pas encore fait, créez un répertoire de travail dans lequel vous allez travailler sur ce Kata. Créez un nouveau fichier dans ce répertoire appelé `main.tf` et ouvrez ce fichier dans votre IDE.

Dans ce fichier, nous allons ajouter notre [provider](https://www.terraform.io/docs/language/providers/index.html). Prenez un moment pour consulter les documents sur [Terraform Providers](https://www.terraform.io/docs/language/providers/index.html). Le concept important à saisir ici est que le fournisseur vous permet d'interagir entre Terraform et le service que vous utilisez, dans ce cas GCP.

Nous allons maintenant ajouter le [GCP Terraform provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs) en ajoutant le bloc suivant à notre `main.tf`

```
terraform {
  required_providers {
    google = {
    }
  }
}
provider "google" {
  project     = "{{YOUR_PROJECT_ID}}"
  region      = "us-central1"
  zone        = "us-central1-c"
}
```

Ce bloc indique à Terraform que nous utilisons AWS et que nous allons déployer notre infrastructure dans `us-east-1-b`.

Après avoir enregistré ce fichier, exécutez `terraform init`

[Terraform init](https://www.terraform.io/docs/cli/commands/init.html) initialise votre répertoire de travail avec quelques fichiers et répertoires cachés dont Terraform a besoin.

## 02

Nous allons maintenant créer une instance EC2. Celles-ci sont appelées `google_compute_instance` dans Terraform. [En utilisant la documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance), nous pouvons voir qu'il existe de nombreux champs pour tout ce que vous pouvez faire avec votre instance, mais nous allons commencer par les bases.

Nous allons créer une instance EC2 qui a

```
name         = "your name"
machine_type = "e2-micro"
```

et avec les étiquettes suivantes

```
creator = "{{YOUR_NAME}}"
project = "{{YOUR_PROJECT_NAME}}"
```

Les labels `creator`, `environment` et `project` sont des labels personnalisés que nous utiliserons dans le cadre d'une bonne hygiène GCP, ils peuvent peut être appliquée à la plupart des ressources GCP. [Documentation relative aux labels GCP](https://cloud.google.com/compute/docs/labeling-resources#api)

Pour créer votre instance, nous allons ajouter ce qui suit à `main.tf`. Aucun autre argument ou balise n'est nécessaire pour `01`.

```
resource "google_compute_instance" "default" {
  //TODO add name and machine type

  labels = {
    //TODO add labels
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }


  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }
}
```

Exécutez `terraform validate` pour valider que vous avez une syntaxe correcte. Exécutez `terraform plan` pour vous assurer que vous créez bien ce que vous pensez. Vous devriez voir `Plan : 1 pour ajouter, 0 pour modifier, 0 pour détruire` en bas de la commande. Lorsque vous êtes satisfait, vous pouvez lancer `terraform apply`. Vous verrez à nouveau votre plan, et si tout semble bon, vous pouvez taper `yes` pour commencer votre déploiement. Vous verrez des mises à jour toutes les 10 secondes vous indiquant que Terraform et GCP travaillent sur votre infrastructure. Selon la complexité de votre infrastructure, cela peut prendre plus ou moins de temps. Vous devriez voir le bloc ci-dessous pendant que votre infrastructure s'approvisionne et se complète.

```
google_compute_instance.default: Creating...
google_compute_instance.default: Still creating... [10s elapsed]

...
google_compute_instance.default: Creation complete after 15s [id=projects/subtle-builder-348511/zones/us-central1-c/instances/-instance]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

Vous pouvez également le voir dans GCP via l'interface utilisateur en allant sur EC2 et en recherchant soit l'`id` qui a été affiché après la création, soit la valeur dans votre label `Name`.

Si vous regardez dans votre répertoire de travail, vous verrez un fichier `terraform.tfstate`. Il est important de laisser ce fichier en place et de ne pas en modifier le contenu. Ce fichier est la façon dont terraform garde la trace de l'infrastructure qu'il gère.

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
