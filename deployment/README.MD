# Coworking Analytics Deployment Documentation

This document outlines the deployment process for the **Coworking Analytics Application** using **AWS EKS**, **Amazon ECR**, **Kubernetes**, **AWS CodeBuild**, and **CloudWatch**.

## Overview

The deployment process automates the build, test, and deployment lifecycle, ensuring scalability and observability. Key technologies include Docker for containerization, Amazon ECR for storing images, and Kubernetes for orchestration of the containers. AWS CodeBuild automates the build process, while AWS CloudWatch Container Insights provides monitoring and logging for the application.

### CI/CD Workflow
1. **Build**: The pipeline is triggered by updates to the Git repository, which causes AWS CodeBuild to fetch the code, build a Docker image, tag it with the build number, and push it to Amazon ECR.
2. **Deploy**: Kubernetes YAML files (`configmap.yaml` and `coworking.yml`) are applied to the cluster using `kubectl`. This creates or updates the pods, services, and deployments in the Kubernetes cluster.
3. **Monitor**: CloudWatch Container Insights tracks the health of the application, logs any errors, and provides metrics on resource usage.

### Releasing New Builds
1. Ensure the local environment is set up with the AWS CLI and `kubectl`, and that IAM permissions are in place for ECR, EKS, and CloudWatch.
2. Update the application's code, commit changes, and push to the main branch of the Git repository. This triggers the CI/CD pipeline to rebuild the Docker image and push it to ECR.
3. If changes to the Kubernetes configuration are needed (like environment variables or resource adjustments), update the `configmap.yaml` or `coworking.yml` files.
4. Deploy the updated configurations to the Kubernetes cluster with `kubectl apply`.
5. Once deployed, check the status of the pods and services to ensure everything is running as expected.
6. Use AWS CloudWatch Container Insights to monitor the application’s performance and troubleshoot any issues.

This deployment approach ensures a streamlined process for managing and scaling the Coworking Analytics application using AWS services.
