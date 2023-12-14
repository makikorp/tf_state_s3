data "aws_ami" "ubuntu_server" {
    most_recent = true
    owners = ["099720109477"]

    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
    }    
}

resource "random_id" "eric_node_id" {
  byte_length = 2
  count       = var.main_instance_count
}

resource "aws_key_pair" "eric_auth" {
  key_name = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "ericEC2" {
  count         = var.main_instance_count
  instance_type = var.main_instance_type
  ami           = data.aws_ami.ubuntu_server.id
  key_name = aws_key_pair.eric_auth.id
  vpc_security_group_ids = [aws_security_group.eric_security_group.id]
  subnet_id              = aws_subnet.eric_public_subnet[count.index].id
  root_block_device {
    volume_size = var.main_vol_size
  }
    tags = {
    Name = "ericEC2-${random_id.eric_node_id[count.index].dec}"
  }

  #adds EC2 instance IP address to aws hosts file -- the "aws ec2 wait" command waits for the instance to be running
  provisioner "local-exec" {
    command = "printf '\n${self.public_ip}' >> hosts && aws ec2 wait instance-status-ok --instance-ids ${self.id} --region us-west-2"
  }
}

#Call and run Ansible playbook
resource "null_resource" "install_updates" {
  depends_on = [aws_instance.ericEC2]
  provisioner "local-exec" {
    command = "ansible-playbook -i hosts --key-file /Users/ericmaki/.ssh/awsTerraTest playbooks/updates.yml"
  }
}

output "ericEC2_access" {
  value = {for i in aws_instance.ericEC2[*] : i.tags.Name => "${i.public_ip}"}
}