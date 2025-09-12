# HCP Terraform Managed Demo Project

A comprehensive demonstration of advanced HCP Terraform concepts including workspace separation, remote state sharing, run triggers, and GitOps workflows.

## 🎯 What This Demonstrates

### Core HCP Terraform Concepts
- **Workspace Separation**: Isolated workspaces for different concerns
- **Remote State Sharing**: Cross-workspace data exchange via `terraform_remote_state`
- **Run Triggers**: Automatic workflow orchestration between workspaces
- **VCS Integration**: Git-driven automation and change detection
- **Variable Sets**: Secure credential sharing across workspaces

### Advanced Terraform Patterns
- **Reusable Modules**: Well-structured, documented modules
- **Dynamic Configuration**: Template-driven resource creation
- **GitOps Workflow**: Infrastructure changes via Git commits
- **Separation of Concerns**: Clear boundaries between different infrastructure components

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    HCP Terraform Organization               │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐    Run Trigger    ┌─────────────────┐  │
│  │ Repos Workspace │ ──────────────────▶│ Info Workspace │  │
│  │                 │                   │                 │  │
│  │ • Creates repos │                   │ • Reads state   │  │
│  │ • Outputs data  │                   │ • Creates info  │  │
│  └─────────────────┘                   └─────────────────┘  │
│           │                                       │         │
│           ▼                                       ▼         │
│  ┌─────────────────┐                   ┌─────────────────┐  │
│  │ GitHub Repos    │                   │ Info Page Repo  │  │
│  │ • test-api-repo │                   │ • Repository    │  │
│  │ • test-web-repo │                   │   listing page  │  │
│  └─────────────────┘                   └─────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## 📁 Project Structure

```
terraform-demo-project-managed/
├── workspaces/                    # Workspace-specific configurations
│   ├── repos/                     # Repository management workspace
│   │   ├── main.tf               # Repository definitions and module calls
│   │   └── outputs.tf            # Outputs for remote state sharing
│   └── infopage/                 # Information page workspace
│       └── main.tf               # Info page creation and remote state access
├── modules/                      # Reusable Terraform modules
│   ├── repositories/             # GitHub repository creation module
│   │   ├── main.tf              # Repository resources and logic
│   │   ├── variables.tf         # Input variables
│   │   └── outputs.tf           # Output values
│   └── infopage/                # Information page creation module
│       ├── main.tf              # Info page repository and content
│       ├── variables.tf         # Input variables
│       └── outputs.tf           # Output values
├── .gitignore                   # Git ignore patterns
└── README.md                    # This file
```

## 🚀 Getting Started

### Prerequisites
- HCP Terraform account
- GitHub account with personal access token
- Basic understanding of Terraform

### Setup Process

1. **Clone this repository**
   ```bash
   git clone <repository-url>
   cd terraform-demo-project-managed
   ```

2. **Set up HCP Terraform infrastructure** (see companion repository)
   - Create HCP workspaces
   - Configure VCS integration
   - Set up variable sets and run triggers

3. **Configure repository definitions**
   - Edit `workspaces/repos/main.tf`
   - Modify the `locals.repositories` block
   - Add/remove/modify repository definitions

4. **Deploy changes**
   ```bash
   git add .
   git commit -m "Update repository configuration"
   git push origin main
   ```

5. **Watch the magic happen**
   - Repos workspace triggers automatically
   - Creates/updates GitHub repositories
   - Run trigger fires info page workspace
   - Info page updates with current repository data

## 📚 Learning Guide

### Key Files to Study

1. **`workspaces/repos/main.tf`**
   - Learn workspace isolation
   - Understand module usage
   - See GitOps in action

2. **`workspaces/infopage/main.tf`**
   - Learn remote state data sources
   - Understand cross-workspace communication
   - See run trigger effects

3. **`modules/repositories/main.tf`**
   - Learn module design patterns
   - Understand dynamic resource creation
   - See template usage and locals

### Concepts Demonstrated

#### Workspace Separation
Each workspace has a specific responsibility:
- **Repos workspace**: Manages GitHub repositories
- **Info page workspace**: Creates documentation/info pages

#### Remote State Sharing
```hcl
data "terraform_remote_state" "repos" {
  backend = "remote"
  config = {
    organization = "your-org"
    workspaces = {
      name = "managed-repos-workspace"
    }
  }
}
```

#### Run Triggers
Automatic workflow orchestration:
1. Repos workspace completes
2. Run trigger fires
3. Info page workspace starts
4. Info page updates with latest data

## 🔧 Customization

### Adding New Repositories
Edit `workspaces/repos/main.tf`:
```hcl
locals {
  repositories = {
    my_new_repo = {
      type     = "backend"
      language = "python"
      has_page = true
    }
  }
}
```

### Adding New Languages
Edit `modules/repositories/main.tf` to add support for new programming languages in the `locals` block.

### Customizing Info Page
Modify `modules/infopage/main.tf` to change the information page format and content.

## 🎓 Educational Value

This project is designed as a comprehensive learning resource for:

- **HCP Terraform Features**: Workspaces, run triggers, remote state
- **Terraform Best Practices**: Module design, variable management, state management
- **GitOps Workflows**: Infrastructure as Code, version control integration
- **Real-world Patterns**: Separation of concerns, automation, scalability

## 🤝 Contributing

This is an educational project. Feel free to:
- Fork and experiment
- Suggest improvements
- Add more examples
- Enhance documentation

## 📄 License

This project is for educational purposes. Use freely for learning and reference.

## 🔗 Related Resources

- [HCP Terraform Documentation](https://developer.hashicorp.com/terraform/cloud-docs)
- [Terraform Module Documentation](https://developer.hashicorp.com/terraform/language/modules)
- [GitHub Provider Documentation](https://registry.terraform.io/providers/integrations/github/latest/docs)

---

**Happy Learning! 🎉**

This project demonstrates production-ready patterns while maintaining educational clarity. Every file is thoroughly commented to help you understand not just *what* is happening, but *why* it's designed that way.