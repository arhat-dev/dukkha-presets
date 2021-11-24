# golangci-lint

Run [`golangci-lint`](https://github.com/golangci/golangci-lint) to lint golang source code files

## Usage

```yaml
foo@tpl#use-spec:
  template: |-
    {{- include "tools.golangci-lint.ctr" . -}}

  include:
  - __@http:presets#cached-file?str: tools/golangci-lint/ctr.yml

  variables:
    # version of golangci-lint
    #
    # Defaults to "1.43"
    version: "1.43"

    # extra args to golangci run
    #
    # Defaults to ["--fix"]
    args: ["--fix"]

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
    # Defaults to env.DUKKHA_WORKING_DIR
    workdir: ""

    # cmd list to run container, so we can run golangci-lint
    # in container if no local installation found
    #
    # Defaults to values.cmd.run_ctr, then [docker, run, --rm]
    run_ctr: []
```
