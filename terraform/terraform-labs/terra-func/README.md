# Terra-Func Lab - Terraform Functions and Features

## Overview
This lab demonstrates how to use **Terraform functions** and **meta-arguments** to build a scalable AWS VPC infrastructure with dynamic resource creation. The code uses functions like `count`, `element`, `length`, and dynamic blocks to avoid repetition and make the infrastructure reusable.

---

## Topics Covered ✅

### 1. **Locals**
- **Files:** `local.tf`, `main.tf`, `subnet.tf`
- **Purpose:** Define reusable constant values across the configuration
- **Example:**
  ```hcl
  locals {
    owner      = "necromonger"
    costcenter = "asia-pacific-01"
    Teamdl     = "necromonger@gmail.com"
  }
  ```
- **Usage:** Referenced in tags throughout other resources to maintain consistency

---

### 2. **Count Meta-Argument**
- **Files:** `subnet.tf`, `rt.tf`
- **Purpose:** Create multiple instances of a resource based on a count value
- **Example:**
  ```hcl
  count = length(var.public_cidr_block)  # Creates as many subnets as CIDR blocks provided
  ```
- **Benefit:** Automatically scales resources based on input list size

---

### 3. **Index (count.index)**
- **Files:** `subnet.tf`, `rt.tf`
- **Purpose:** Reference the current iteration index in a count loop
- **Example:**
  ```hcl
  cidr_block = element(var.public_cidr_block, count.index)
  ```
- **Benefit:** Allows accessing different values for each resource instance

---

### 4. **List Functions**
- **Files:** `terraform.tfvars` (data source), `subnet.tf` (usage)
- **Lists Used:**
  - `public_cidr_block` - CIDR blocks for public subnets
  - `private_cidr_block` - CIDR blocks for private subnets
  - `azs` - Availability zones
  - `ingress_ports` - Port numbers for security group rules
- **Benefit:** Centralized list management makes infrastructure flexible and scalable

---

### 5. **Element Function**
- **Files:** `subnet.tf`
- **Purpose:** Retrieve a specific value from a list by index position
- **Example:**
  ```hcl
  cidr_block = element(var.public_cidr_block, count.index)
  availability_zone = element(var.azs, count.index)
  ```
- **Benefit:** Clean syntax for accessing list items (alternative to direct indexing)

---

### 6. **Length Function**
- **Files:** `subnet.tf`, `rt.tf`, `sg.tf`
- **Purpose:** Count the number of items in a list
- **Example:**
  ```hcl
  count = length(var.public_cidr_block)  # Returns number of CIDR blocks
  ```
- **Benefit:** Enables dynamic resource creation without hardcoding numbers

---

### 7. **Dynamic Blocks**
- **Files:** `sg.tf`
- **Purpose:** Generate multiple blocks of configuration from a list/map
- **Example:**
  ```hcl
  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  ```
- **Benefit:** Creates multiple ingress rules from a single list instead of repetitive blocks

---

## Topics NOT Covered ❌

- **For_each** - Alternative to count for more complex iterations
- **Map** - Key-value pair collections (not used in this lab)
- **Lookup** - Function to retrieve values from maps
- **Condition** - Ternary operators and conditional logic
- **Provisioners:**
  - File - Copy files to instances
  - Remote-exec - Run commands on remote instances
  - Local-exec - Run commands on the machine running Terraform

---

## File Descriptions

### **local.tf**
Defines three local values used as default tags and metadata across all resources:
- `owner`: Resource owner identifier
- `costcenter`: BIllable cost center
- `Teamdl`: Team contact email

### **variables.tf**
Declares input variables that accept values from `terraform.tfvars`:
- `aws_region` - AWS region for deployment
- `vpc_cidr` - CIDR block for VPC
- `vpc_name` - Name for the VPC
- `key_name` - EC2 key pair name
- `azs` - List of availability zones
- `public_cidr_block` - List of CIDR blocks for public subnets
- `private_cidr_block` - List of CIDR blocks for private subnets
- `environment` - Environment name (e.g., prod, dev)

### **terraform.tfvars**
Provides actual values for variables:
```hcl
aws_region = "us-east-1"
vpc_cidr = "172.18.0.0/16"
vpc_name = "my-vpc"
azs = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e"]
public_cidr_block = ["172.18.1.0/24", "172.18.2.0/24", "172.18.3.0/24", "172.18.4.0/24", "172.18.5.0/24"]
private_cidr_block = ["172.18.10.0/24", "172.18.20.0/24", "172.18.30.0/24", "172.18.40.0/24", "172.18.50.0/24"]
ingress_ports = [22, 80, 443, 3306, 5432, 6379, 27017, 9200, 9300, 11211, 27017]
```

