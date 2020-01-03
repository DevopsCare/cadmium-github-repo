/*
 * Copyright (C) 2019 Risk Focus, Inc. - All Rights Reserved
 * You may use, distribute and modify this code under the
 * terms of the Apache License Version 2.0.
 * http://www.apache.org/licenses
 */

variable "aws_region" {
  type = string
}

variable "org_fqdn" {
  type = string
}

variable "org_rev_fqdn" {
  type = string
}

variable "project_prefix" {
  type = string
}

variable "project_name" {
  type = string
}

variable "github_organization" {
  type = string
}

variable "ci_username" {
  type        = string
  description = "Name of CI account to be added to repos admins. Defaults to Organization github account name from SSM"
  default     = ""
}

variable "github_projects" {
  type = list(string)
}

variable "create_terraform_repo" {
  default = true
}

variable "github_init_repos" {
  default = false
}

variable "github_init_branch" {
  type    = string
  default = "master"
}

variable "repo_is_private" {
  default = true
}
