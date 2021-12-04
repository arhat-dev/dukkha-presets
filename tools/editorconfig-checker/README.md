# editorconfig-checker

Generate [`editorconfig-checker`](https://github.com/editorconfig-checker/editorconfig-checker) command list

## Usage

```yaml
foo@tpl:
  template@http:presets?str: tools/editorconfig-checker/ctr.yml

  variables:
    # version of editorconfig-checker
    #
    # Defaults to "2.3"
    version: "2.3"

    # config of editorconfig-checker
    #
    # Defaults to ".ecrc"
    config: ".ecrc"

    #
    # following variables are only available in ctr.yml
    #

    # workdir in container when running editorconfig-checker
    # MUST be absolute path
    #
    # Defaults to dukkha.WorkDir
    workdir: ""

    # cmd list to run container, so we can run editorconfig-checker
    # in container if no local installation found
    #
    # Defaults to values.cmd.run_ctr, then [docker, run, --rm]
    run_ctr: []
```
