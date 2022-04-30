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

`compute.instance.*`
`compute.firewalls.*`

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
  region      = "europe-west1"
  zone        = "europe-west1-c"
}
```

Ce bloc indique à Terraform que nous utilisons GCP et que nous allons déployer notre infrastructure dans `europe-west1-c`.

Après avoir enregistré ce fichier, exécutez `terraform init`

[Terraform init](https://www.terraform.io/docs/cli/commands/init.html) initialise votre répertoire de travail avec quelques fichiers et répertoires cachés dont Terraform a besoin.

## 02

Nous allons maintenant créer une instance EC2. Celles-ci sont appelées `google_compute_instance` dans Terraform. [En utilisant la documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance), nous pouvons voir qu'il existe de nombreux champs pour tout ce que vous pouvez faire avec votre instance, mais nous allons commencer par les bases.

Nous allons créer une instance EC2 qui a

```
name         = "{{YOUR_INSTANCE_NAME}}"
machine_type = "e2-micro"
```

et avec les étiquettes suivantes

```
creator = "{{YOUR_NAME}}"
project = "{{YOUR_PROJECT_NAME}}"
```

Les labels `creator`, `environment` et `project` sont des labels personnalisés que nous utiliserons dans le cadre d'une bonne hygiène GCP, ils peuvent peut être appliquée à la plupart des ressources GCP. [Documentation relative aux labels GCP](https://cloud.google.com/compute/docs/labeling-resources)

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
google_compute_instance.default: Creation complete after 15s [id=projects/subtle-builder-348511/zones/europe-west1-c/instances/-instance]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

Vous pouvez également le voir dans GCP via l'interface utilisateur en allant sur EC2 et en recherchant soit l'`id` qui a été affiché après la création, soit la valeur dans votre label `Name`.

Si vous regardez dans votre répertoire de travail, vous verrez un fichier `terraform.tfstate`. Il est important de laisser ce fichier en place et de ne pas en modifier le contenu. Ce fichier est la façon dont terraform garde la trace de l'infrastructure qu'il gère.

## 03

Ajoutez l'argument `count` à `google_compute_instance` pour créer 3 instances ec2. **Attention chaque instance doit avoir un nom unique**, le count.index permet d'avoir l'index de chaque instance.

Puisque vous passez de 1 à 3 instances, lorsque vous exécutez `terraform plan`, vous devriez voir `Plan : 2 to add, 0 to change, 0 to destroy` puisque vous avez un net +2 dans vos instances.
Après avoir exécuté `terraform apply` et vu que vous avez pu créer 3 instances, ramenez le compte à 1.

## 04

Nous allons maintenant créer un VPC de base. [En utilisant la documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network). Ce bloc peut aller en dessous du bloc que nous avons ajouté pour créer l'ec2.

```
resource "google_compute_network" "vpc" {
  //TODO add required field
}
```

`terraform apply` et vérifiez que vous voyez le vpc dans la console GCP (famille networking des produits GCP).

## 05

Maintenant nous allons créer un subnet. [En utilisant la documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) nous allons créer un subnet avec `ip_cidr_range = "10.0.1.0/24"`. Puisque les subnets sont liés à un vpc, nous allons utiliser l'id du vpc que nous avons créé dans l'argument `network`. Ceci peut être fait en référençant une variable qui stocke l'id du vpc que nous avons créé. `vpc.id` sera rempli comme l'id du vpc `main` que nous avons créé dans `04`. N'oubliez pas d'ajouter vos balises également.

```
resource "google_compute_subnetwork" "vpc_subnet" {
  // TODO name
  // TODO ip_cidr_range
  // TODO region
  // TODO network
}
```

Après avoir exécuté `terraform apply`, si vous regardez dans la console votre nouveau subnet, vous devriez voir qu'il fait partie du vpc que vous avez créé.

## 06

En utilisant ce que vous venez d'apprendre sur le référencement d'une ressource, modifiez dans votre configuration `compute_instance` pour lier votre vpc et votre subnet à votre instance.

Pour valider que votre subnet est maintenant lié à votre ec2, allez à l'instance ec2 dans la console, et validez que vous voyez votre subnet dans l'onglet sécurité.

## 07

Maintenant, nous allons voir différentes façons de passer dynamiquement des paramètres dans votre fichier terraform.

Créez un nouveau fichier appelé `variables.tf`. Dans ce fichier, vous allez déclarer les variables que vous comptez utiliser. Dans notre cas, nous allons créer des variables pour `region`, `project_id` et `instance_count`.

[En utilisant la documentation](https://www.terraform.io/docs/language/values/variables.html) créons ces trois variables sans l'argument des valeurs par défaut.

Assurez-vous d'ajouter une description pour les trois variables. `region` et `project_id` seront de type `string` et `instance_count` de type `number`.

Avant d'essayer d'appliquer ce changement, nous devons également mettre à jour notre fichier `main.tf` pour référencer ces variables. Cela peut être fait en mettant `var.region` ou `var.instance_count` dans `main.tf`. Ajoutez-les aux arguments `project`, `region` et `zone` dans le fournisseur, et `instance_count` dans la configuration de l'instance.

Maintenant, lorsque vous exécutez `terraform apply`, il vous sera demandé d'entrer des valeurs pour `region`, `project_id` et `instance_count`. Pour le nombre d'instances, nous allons créer 2 instances. Toutes ces instances seront reliées au même sous-réseau et au même vpc.

## 08

Puisque nous travaillons exclusivement dans `europe-west1`, retournons dans `variables.tf` et définissons cette valeur par défaut. Nous allons également définir la valeur par défaut de `instance_count` à 2, et celle de `project_id`. Lorsque vous exécutez `terraform apply`, on ne devrait plus vous demander la région, le nombre d'instances et le project id que vous souhaitez.

## 09

Maintenant que nous pouvons utiliser des variables, nous ne voulons pas avoir à entrer des valeurs au moment de l'exécution, et nous ne voulons pas non plus être toujours liés aux valeurs par défaut. Nous allons créer un nouveau fichier appelé `terraform.tfvars`. Alors que `main.tf` vous permet de définir des variables, `terraform.tfvars` est l'endroit où vous pouvez définir leur valeur.

[En utilisant la documentation] (https://www.terraform.io/docs/language/values/variables.html#variable-definitions-tfvars-files), nous pouvons créer un fichier `terraform.tfvars` pour définir notre variable `instance_count` à une instance.

Puisque nous utilisons le nom de fichier de variable par défaut, nous n'avons pas d'arguments de ligne de commande supplémentaires lorsque nous exécutons `terraform apply`. Lorsque vous exécuterez `terraform apply`, vous obtiendrez une instances sans qu'on vous demande combien vous voulez en provisionner.

Exécutez `terraform destroy` pour nettoyer toutes les ressources que vous avez créées.

## 10 - Déployer un site web minimal

Enfin, mettons tout cela, ainsi que quelques autres services, en pratique et créons un site Web très basique. La partie la plus importante de cet exercice est d'acquérir une certaine expérience dans la construction de votre fichier terraform.

Créez un nouveau répertoire et un nouveau `main.tf` et ajoutez le fournisseur GCP. Assurez-vous de lancer `terraform init` dans le nouveau répertoire.

1. Créez un VPC, et un subnet.
2. Créez une IP externe.

Ajoutez une `google_compute_address`, pour créer une ip static.[Documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address)

```
resource "google_compute_address" "vpn_static_ip" {
  name = "{{YOUR_PROJECT_NAME}}-{{YOUR_USERNAME}}-static-ip"
}
```
3. (Optionnel) Créez une règle de firewall qui vous permettra de vous connecter en SSH à la machine. Ajoutez une ressource `google_compute_firewall` pour créer une règle de firewall. Le service IAP de GCP permet de se connecter de manière sécurisée, en SSH, à une instance dans un subnet privé. Pour faire cela il faut néanmoins autoriser les IPs du service IAP (un bloc CIDR fixé en dur).

```
resource "google_compute_firewall" "iap_to_ssh" {
  name    = "{{YOUR_PROJECT_NAME}}-{{YOUR_USERNAME}}-ingress-allow-iap-to-ssh"
  network = # TODO: add VPC **name**
  description = "Allow SSH from IAP sources"

  direction = "INGRESS"
  priority  = 1000

  # Cloud IAP's TCP forwarding netblock
  source_ranges = ["35.235.240.0/20"]

  allow {
    protocol = "tcp"
    ports    = [22]
  }
}
```
4. De la même manière, autorisez la connexion à votre instance depuis internet. Le bloc CIDR pour internet est `0.0.0.0/0`. La connexion de votre navigateur se fait en TCP sur le port 80.

5. Enfin, nous allons créer notre instance. Nous allons relier, le subnet à la network interface et surtout associer une ip externe à notre instance.

Aussi, nous allons insérer un script qui se lancera au démarrage afin que l'instance lance un serveur Apache qui servira une page web statique.
Le script doit être renseigné avec l'attribut `metadata_startup_script`.

Le texte HTML de la page peut être écrit dans un fichier séparé qui sera chargé en utilisant la commande `file("filepath.html")` de Terraform. (Vous pouvez par exemple chercher un gif sur [giphy](https://giphy.com/), puis cliquer sur "Embed" pour avoir un code HTML d'intégration)

```
resource "google_compute_instance" "vm_instance" {
  name         = "{{YOUR_PROJECT_NAME}}-{{YOUR_USERNAME}}-instance"
  machine_type = "e2-micro"

  labels = ...

  boot_disk ...

  network_interface {
    subnetwork = ...
    access_config {
      nat_ip = "${google_compute_address.static_ip.address}"
    }
  }

  metadata_startup_script = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                sudo echo '${file("filepath.html")}' > /var/www/html/index.html
                EOF
}
```

6. Enfin, terraform est capable d'imprimer une variable qu'il génère pendant son exécution, comme une adresse IP ou un identifiant d'instance. Nous allons ajouter quelques sorties au bas de notre fichier. Pour savoir quelles data vous pouvez récupérer sur les ressources n'hésitez pas à consulter les onglets "data sources" de [la documentation de Terraform](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_instance)

```
output "instance_public_ip" {
  value = google_compute_instance.vm_instance.network_interface.0.access_config.0.nat_ip
}
output "instance_private_ip" {
  value = google_compute_instance.vm_instance.network_interface.0.network_ip
}
output "instance_id" {
  value = google_compute_instance.vm_instance.id
}
```

7. Si tout s'est bien passé, lorsque vous lancez `terraform apply`, vous devriez être en mesure de créer un serveur web. Quand il aura terminé, il devrait vous renvoyer une adresse IP publique sur laquelle vous pourrez vous rendre, et qui devrait vous montrer votre nouveau site web.

8. Quand vous avez terminé, exécutez `terraform destroy` pour tout nettoyer.

## Post

Congratulations. You completed the Terraform kata. This kata was small sample of what terraform can do. We looked exclusively at the AWS provider, but [there are providers for every major cloud service as well](https://registry.terraform.io/browse/providers).

Any feedback you have on the Kata is appreciated. Please reach out on slack if you wish to share privately. If you have any improvements that could make this kata better, please open a pull request.
