**Contents**
- [Overview](#overview)
  - [Organization](#organization)
  - [Configuration](#configuration)
- [Terraform Modules](#terraform-modules)
  - [tf_modules/vpc](#tf_modulesvpc)
  - [tf_modules/bastion](#tf_modulesbastion)
- [Terraform Plans](#terraform-plans)
  - [deployment/mparijat-dev/us-east-1/vpc01/](#deploymentmparijat-devus-east-1vpc01)
  - [deployment/mparijat-dev/us-east-1/vpc01-bastion/](#deploymentmparijat-devus-east-1vpc01-bastion)

# Overview

This repo shows how I manage my entire AWS environment and what I have there.

## Organization

The repo has the following structure:

- `tf_modules/`: contains reusable Terraform modules. These are templates to be used elsewhere.
- `deployment/`: actual "deployments". Terraform plans and other code that represents running services and code. It has the following strucure:

  ```
  deployment/
  ├── state/
  ├── account-1
  │   └── region-1
  │   │   ├── app-1
  │   │   └── app-2
  │   └── region-2
  │       └── app-1
  ├── account-2
  │   └── region-1
  │   │   ├── app-1
  │   │   └── app-2
  │   └── region-2
  │       └── app-3
  └── state
  ```

- `state/`: a directory to store all Terraform plan states using the `local` backend. I keep terraform states in one directory so they are not scattered all over the directory tree.
- `account-A/region-B/application-C`: where
  - `account` is a friendly name for an AWS account (e.g. `mparijat-dev`)
  - `region` is the API code for an AWS region (e.g. `us-east-1`)
  - `app-X` is a friendly name of my "application". (e.g. `vpc01`)
- The leaf directory contains a Terraform plan for a group of logically related resources that I wish to deploy in one go. I use the term "application" in the context of this structure to include things that not normally considered applications, such as a VPC. I tag everything with a `Application=*some name*` tag, so I can group resources by this tag in cost explorer, AWS Config, CloudWatch etc.

## Configuration

I am using [CUE](https://cuelang.org/) to manage configuration "variables". Using CUE:

- I have a single "source of truth" for variables that are then used across tools; I generate configuration for Terraform and other tools from CUE.
- I organize my variables as "global", per-account, per-region sets, so I can specify them once and have them automatically be propagated to all applications in that region or account.
- For some per-application level variables, it is important to me to be able to see the values for different applications in one place, and CUE lets me do that instead of having to read multiple application specific files.

I have the following CUE files:

- `globals.cue`: "Global" variables. They contain:
  - Truly global and reusable variables, such as the per-region and per-architecture AMI IDs of the latest base Amazon Linux 2 AMI.
  - Variables that are not global and are application specific, that I nonetheless want to keep in one place. For e.g., I will be creating many VPCs, and I want to ensure theie CIDRs don't accidentally overlap; keeping them in `globals.cue` helps me to that.
- `defs.cue`: Validation rules. CUE calls them "definitions". I use them to ensure that, if I am using the same type of variable in many locations, I specify them conssitently. For e.g., I specify AWS region codes and AZs in many places. The `#Region` "deinfition" in CUE helps me ensure that I only specify valid region code and avoid typos. Helpfully, I can also auto-generate AZ codes from the region code so I have type less and avoid even more mistakes. Additoinally, I can specify some tool specific configuration structures compactly in CUE and have CUE generate the tool's confiuguration.  For e.g., each Terraform plan needs a backend and provider configuration. I have specified the structure and required variables in `defs.cue` and then can autogenerate a Terraform backend and provider configuration per application, saving me lots of typing and mistakes.
- `deployment/deployment.cue`: Some of my applications depend on resources created by other applications. I keep:
  - `_outputs`: a map containing information about dynamically generated resources that needs to be shared between application. For e.g., the variable `_outputs.mparijat-dev.us-east-1.vpc01.vpc_id` stores the value of the VPC ID of the VPC created by the `deployment/mparijat-dev/us-east-1/vpc01/` Terraform plan. Currently, I add information to this file manually. If this becomes cumbersome, I will think about extrating this information automatically from Terraform state files etc.
  - `_deps`: a map of dependencies between applications. For e.g., the value of the variable `_deps.mparijat-dev.us-east-1.vpc01-bastion.vpc_id` is the output variable mentioned above. This allows me to see very clearly which applications depend on resources created by other applications.
- `deployment/*account*/*account.cue*`: per account CUE files that store information specific to that application.
- `deployment/*account*/*region*/*region.cue*`: per region CUE file that store information about an AWS region in that particular account. Since much per-region information is common across AWS accounts, these files actually pull information from the global CUE files.
- `deployment/*account*/*region*/*app*/*app.cue*`: per application CUE file that contain information specific to that application. They pull information from the global, account and region files. They also contain information that is specific to the app and that I don't need to view globally. This file is used to generate other configuration, such as the Terraform backend and provider configuration and "tfvars" files.
- `Makefile.rules` and `deployment/*account*/*region*/*app*/Makefile`: I use GNU `make` to be able to generate all per-app configuration files with one command.

# Terraform Modules

Reusable modules used in [Terraform Plans](#terraform-plans).

## [tf_modules/vpc](tf_modules/simple_vpc/)

Reusable module to create a simple VPC for dev / demo purposes.

## [tf_modules/bastion](tf_modules/bastion/)

Reusable module to create a bastion host in a pre-existing VPC.

# Terraform Plans

Terraform Plans and configuration that are actually deployed. Mostly to AWS.

## [deployment/mparijat-dev/us-east-1/vpc01/](deployment/mparijat-dev/us-east-1/vpc01/)

A shared VPC used by other plans.

## [deployment/mparijat-dev/us-east-1/vpc01-bastion/](deployment/mparijat-dev/us-east-1/vpc01-bastion/)

A bastion host deployed into the shared VPC.
