# cadmium-github-repo

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| aws\_region | n/a | `string` | n/a | yes |
| ci\_username | Name of CI account to be added to repos admins. Defaults to Organization github account name from SSM | `string` | `""` | no |
| create\_terraform\_repo | n/a | `bool` | `true` | no |
| github\_init\_branch | n/a | `string` | `"master"` | no |
| github\_init\_repos | n/a | `bool` | `false` | no |
| github\_organization | n/a | `string` | n/a | yes |
| github\_projects | n/a | `list(string)` | n/a | yes |
| org\_fqdn | n/a | `string` | n/a | yes |
| org\_rev\_fqdn | n/a | `string` | n/a | yes |
| project\_name | n/a | `string` | n/a | yes |
| project\_prefix | n/a | `string` | n/a | yes |
| repo\_is\_private | n/a | `bool` | `true` | no |

## Outputs

No output.

