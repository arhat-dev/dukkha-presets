# `tools.golang[*].cmd`

Generate cmd list for `golang` tool

## Usage

### `ctr.yml`

```yaml
tools:
  golang:
  - cmd@tmpl:
      template: |-
        {{- include "golang.cmd.ctr" . -}}

      include:
      # required templates dependency
      - text@presets?str: templates/image/flavored-tag.tmpl
      - text@presets?str: golang/cmd/ctr.yml

      variables:
        # golang toolchain version
        #
        # Defaults to "1.18"
        version: "1.18"

        # CPU arch of the machine running this command
        #
        # Defaults to host.arch_simple first, then amd64
        host_arch: ""

        # target CPU arch
        #
        # Defaults to matrix.arch first, then host_arch
        arch: ""

        # image flavor
        flavor: native

        #
        run_ctr:

        # switch to directory different from dukkha.WorkDir
        #
        # MUST be inside dukkha.WorkDir
        workdir: ""

        # Custom golang image name
        #
        # override image name generated using arch/host_arch/flavor
        image: ""

        # volume name or absolute path for go mod caching
        volume: ""
```
