resource "aws_autoscaling_group" "tf" {
  desired_capacity    = 2  
  max_size            = 5   
  min_size            = 2   
  vpc_zone_identifier = [var.subnet_id_2, var.subnet_id_1]

  launch_template {
    id      = aws_launch_template.tf_launch_template.id
    version = "$Latest"
  }
}

resource "aws_launch_template" "tf_launch_template" {
  name_prefix            = "tf-launch_template"
  image_id               = var.image_id                
  instance_type          = var.instance_type            
  key_name               = var.key_name                 
  user_data              = filebase64("${path.root}/apache.sh")
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "terraform_auto_scaling"
    }
  }
}


