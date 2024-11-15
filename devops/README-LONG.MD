# Coworking Analytics Deployment Documentation

This document outlines the deployment process for the **Coworking Analytics Application**. It covers the technologies and tools involved, the deployment pipeline, and the steps required to release new builds.

## Overview

The deployment process leverages **AWS EKS**, **Amazon ECR**, **Kubernetes**, and **AWS CodeBuild** to manage and deploy the application. It is designed to automate the build, test, and deployment lifecycle while maintaining scalability and observability.

### Key Technologies
1. **Docker**: For containerizing the application.
2. **Amazon ECR**: For storing Docker images securely.
3. **AWS CodeBuild**: For building and pushing Docker images to ECR.
4. **Kubernetes**: For orchestrating containerized workloads.
5. **AWS CloudWatch**: For monitoring and logging (enabled via Container Insights).
6. **kubectl**: For managing Kubernetes resources.

---

## Deployment Architecture

### Repository
- The source code is stored in a Git repository.
- The build pipeline is triggered on every update to the main branch.

### CI/CD Workflow
1. **Build**:  
   - AWS CodeBuild fetches the source code.
   - Docker images are built using a `Dockerfile` in the project root.
   - The image is tagged with the `$CODEBUILD_BUILD_NUMBER` and pushed to an Amazon ECR repository.

2. **Deploy**:  
   - Kubernetes manifests (`configmap.yaml` and `coworking.yml` in de `deployment` folder) are applied using `kubectl`.  
   - Kubernetes creates or updates pods, services, and deployments.

3. **Monitor**:  
   - AWS CloudWatch Container Insights provides observability into application logs and resource usage.

---

## Releasing New Builds

### Prerequisites
1. Ensure your local environment is configured with:
   - AWS CLI and `kubectl` installed.
   - Correct AWS IAM permissions for ECR, EKS, and CloudWatch.
2. Verify the `Dockerfile`, `buildspec.yaml`, and Kubernetes manifests are up-to-date.

### Steps to Release a New Build

1. **Update the Code**  
   Push changes to the main branch of the repository. The CI/CD pipeline will automatically:
   - Build a new Docker image.
   - Push the image to Amazon ECR.

2. **Update Kubernetes Deployment**  
   If configuration changes are needed (e.g., environment variables or resource limits), update the Kubernetes YAML files and apply them:
   ```bash
   kubectl apply -f configmap.yaml
   kubectl apply -f coworking.yml
   ```

3. **Verify Deployment**
    Check the status of the pods and services:
    ```bash
    kubectl get pods
    kubectl describe svc coworking
    ```

4. **Test Endpoints**
    Once you have obtained information about the coworking service you can curl the endpoint under `LoadBalancer Ingress: `

    Example:
    ```bash
     curl aac20b299c1774d9ca80e8dfeb3d19b5-751999043.us-east-1.elb.amazonaws.com:5153/api/reports/daily_usage
    ```

5. **Monitor**
    Use AWS CloudWatch Container Insights to ensure the application is healthy and debug issues if needed.
----

**Useful Commands**
```bash
 kubectl config current-context
# Displays the current Kubernetes context in use, identifying the active cluster and user profile.

 eksctl get cluster --region us-east-1 --profile my-aws
# Lists the EKS clusters in the specified AWS region using the provided AWS profile.

 kubectl get namespace
# Lists all namespaces in the Kubernetes cluster.

 kubectl describe deployment coworking
# Provides detailed information about the `coworking` deployment, including pod templates, replicas, and events.

 kubectl describe svc postgresql-service
# Displays detailed information about the `postgresql-service`, including its endpoints, selectors, and exposed ports.

 kubectl get pods
# Lists all pods in the current namespace, showing their status, readiness, and restart counts.

 kubectl get svc
# Lists all services in the current namespace, displaying their types, cluster IPs, and external endpoints.

 kubectl get deployments
# Lists all deployments in the current namespace, showing their desired and current replicas.
```