### **main.tf**
Creates the core VPC infrastructure:
- **VPC** - Main Virtual Private Cloud with DNS hostnames enabled
- **Internet Gateway** - Gateway for public internet access
- **Public Route Table** - Routes traffic to internet gateway for public subnets
- **Private Route Table** - Internal-only routing for private subnets

All resources are tagged using **Locals** for consistency.

### **subnet.tf**
Dynamically creates multiple subnets using **Count** and **Element**:
- **Public Subnets**: 5 subnets created (count = length of public_cidr_block list)
- **Private Subnets**: 5 subnets created (count = length of private_cidr_block list)

Each subnet automatically gets:
- Correct CIDR block from list (via element function)
- Assigned availability zone (via element function)
- Descriptive name with index number (count.index)
- Tags from locals

### **rt.tf**
Associates subnets with route tables using **Count** and **Index**:
- **Public Route Table Association**: Links each public subnet to public route table
- **Private Route Table Association**: Links each private subnet to private route table

### **sg.tf**
Creates a security group with **Dynamic Blocks**:
- Generates multiple ingress rules from the `ingress_ports` list
- Each rule opens a specific port to all incoming traffic (0.0.0.0/0)
- Single egress rule allows all outgoing traffic

---

## Architecture Diagram

```
VPC (172.18.0.0/16)
│
├── Internet Gateway
│   │
│   └── Public Route Table
│       │
│       └── 5 Public Subnets (172.18.1-5.0/24)
│           └── Associated via Route Table Association (count/index)
│
├── Private Route Table
│   │
│   └── 5 Private Subnets (172.18.10-50.0/24)
│       └── Associated via Route Table Association (count/index)
│
└── Security Group (allow_all)
    └── Dynamic Ingress Rules (from ingress_ports list)
        ├── Port 22 (SSH)
        ├── Port 80 (HTTP)
        ├── Port 443 (HTTPS)
        ├── Port 3306 (MySQL)
        ├── Port 5432 (PostgreSQL)
        ├── Port 6379 (Redis)
        ├── Port 27017 (MongoDB)
        ├── Port 9200 (Elasticsearch)
        ├── Port 9300 (Elasticsearch)
        └── Port 11211 (Memcached)
```

---

## How to Use

### 1. Initialize Terraform
```bash
terraform init
```

### 2. Plan the deployment
```bash
terraform plan
```

### 3. Apply the configuration
```bash
terraform apply --auto-approve
```

### 4. Destroy resources when done
```bash
terraform destroy --auto-approve
```

---

## Key Learning Points

1. **Avoid Repetition**: Using `count` and `element` allows creating multiple similar resources without copying code
2. **Dynamic Configuration**: `length()` and lists make infrastructure scalable - change `terraform.tfvars` to adjust scale
3. **Consistent Tagging**: Locals ensure all resources are tagged consistently for billing and organization
4. **Dynamic Blocks**: Generate repeated configuration blocks from data structures
5. **Separation of Concerns**: Variables in separate file, values in tfvars, logic in resource files

---

## Backend Configuration

This Terraform code uses **S3 Backend** for state management:
```hcl
backend "s3" {
  bucket = "sachindevops123465"
  key    = "workspace.statefile"
  region = "us-east-1"
}
```

This stores the Terraform state file in S3, allowing team collaboration and preventing local state file conflicts.

---

## Summary Table

| Function/Feature | File | Used For | Covered ✅ / ❌ |
|---|---|---|---|
| Locals | local.tf | Reusable constants and tags | ✅ |
| Variables | variables.tf | Input placeholders | ✅ |
| Count | subnet.tf, rt.tf | Create multiple resources | ✅ |
| Index | subnet.tf, rt.tf | Access iteration number | ✅ |
| Element | subnet.tf | Retrieve list values by index | ✅ |
| Length | subnet.tf, rt.tf, sg.tf | Count list items | ✅ |
| Dynamic Blocks | sg.tf | Generate repetitive blocks | ✅ |
| For_each | - | Alternative to count | ❌ |
| Map | - | Key-value collections | ❌ |
| Lookup | - | Retrieve map values | ❌ |
| Condition | - | Ternary operators | ❌ |
| Provisioners | - | Execute local/remote commands | ❌ |

