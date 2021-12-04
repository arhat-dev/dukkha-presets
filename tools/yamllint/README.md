# yamllint

Run [`yamllint`](https://github.com/adrienverge/yamllint) to lint yaml files

## Usage

```yaml
cmd@tpl:
  template@http?str: https://cdn.jsdelivr.net/gh/arhat-dev/dukkha-presets@master/tools/yamllint/local.yml
  variables:
    # version of yamllint
    #
    # Defaults to "1.26"
    version: "1.26"

    # workdir when running yamllint
    #
    # Defaults to dukkha.WorkDir
    workdir: ""

    # cmd list to run container, so we can run yamllint
    # in container if no local installation found
    #
    # Defaults to values.cmd.run_ctr, then [docker, run, --rm]
    run_ctr: []

    # container image to run when local installtion not found
    #
    # Defaults to docker.io/sonarsource/yamllint-cli:{{ var.version }}
    image: ""
```
