# Dockerized Java App

This repository contains the complete codebase and infrastructure setup for deploying a secure, scalable, and production-ready Java Login Web Application using Docker and Terraform on AWS. It follows DevOps best practices with CI/CD automation, Infrastructure as Code (IaC), monitoring via Metabase, and domain-secured access using Route 53 and ACM.

---

## Project Overview

* **Application:** Java Spring Boot-based login system
* **Infrastructure:** Provisioned using modular Terraform
* **Containers:** Built using multi-stage Dockerfiles for optimized deployment
* **Cloud Provider:** AWS (EC2, ALB, RDS, VPC, IAM, Route 53, ACM)
* **Monitoring:** Metabase BI tool connected to PostgreSQL RDS
* **CI/CD:** Implemented using GitHub Actions

---

## Project Objectives

* Deploy a secure and scalable containerized Java application.
* Use Terraform modules for reusable and maintainable infrastructure provisioning.
* Automate deployment using GitHub Actions.
* Use ALB with HTTPS support and a custom domain for secure access.
* Configure Auto Scaling for fault-tolerance and availability.
* Monitor application activity using Metabase linked to RDS.

---

## Folder Structure

```bash
.
├── terraform/                  # Terraform root configuration
│   ├── main.tf                 # Entry point that includes all modules
│   ├── variables.tf            # Global variables definition
│   ├── terraform.tfvars        # Variable values for AWS setup
│   └── scripts/
│       └── user_data.sh        # Startup script for EC2 instances
│
├── modules/                    # Reusable Terraform modules
│   ├── vpc/                    # Networking resources
│   ├── ec2/                    # EC2 Launch template configuration
│   ├── asg/                    # Auto Scaling Group definition
│   ├── alb/                    # Application Load Balancer with HTTPS
│   ├── rds/                    # PostgreSQL RDS configuration
│   ├── rds_sg/                 # Security Group for RDS
│   ├── security_groups/        # Security rules for all components
│   └── metabase/               # EC2 resource for Metabase BI tool
│
├── docker/
│   └── Dockerfile              # Multi-stage Dockerfile for Java application
│
├── .github/workflows/
│   ├── maven.yml               # CI workflow for building JAR
│   └── docker-build.yml        # Docker build & push workflow
│
├── src/                        # Java source code
├── pom.xml                     # Maven configuration file
└── README.md                   # Project documentation
```

---

## Key Technologies Used

* **Java & Spring Boot** – Backend development
* **Docker** – Multi-stage containerization
* **Terraform** – Infrastructure provisioning
* **AWS Services:**

  * EC2 (Auto Scaling)
  * ALB (HTTPS Load Balancer)
  * RDS (PostgreSQL)
  * Route 53 + ACM (Domain and SSL)
  * IAM, VPC, Subnets, and Security Groups
* **Metabase** – BI tool for real-time dashboarding
* **GitHub Actions** – Continuous Integration and Delivery

---

## Features Implemented

* Java Login App built and containerized using Maven and Docker
* Image pushed to DockerHub via GitHub Actions
* EC2 instances launched with Auto Scaling Group
* ALB with HTTPS (via ACM certificate) for secure access
* PostgreSQL RDS hosted in private subnets
* Metabase deployed on a separate EC2 instance to visualize login data
* Complete Infrastructure as Code using modular Terraform
* Security best practices enforced via IAM roles and SG whitelisting

---

## CI/CD Workflow

### GitHub Actions:

* `maven.yml`: Builds the JAR file from Java code on every push
* `docker-build.yml`: Builds and pushes Docker image to DockerHub

These workflows run automatically on every code update to ensure continuous integration and availability.

---

## Security Best Practices Followed

* RDS instance is in private subnet (not publicly accessible)
* EC2 SSH access restricted using `.pem` key and specific IP whitelisting
* IAM roles are scoped minimally for Terraform and EC2 actions
* All traffic controlled using tight Security Group rules
* HTTPS enabled for secure web access via ALB + ACM

---

## Pre-requisites

* AWS Account with Access Key and Secret Key
* SSH Key Pair named `FJMS` (for EC2 access)
* Terraform CLI installed (v1.0+)
* Docker installed and DockerHub account created
* GitHub repository connected to Actions

---

## Deployment Guide

```bash
# Step 1: Configure AWS CLI
aws configure

# Step 2: Go to Terraform directory
cd terraform

# Step 3: Initialize Terraform
terraform init

# Step 4: Review execution plan
terraform plan

# Step 5: Deploy resources
terraform apply
```

Once complete, Terraform will output:

* ALB DNS (for Java App)
* Metabase EC2 public IP

---

## Application Access

* **Java Login App:** Open ALB DNS URL in browser (e.g. [http://your-alb-dns:8080](http://your-alb-dns:8080))
* **Metabase:** http\://\[EC2-Public-IP]:3000
* **PostgreSQL RDS:** Access via SSH tunnel using EC2 (private subnet)

---

## Monitoring & Observability

* Use AWS Console for:

  * EC2 Health (Auto Scaling Group status)
  * ALB Logs & Target Group Health
  * RDS performance metrics
* Use Metabase for:

  * Real-time dashboarding
  * Password usage charts
  * User sign-up trends and login patterns

---

## Teardown Instructions

```bash
# Destroy infrastructure
terraform destroy
```

Note: RDS may take several minutes to delete due to final snapshot settings.

---

## Final Remarks

This project demonstrates a complete cloud-native deployment pipeline using modern DevOps tools and AWS services. It covers containerization, continuous delivery, infrastructure automation, secure access, and observability via dashboards. Ideal for showcasing DevOps and cloud architecture proficiency in real-world scenarios.
