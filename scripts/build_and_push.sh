#!/bin/bash

# Function to prompt for input if arguments are not provided
prompt_for_input() {
    read -p "Enter the absolute path to the Dockerfile: " docker_image_path 
    read -p "Enter the custom image tag name: " image_tag
    read -p "Enter the ECR repository name: " ecr_repo
    read -p "Enter the AWS CLI credential profile name: " credential_profile
    read -p "Enter the target platform (e.g., linux/amd64): " target_platform
}

# Check if the required number of arguments is passed, otherwise prompt for input
if [ "$#" -eq 5 ]; then
    docker_image_path="$1"
    image_tag="$2"
    ecr_repo="$3"
    credential_profile="$4"
    target_platform="$5"
else
    prompt_for_input
fi

# Validate that all necessary inputs are provided
if [ -z "$docker_image_path" ] || [ -z "$image_tag" ] || [ -z "$ecr_repo" ] || [ -z "$credential_profile" ] || [ -z "$target_platform" ]; then
    echo "Error: Missing required inputs. Please provide the Dockerfile path, image tag, ECR repository name, AWS CLI credential profile name, and target platform."
    exit 1
fi

# Set the build context to the parent directory of the Dockerfile
build_context=$(dirname "$docker_image_path")

# AWS variables
account_id=$(aws sts get-caller-identity --profile "$credential_profile" --query Account --output text)
region=$(aws configure --profile "$credential_profile" get region)
image_name="$account_id.dkr.ecr.$region.amazonaws.com/$ecr_repo:$image_tag"

# Log in to the ECR registry
aws ecr get-login-password --profile "$credential_profile" --region "$region" | docker login --username AWS --password-stdin "$account_id.dkr.ecr.$region.amazonaws.com"

# Build and push the Docker image with the specified target platform
docker build --platform "$target_platform" -f "$docker_image_path" -t "$image_name" "$build_context"

if [ $? -ne 0 ]; then
    echo "Error: Docker build failed."
    exit 1
fi

docker push "$image_name"

if [ $? -ne 0 ]; then
    echo "Error: Docker push failed."
    exit 1
fi

echo "Docker image successfully built and pushed to ECR: $image_name"
