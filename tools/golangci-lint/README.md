# golangci-lint

Run [`golangci-lint`](https://github.com/golangci/golangci-lint) to lint golang source code files

## Usage

```yaml
foo@tpl:
  template@http?str: https://cdn.jsdelivr.net/gh/arhat-dev/dukkha-presets@master/tools/golangci-lint.yml
  variables:
    # version of golangci-lint
    #
    # Defaults to "1.43"
    version: "1.43"

    # workdir when running golangci-lint
    #
    # Defaults to env.DUKKHA_WORKING_DIR
    workdir: ""

    # cmd list to run container, so we can run golangci-lint
    # in container if no local installation found
    #
    # Defaults to values.cmd.run_ctr, then [docker, run, --rm]
    run_ctr: []

    # config of golangci-lint
    #
    # Defaults to ".ecrc"
    config: ".ecrc"

    # packages to lint
    # defaults to [./...]
    packages:
    - ./...
```
