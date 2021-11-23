# golang

## Usage

```yaml
tools:
  golang:
  - cmd@tpl:
      template: |-
        {{- include "golang.cmd.ctr" . -}}

      include@:
      # required templates dependency
      - __@http:presets#cached-file?str: templates/image/flavored-tag.tpl
      - __@http:presets#cached-file?str: golang/cmd/ctr.yml

      variables:
        # golang toolchain version
        #
        # Defaults to "1.17"
        version: "1.17"

        # CPU arch of the machine running this command
        #
        # Defaults to env.HOST_ARCH first, then amd64
        host_arch: ""

        # target CPU arch
        #
        # Defaults to matrix.arch first, then host_arch
        arch: ""

        # image flavor
        flavor: native

        #
        run_ctr:

        # switch to directory different from env.DUKKHA_WORKING_DIR
        #
        # MUST be inside env.DUKKHA_WORKING_DIR
        workdir: ""

        # Custom golang image name
        #
        # override image name generated using arch/host_arch/flavor
        image: ""

        # volume name or absolute path for go mod caching
        volume: ""
```