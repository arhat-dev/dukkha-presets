# editorconfig-checker

Generate [`editorconfig-checker`](https://github.com/editorconfig-checker/editorconfig-checker) command list

## Usage

```yaml
foo@tmpl#use-spec:
  template@presets?str: tools/editorconfig-checker/ctr.tmpl

  variables:
    # version of editorconfig-checker
    #
    # Defaults to "2.4"
    version: "2.4"

    # config of editorconfig-checker
    #
    # Defaults to ".ecrc"
    config: ".ecrc"

    #
    # following variables are only available in ctr.tmpl
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
