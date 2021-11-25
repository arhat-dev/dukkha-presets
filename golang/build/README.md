# golang:build

## Usage

### `cmd.yml`

Build executables `{output_dir}/{cmd}.{kernel}.{arch}` from `./cmd/{cmd}`

```yaml
golang:build:
- name: foo
  matrix:
    # vector kernel and arch are required
    # otherwise will produce incorrect artifact name
    kernel: [linux, darwin]
    arch: [amd64, arm64]

  __@tpl#use-spec:
    template: |-
      {{- include "golang.build.cmd" . -}}

    include:
    - text@http:presets?str: golang/build/cmd.yml

    variables:
      # Set module name for your project (used by ldflags)
      #
      # Defaults to output value of `go list -m` first, then "."
      module_name: ""

      # Directory to store artifacts
      #
      # Defaults to `build`
      output_dir: ""
```
