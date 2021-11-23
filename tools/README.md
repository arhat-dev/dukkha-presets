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
    - linter: [editorconfig-checker]
      # version: ["2.3"]
      # workdir: [""]
      # config: [".ecrc"]

    - linter: [shellcheck]
      # version: [""]
      # workdir: [""]

    - linter: [yamllint]
      # version: ["1.26"]
      # workdir: [""]
      # config: [".yaml-lint.yml"]
      # files: ["."]

    - linter: [golangci-lint]
      # version: ["1.43"]
      # workdir: [""]
      # config: [""]
      # packages: ["./..."]

  jobs:
  - cmd@http:presets|tpl#use-spec: tools/http.tpl
    chdir@tpl: |-
      {{- matrix.workdir | default "" -}}
```
