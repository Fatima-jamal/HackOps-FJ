provider "aws" {
  region = "us-west-1"
}

module "security_groups" {
  source = "./security_groups"
  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source              = "./ec2"
  sg_id               = module.security_groups.ec2_sg_id
  user_data_script    = "${path.module}/ec2/user_data.sh"  # <- file path only, no file() here
  public_subnet_ids   = module.vpc.public_subnet_ids
}

module "asg" {
  source              = "./asg"
  launch_template_id  = module.ec2.launch_template_id
  subnet_ids          = module.vpc.public_subnet_ids
  alb_sg_id           = module.security_groups.alb_sg_id
}

module "alb" {
  source         = "./alb"
  subnet_ids     = module.vpc.public_subnet_ids
  alb_sg_id      = module.security_groups.alb_sg_id
  target_sg_id   = module.security_groups.ec2_sg_id
  target_port    = 8080
  vpc_id         = module.vpc.vpc_id
}

module "bi_ec2" {
  source        = "./modules/bi_ec2"
  ami_id        = "ami-09f41acd0c74c597b"     # Amazon Linux 2 for us-west-1
  instance_type = "t3.micro"
  subnet_id     = module.vpc.public_subnet_ids[0]
  vpc_id        = module.vpc.vpc_id
  key_name      = "FJMS"
}

module "rds_sg" {
  source = "./modules/rds_sg"
  vpc_id = module.vpc.vpc_id
  allowed_sg_ids = [
    module.security_groups.ec2_sg_id,
    module.bi_ec2.metabase_sg_id
  ]
}

module "rds" {
  source = "./modules/rds"

  vpc_id              = module.vpc.vpc_id
  private_subnet_a_id = module.vpc.private_subnet_a_id
  private_subnet_b_id = module.vpc.private_subnet_b_id
  postgres_sg_id      = module.rds_sg.postgres_sg_id
  db_username         = "postgresadmin"
  db_password         = "StrongPassword123!"
}

module "vpc" {
  source = "./modules/vpc"
}




