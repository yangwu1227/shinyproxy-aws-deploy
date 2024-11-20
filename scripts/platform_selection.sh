#!/bin/sh

# Function to prompt user for target platform selection
select_target_platform() {
    echo "Select the target platform:"
    echo "1) amd64 (linux/amd64)"
    echo "2) arm64 (linux/arm64)"
    echo "3) both (linux/amd64, linux/arm64)"
    
    read -p "Enter your choice (1-3): " choice
    
    case $choice in
        1)
            target_platform="linux/amd64"
            ;;
        2)
            target_platform="linux/arm64"
            ;;
        3)
            target_platform="linux/amd64,linux/arm64"
            ;;
        *)
            echo "Invalid choice. Please select 1, 2, or 3."
            select_target_platform
            ;;
    esac
}
