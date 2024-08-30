# Deploy Python Dash & R Shiny apps with ShinyProxy, Docker, Amazon EC2, and Cognito

This repository contains the source code and scripts to deploy Python Dash and R shiny applications using Docker, [ShinyProxy](https://www.shinyproxy.io/#what-is-shinyproxy), and Amazon Web Services (AWS). For a detailed step-by-step guide, please refer to the [full article](https://www.kenwuyang.com/en/post/deploying-python-dash-and-r-shiny-apps-with-shinyproxy-docker-amazon-ec2-and-cognito/).

## Overview

```bash
.
├── README.md
├── apps
│   ├── dash_app
│   │   ├── Dockerfile.dash
│   │   ├── app.py
│   │   ├── entrypoint.py
│   │   └── requirements.txt
│   └── shiny_app
│       ├── Dockerfile.shiny
│       └── app.R
├── cloudformation
│   ├── shinyproxy-cognito.yaml
│   └── shinyproxy-vpc.yaml
├── configuration_files
│   ├── application.yaml
│   └── shinyproxy.conf
└── scripts
    └── build_and_push.sh
```

- **`apps/`**: Contains two simply R Shiny and Python Dash applications, along with their Dockerfiles and associated scripts.

  - **`dash_app/`**: Dash application files.

  - **`shiny_app/`**: Shiny application files.
  
- **`cloudformation/`**: CloudFormation templates for setting up AWS resources like VPC and Cognito.

  - **`shinyproxy-cognito.yaml`**: Template for setting up Cognito User Pool and related resources.

  - **`shinyproxy-vpc.yaml`**: Template for setting up the VPC and related networking components.

- **`configuration_files/`**: Configuration files for ShinyProxy and Nginx.

  - **`application.yaml`**: ShinyProxy configuration file.

  - **`shinyproxy.conf`**: Nginx configuration file for reverse proxying.

- **`scripts/`**: Scripts to assist with building and pushing Docker images.

  - **`build_and_push.sh`**: Script to build Docker images and push them to AWS ECR. This script requires `sudo` privileges and the AWS CLI to be installed and configured.
