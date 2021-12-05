# golangci-lint

Run [`golangci-lint`](https://github.com/golangci/golangci-lint) to lint golang source code files

## Usage

```yaml
foo@tpl#use-spec:
  template: |-
    {{- include "tools.golangci-lint.ctr" . -}}

  include:
  - text@presets?str: tools/golangci-lint/ctr.yml

  variables:
    # version of golangci-lint
    #
    # Defaults to "1.43"
    version: "1.43"

    # extra args to golangci run
    #
    # Defaults to ["--fix", "--color", "always"]
    args:
    - --fix
    - --color
    - always

    # config of golangci-lint
    #
    # Defaults to "" (empty string) as golangci-lint will lookup config actively
    config: ""

    # packages to lint
    # defaults to [./...]
    packages:
    - ./...

    # workdir when running golangci-lint
    #
    # Defaults to dukkha.WorkDir
    workdir: ""

    # cmd list to run container, so we can run golangci-lint
    # in container if no local installation found
    #
    # Defaults to values.cmd.run_ctr, then [docker, run, --rm]
    run_ctr: []
```
