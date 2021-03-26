region="us-east-1"
profile="assignment"


#This command creates ecs ecr stack
echo "Creating ecr stack ..."
aws cloudformation create-stack --stack-name ecr-stack --template-body file://create_ecr_repo.json --region $region --profile $profile > ecr-stack.output
cat ecr-stack.output
#Wait untill stack is created
sleep 15

#Get repo login details
AccountNumber=`cat ecr-stack.output | head -2 | awk -F ":" '{print $6}'`
loginString="$AccountNumber.dkr.ecr.us-east-1.amazonaws.com"
imageTag="$loginString/djangorepo"

#Buid base image and push to the Repository
echo "Building base docker image ..."
docker build -t $imageTag:base .
aws ecr get-login-password --region $region --profile $profile | docker login --username AWS --password-stdin $loginString
docker push $imageTag:base

echo "*****Base Image successfully pushed to repo ******"

#Launch VPC stack
echo "Creating vpc stack ... "
aws cloudformation create-stack --stack-name network-stack --template-body file://create_vpc.json --region $region --profile $profile > vpc-stack.output
cat vpc-stack.output
echo "Waiting for stack resources to be created ..."
sleep 300
echo "Network stack successfully created"
#Launch ECS stack
echo "Launching ecs stack ..."
aws cloudformation create-stack --stack-name ecs-stack --template-body file://create_ecs.json --region $region --profile $profile --capabilities CAPABILITY_NAMED_IAM > ecs-stack.output
cat ecs-stack.output
echo "Waiting for stack resources to be created ..."
sleep 300
echo "ecs stack successfully created"
