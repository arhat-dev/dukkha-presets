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
      # version: ["2.3"]
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
      # version: ["1.43"]
      # workdir: [""]
      # config: [""]
      # packages: ["./..."]

  jobs:
  - cmd@presets|tpl#use-spec: tools/http.tpl
    chdir@tpl: |-
      {{- matrix.workdir | default "" -}}
```
