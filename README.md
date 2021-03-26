# Easy launch repo to host and deploy django web application

Are you looking for an easy solution to host highly reliable containerised django application ? <br/>
Would you need a quick CI/CD pipeline to deploy your service with new features ?

## Your search ends here, here is what you can get from this repo

- [x] Cloudformation stacks to launch your infra on ECS platform
- [x] Intutive CI/CD pipeline to deploy new features


## prerequisites

Software  | Version
------------- | -------------
Docker   | 20.x.x
AWS Cli  | 2
AWS Credentials |

## Whats this repo happy about ?
* You need not search for multiple places to launch stack
* Both infra and ci/cd launched in aws

## How to spin up infra and CI/CD pipeline

1. Clone the repository to your local work station
```bash
git clone https://github.com/ramana236/djangoapplication.git
```

2. Execute bash script to launch infra, this script will prompt you for aws region  and aws profile
```bash
bash launchStacks.sh
```
3. When prompted input your aws region as `us-east-1`  (You can choose any region where you would like to launch the infra)
4. When prompted input your aws profile as `dev-user`  (You can choose any profile from configured profiles)

Refer how to configure  [aws profile](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html#cli-configure-quickstart-creds) for assistance.

5. **Khallas!** your infra starts spinning up with in few minutes

----

## Lets dive deeper for more details

<details>
<summary>Infra Structure Stack Break down</summary>
<p>

Infrastructure stack is segregated as micro stacks like below

* Elastic container registry
  `create_ecr_repo.json` launches an ecr repo in specified region <br/>
  **Image Scanning** is enabled on every image uploaded to enhance security

  ##Customisation

  - [x] RepositoryName - can be changed for customisation

* Network
  `create_vpc.json` Network stack is configured with high reliability and Security

  - [x] Two public subnets in two availability zones  (Configured for HA of Lopadbalancer)
  - [x] Two private subnets in two availability zones (Configured for private containers)
  - [x] Security groups to allow only loadbalancer traffic towards hosts  

  ## Customisation
  Feel free to change below variables for customisation
  This stack can also be separately used to launch a standalone network stack

  - [x] VPC name  
  - [x] VPC CIDR
  - [x] Subnets CIDR
  - [x] Subnet names
  - [x] Route table names


* Elastic Container Service
  `create_ecs.json` is the file with resources related to ecs
  - [x] Fargate is leveraged as serverless instance provider
  - [x] Containers running on fargate instances

  ## Customisation
  Feel free to change below variables for customisation

  - [x] Loadbalancer name
  - [x] Cluster Name
  - [x] Container Ports

</p>
</details>

<details>
<summary>Pipeline Stack Break down</summary>
<p>


* Codepipeline
   * Source
   Considering the source of our application would be github <br/>
    - /
      - app
         - cf-example-python-django

         All the content related to django web app resides in this folder <br/>
         Feel free to add your application content to this folder and it auto deploys your latest content through codepipeline
   * Code Build <br/>
     AWS code build service uses `buildspec.yml` file to create a new image on every push using the docker file <br/>
     These new image tags are replaced in `imagedefinitions.json` file <br/>
     With every new commit a new image with tag of commit id will be pushed to ecr

   * Code Deploy <br/>
     One every new image, a new task revision will be created and the ecs service will be updated with new task revision


</p>
</details>



## What could be enhanced or yet to come ?

* Cloudfront in combination with WAF to protect your public endpoint from ddos attacks
* A https listner with SSL enabled and a redirect on your load balancer
