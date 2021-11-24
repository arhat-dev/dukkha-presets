# golang:build

Build executables `${OUTPUT_DIR}/{{ matrix.cmd }}.{{ matrix.kernel }}.{{ matrix.arch }}`
from ./cmd/{{ matrix.cmd }}

Required Env: MODULE_NAME
Required matrix vector names: cmd, kernel, arch
Optional Env: OUTPUT_DIR

```yaml
golang:build:
- name: foo
  matrix:
    kernel: [linux, darwin]
    arch: [amd64, arm64]
  __@tpl#use-spec:
    template: |-
      {{- include "golang.build.cmd" . -}}
    include:
    - __@http:presets#cached-file: golang/build/cmd.yml
    variables:
      # Defaults to `build`
      output_dir: ""

      # Defaults to matrix.kernel
      kernel: ""

      # Defaults to matrix.arch
      arch: ""
```
