/*
 * Copyright (C) 2019 Risk Focus, Inc. - All Rights Reserved
 * You may use, distribute and modify this code under the
 * terms of the Apache License Version 2.0.
 * http://www.apache.org/licenses
 */

locals {
  ci_username = var.ci_username != "" ? var.ci_username : data.aws_ssm_parameter.github_username.value
}

data "aws_ssm_parameter" "github_username" {
  name = "${var.org_rev_fqdn}.terraform.github-ci.username"
}

data "aws_ssm_parameter" "github_token" {
  name = "${var.org_rev_fqdn}.terraform.github-token"
}

provider "github" {
  token        = data.aws_ssm_parameter.github_token.value
  organization = var.github_organization
}

resource "github_repository" "terraform_repo" {
  count       = var.create_terraform_repo ? 1 : 0
  name        = "${var.project_prefix}-terraform"
  description = "\"${var.project_name}\" Terraform Infrastructure repository"

  private      = var.repo_is_private
  has_issues   = false
  has_wiki     = false
  has_projects = false
  auto_init    = false

  lifecycle {
    ignore_changes = [
      description,
      private,
      has_issues,
      has_wiki,
      has_projects,
      auto_init,
      gitignore_template,
    ]
  }
}

resource "github_repository" "repo" {
  count       = length(var.github_projects)
  name        = "${var.project_prefix}-${var.github_projects[count.index]}"
  description = "\"${var.project_name}\" ${var.github_projects[count.index]} repository"

  private      = true
  has_issues   = false
  has_wiki     = false
  has_projects = false
  auto_init    = var.github_init_repos

  lifecycle {
    ignore_changes = [
      description,
      private,
      has_issues,
      has_wiki,
      has_projects,
      auto_init,
      gitignore_template,
    ]
  }
}

resource "github_team" "admins" {
  name        = "${var.project_prefix}-admins"
  description = "${var.project_name} administrators with full access to repos"
  privacy     = "closed"
}

resource "github_team" "devs" {
  name        = "${var.project_prefix}-developers"
  description = "${var.project_name} developers with usual read-write access to repos"
  privacy     = "closed"
}

resource "github_team_membership" "ci_account" {
  team_id  = github_team.admins.id
  username = local.ci_username
  role     = "member"
}

resource "github_team_repository" "repo_admins_terraform" {
  count      = var.create_terraform_repo ? 1 : 0
  team_id    = github_team.admins.id
  repository = github_repository.terraform_repo[0].name
  permission = "admin"
}

resource "github_team_repository" "repo_admins" {
  count      = length(var.github_projects)
  team_id    = github_team.admins.id
  repository = github_repository.repo.*.name[count.index]
  permission = "admin"
}

resource "github_team_repository" "repo_devs" {
  count      = length(var.github_projects)
  team_id    = github_team.devs.id
  repository = github_repository.repo.*.name[count.index]
  permission = "push"
}

resource "github_branch_protection" "this" {
  count          = var.github_init_repos ? length(var.github_projects) : 0
  repository     = github_repository.repo.*.name[count.index]
  branch         = var.github_init_branch
  enforce_admins = false
}

