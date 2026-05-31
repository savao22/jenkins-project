# Project Deployment & Remote Access Guide 🚀

This repository contains an automated CI/CD pipeline built with **Jenkins, Terraform, and Ansible** to deploy an advanced web dashboard onto an **AWS EC2** instance.

---

## 🔑 Remote Jenkins Access for Evaluation

To review the live Jenkins pipeline execution and configuration, please use the following secure remote access link:

* **Jenkins URL:** [https://mockup-unbroken-error.ngrok-free.dev](https://mockup-unbroken-error.ngrok-free.dev)  
  *(Note: Please ensure you use the exact updated URL provided during active evaluation hours).*

### 🔐 Credentials
Please log in using the dedicated evaluator account created for you:


---

## 🖥️ Live Infrastructure Architecture

The pipeline orchestrates and deploys the following architecture layers dynamically:

1. **Orchestration (Jenkins):** Handles SCM checkout, credentials masking, and triggers infrastructure workflows.
2. **Infrastructure as Code (Terraform):** Automatically provisions a `t3.micro` Ubuntu instance, configures an internet-facing custom VPC/Security Group, and opens necessary inbound communication channels.
3. **Configuration Management (Ansible):** Connects via secure SSH keys, applies patches, provisions the Apache2 web server, and injects the live monitoring dashboard assets.

---

## 📊 Live Web Deployment Dashboard
Once the pipeline stage `Run Ansible Playbook` completes successfully, you can access the public live web server dashboard directly via the generated AWS EC2 public IP printed in the Jenkins post-actions log:

* **Web URL:** `http://52.90.109.86/`
Web URL: http://52.90.109.86/index.html
