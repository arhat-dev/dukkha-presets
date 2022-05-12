# `tools.buildah[*].cmd`

Generate cmd list for `buildah` tool.

## Usage

### `ctr.yml`

```yaml
tools:
  buildah:
  - cmd@tpl#use-spec:
      template: |-
        {{- include "buildah.cmd.ctr" . -}}

      include:
      - text@presets?str: buildah/cmd/ctr.yml

      variables:
        # buildah version
        #
        # Defaults to `latest`
        version: latest

        # Custom buildah image name
        #
        # Defaults to `quay.io/containers/buildah:{{ var.version }}`
        image: ""

        #
        run_ctr: []

        # switch workdir in container
        #
        # MUST be inside dukkha.WorkDir
        #
        # Defaults to dukkha.WorkDir
        workdir: ""

        # volume name or absolute path for image & container storage
        #
        # Defaults to "buildah"
        volume: ""
```
