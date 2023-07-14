# Multi-Tier-Application-Deployment-in-EKS

I am using on demand because spot instances can be retireved anytime


# Multi-Tier Application Deployment on Amazon EKS

This repository provides an example of deploying a multi-tier application on Amazon EKS (Elastic Kubernetes Service). The application consists of a frontend tier, a backend tier, and a database tier. This README file explains the approach, execution steps, prerequisites, and necessary cleanup instructions.

## Approach

The deployment of the multi-tier application on Amazon EKS follows the following high-level approach:

1. Set up the EKS cluster: Provision an EKS cluster on AWS to host the application tiers. Configure networking, security, and compute resources for the cluster.

2. Deploy the database tier: Create a managed database instance using Amazon RDS or any other suitable database service. Configure the necessary database settings, such as security groups, access control, and storage.

3. Deploy the backend tier: Use Kubernetes deployments and services to deploy the backend services or microservices. Configure the required replicas, containers, networking, and environment variables for the backend components.

4. Deploy the frontend tier: Deploy the frontend services, such as web servers, load balancers, or APIs, using Kubernetes deployments and services. Configure the necessary replicas, containers, networking, and environment variables for the frontend components.

5. Configure networking and communication: Set up networking within the EKS cluster to allow communication between the tiers. Configure Kubernetes Services, Ingress controllers, or Load Balancers to route traffic to the appropriate backend and frontend services.

6. Test and validate: Thoroughly test the deployed application to ensure proper communication and functionality between the tiers. Verify that the frontend can access and interact with the backend services, and data flows seamlessly between the tiers.

## Execution Steps

To deploy the multi-tier application on Amazon EKS, follow these steps:

1. Prerequisites:
   - An AWS account with appropriate permissions to create resources like EKS clusters, RDS instances, security groups, etc.
   - The AWS CLI installed and configured with your AWS credentials.
   - Terraform installed on your local machine.

2. Clone the repository:
   ```
   git clone https://github.com/your/repo.git
   cd repo
   ```

3. Modify the configuration:
   - Update the Terraform variables in `terraform.tfvars` to match your desired configuration.
   - Customize the Kubernetes deployment and service manifests in the `kubernetes` directory to align with your application requirements.

4. Initialize Terraform:
   ```
   terraform init
   ```

5. Deploy the infrastructure:
   ```
   terraform apply
   ```

6. Wait for the EKS cluster to be created and resources to be provisioned.

7. Test and validate the application:
   - Access the frontend services using the provided URLs or endpoints.
   - Interact with the application and verify that data flows correctly between the frontend and backend tiers.

8. Clean up:
   ```
   terraform destroy
   ```

## Prerequisites

Before deploying the multi-tier application, ensure you have the following prerequisites:

- An AWS account with appropriate permissions to create resources like EKS clusters, RDS instances, security groups, etc.
- The AWS CLI installed and configured with your AWS credentials.
- Terraform installed on your local machine.

## Cleanup Steps

To clean up and remove the deployed resources:

1. Navigate to the repository directory.
2. Run the following command to destroy the infrastructure:
   ```
   terraform destroy
   ```
3. Confirm the destruction by entering "yes" when prompted.
4. Wait for Terraform to remove the resources. This may take a few minutes.
5. Verify that all resources have been successfully deleted by checking your AWS account.

Please note that the cleanup step will delete all the resources provisioned by Terraform, including the EKS cluster, RDS instance, and associated networking components.

## Conclusion

This README file provides an overview of the approach, execution steps, prerequisites, and cleanup instructions for deploying a multi-tier application on Amazon EKS. Follow the instructions to successfully deploy, test, and clean up the application resources.

For more details and customization options, refer to the documentation within the repository and the official documentation for AWS, Amazon EKS, and Terraform.