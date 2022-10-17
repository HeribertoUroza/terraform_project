## This project is to create a Terraform Module to spin up a EKS cluster and display a simple NGINX app

### Step 1
Utilize `.gitignore` file to hide config files with AWS Credentials.

### Step 2
Create VPC. Needs EKS parameters.

### Step 3
Create IGW. 

### Step 4
Create 2 public subnets and 2 private subnets. Each set will be in different AZ's.   
EKS parameter needed for public subnet(map_public_ip_on_launch) 
Both public and private need (tags/kubernetes.io/cluster/eks).
Public needs (tags/kubernetes.io/role/elb).
Private needs (tags/kubernetes.io/role/internal-elb).

### Step 5 
Create aws_eip. These elastic IP's will connect to internet. 

### Step 6 
Create 2 NAT gateways and place with public subnets. 

### Step 7 
Create 3 Route Tables. 1 Public 2 Private </br> 
Public Route Table => Desination: 0.0.0.0/0 Target: IGW </br> 
Private Route Table => Desination: 0.0.0.0/0 Target: NAT </br>
Private Route Table => Desination: 0.0.0.0/0 Target: NAT </br>
VPC Peering Route Table  => Desination: 10.0.0.0/0 Target: VPC peering connection ID

### Step 8
Create 4 Route Table associations for the 4 different subnets
2 RT associations will be the public subnet to the same Public RT
Each private RT association will be with it own NAT gateway

### Step 9 
Create IAM role needed with eks policy. Next attach policy to eks cluster name

### Step 10
 Create EKS Cluster. 
 - Specify IAM role. 
 - Configure VPC parameters and Subnet ID's need to be declared

### Step 11 
Create IAM role for EKS node groups. Create Instant Groups/EKS node groups. 3 Policies needed and need to be attached. Create actual instance groups

### Step 12 
Connect to the cluster with `awk eks --region us-east-1 update-kubeconfig --name eks --profile terraform` .I dont have a profile set up with aws cli, will attempt with terraform file first
- To test successful conneciton `kubectl get svc`

### Step 13
Create simple app with YAML file that utilizes nginx. 
- In YAML file, annotations section help configure Internal Load Balancer. `Type: nlb  Cross-Zone: True  Internal: 0.0.0.0/0`
- Use YAML file to create resources in Kubernetes with `kubectl apply -f <file path>`
- Check resources/pods `kubectl get pods`
- Check services `kubectl get svc`
- Get specific details on a service `kubectl describe svc <NAME OF SERVICE>`
- Create External Load Balancer next with similar steps above
- If it all works, you should be able to see the NGINX site with the external LB's External-IP

-- TROUBLESHOOTING
- (.tf vs .tfvars) For variable files, to normally declare use `.tf` extension. If you would like to overwrite some of the varables, use `terraform apply -var-file="<FILE>.tfvars" `. The `.tfvars` extension can not declare new variables, only rewrite existing.
- (YAML LB's) Make sure subnet tags have the required information so LB's can find them