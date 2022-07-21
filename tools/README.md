# Linter Presets

## Common Variable Names

- `version`
- `workdir`
- `config`
- `args`

## Usage

```yaml
workflow:run:
- name: lint
  matrix:
    include:
    - tool: [editorconfig-checker]
      # version: ["2.4"]
      # workdir: [""]
      # config: [".ecrc"]

    - tool: [shellcheck]
      # version: [""]
      # workdir: [""]

    - tool: [yamllint]
      # version: ["1.26"]
      # workdir: [""]
      # config: [".yaml-lint.yml"]
      # files: ["."]

    - tool: [golangci-lint]
      # version: ["1.45"]
      # workdir: [""]
      # config: [""]
      # packages: ["./..."]

  jobs:
  - cmd@presets|tmpl#use-spec: tools/presets.tmpl
    chdir@tmpl: |-
      {{- matrix.workdir | default "" -}}
```
