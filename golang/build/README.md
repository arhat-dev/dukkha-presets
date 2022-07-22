# golang:build

Generate `golang:build` task spec for a golang binary

## Usage

### `cmd.tmpl`

Build executables `{output_dir}/{cmd}.{kernel}.{arch}` from `./cmd/{cmd}`

```yaml
golang:build:
- name: foo
  matrix:
    # vector kernel and arch are required
    # otherwise will produce incorrect artifact name
    kernel: [linux, darwin]
    arch: [amd64, arm64]

  __@tmpl#use-spec:
    template: |-
      {{- include "golang.build.cmd" . -}}

    include:
    - text@presets?str: golang/build/cmd.tmpl

    variables:
      # Directory to store artifacts
      # MUST be in unix path style
      #
      # Defaults to `build`
      output_dir: ""
```
