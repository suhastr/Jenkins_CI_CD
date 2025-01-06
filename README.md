# Deploy and Automate a CI/CD Pipeline on Google Cloud Platform

You’re about to learn how to deploy and automate a CI/CD pipeline using Jenkins, Kubernetes, and Docker on the Google Cloud Platform. Below, I have listed the steps with explanations.

## Table of Contents
- [Overview](#overview)
- [Setup Instructions](#setup-instructions)
- [Conclusion](#conclusion)
- [Reference](#reference)
- [Contributors](#contributors)

---

## Overview

This project demonstrates setting up a Kubernetes environment and deploying a CI/CD pipeline using Jenkins. Jenkins is an open-source automation server that facilitates continuous integration and continuous delivery (CI/CD) by automating the processes of building, testing, and deploying software.

---

## Setup Instructions

### Prerequisites
1. A GCP account.
2. A VM instance with your choice of OS.
3. A simple HTML page for testing.

### Installation

1. **GCP Account:**
    
    - To deploy a web server on the Google Cloud Platform (GCP),
    you need an account with billing enabled for the project or Virtual Machine instance you have created.
    

2. **Create a VM Instance:**
    ```
    Create a VM instance with the following configuration:
    - Machine type: n4-standard
    - Standard | 2 vCPUs + 8 GB memory
    - OS: Ubuntu 20.04 LTS
    - Disk: 80 GB Hyperdisk Balanced
    ```

3. **Install Docker, Java, and Rancher:**
    ```bash
    sudo apt update
    sudo apt install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo docker run -d --privileged --restart=unless-stopped -p 80:80 -p 443:443 rancher/rancher:latest
    sudo apt install -y openjdk-17-jdk openjdk-17-jre
    ```

4. **Install Jenkins:**
    Follow the instructions at [Jenkins Debian Repository](https://pkg.jenkins.io/debian-stable/).

5. **Install Kubectl:**
    Follow the installation guide at [Kubernetes Documentation](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/).

6. **Create a Firewall Rule:**
    - Go to the network settings of your instance and create a firewall rule.
    - Add ports `8080` and `30000` with the IP range `0.0.0.0/0`.
    - Edit your VM instance, add `port-8080` and `port-30000` tags under the network tags, and save.

7. **Access Rancher:**
    - Paste the public IP of your VM instance into a browser.
    - Follow the instructions on the Rancher welcome page.
    - Use the following command to retrieve the password:
      ```bash
      docker logs container-id 2>&1 | grep "Bootstrap Password:"
      ```
    - Set your own password on the Rancher welcome page.

8. **Create a Custom Cluster:**
    - Click **Create**, select **Custom**, and name your cluster (e.g., "master").
    - Go to the cluster's management view, click the three dots, and select **Kubectl shell**.
    - Create two files: `deployment.yaml` and `service.yaml`.

    **`deployment.yaml`:**
    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: user-form-deployment
      labels:
        app: user-form
    spec:
      replicas: 3
      selector:
        matchLabels:
          app: user-form
      template:
        metadata:
          labels:
            app: user-form
        spec:
          containers:
          - name: user-form
            image: dunkdock/user-form:latest_1.3
            ports:
            - containerPort: 80
    ```

    **`service.yaml`:**
    ```yaml
    apiVersion: v1
    kind: Service
    metadata:
      name: user-form-service
    spec:
      selector:
        app: user-form
      ports:
        - protocol: TCP
          port: 80
          targetPort: 80
          nodePort: 30000
      type: NodePort
    ```

    **Apply the configurations:**
    ```bash
    kubectl apply -f deployment.yaml
    kubectl apply -f service.yaml
    ```

    - On the VM SSH terminal, create a `.kube` directory and config file, and paste the kubectl config file of your cluster into it:
      ```bash
      mkdir -p /var/lib/jenkins/.kube
      vim /var/lib/jenkins/.kube/config
      ```

9. **Access Jenkins:**
    - Open `http://<public-ip-of-your-vm-instance>:8080` in your browser.
    - Follow the Jenkins welcome page instructions, using this command to retrieve the password:
      ```bash
      cat <directory-provided>
      ```
    - Set up your custom login.

10. **Create a CI/CD Pipeline:**
    - Create a new pipeline item in Jenkins and provide a name.
    - In the pipeline configuration:
      - Enable the **GitHub Project** option and provide the project URL.
      - Select **Pipeline triggers from SCM**, and add the GitHub repository URL.
    - Set up credentials (e.g., Docker access tokens) and bind them to variables in Jenkins.
    - Install required plugins (Docker, Rancher, and Kubernetes) under **Manage Jenkins**.

11. **Build the Pipeline:**
    - Once the Jenkins pipeline is configured, trigger it by clicking **Build Now**.

---

## Conclusion

This 12-step guide introduces various tools and technologies, including Kubernetes, Jenkins, Docker, Rancher, and GitHub. It is an excellent starting point for exploring automation and CI/CD pipelines.

---

## Reference

- **GitHub Source Code:** [Jenkins CI/CD Repository](https://github.com/suhastr/Jenkins_CI_CD)

---

## Contributors

- **Suhas T R**
