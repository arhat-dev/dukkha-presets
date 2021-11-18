# Linter Presets

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

    - linter: [golangci-lint]
      # version: ["1.43"]
      # workdir: [""]
      # config: [""]
      # pkgs: ["./..."]

  jobs:
  - shell@template|http|template: |-
      https://raw.githubusercontent.com/arhat-dev/dukkha-presets/master/linter/{{ matrix.linter }}.tpl
    env:
    - name@template: |-
        {{- matrix.linter | strings.SnakeCase | strings.ToUpper -}}
      value@template: |-
        {{- matrix.version | default "" -}}
```

## Add new linter

- Use `env.MATRIX_XXX` to make matrix info available for testing (as `{{ matrix.xxx }}` cannot survive command run for dukkhe render)
