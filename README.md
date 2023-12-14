tf_state_s3 is a project to use an aws s3 bucket to store the terraform.state file.  DynamoDB is used to store the LockId for the terraform lock file.

We create a VPC and 1 EC2 instance.

I added an Ansible playbook to update the instance with a few few packages

We can see the terraform.state file in the AWS bucket

Looking at dynamoDB we can view the metrics and notice that reads and writes occur when creating the VPC and EC2 instance.  Also, we can see the dynamoDB metrics change, if we modify our compute or networking infrastructure.
