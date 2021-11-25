# `tools.buildah[*].cmd`

## Usage

### `ctr.yml`

```yaml
tools:
  buildah:
  - cmd@tpl#use-spec:
      template: |-
        {{- include "buildah.cmd.ctr" . -}}

      include:
      - text@http:presets?str: buildah/cmd/ctr.yml

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
        # MUST be inside env.DUKKHA_WORKING_DIR
        #
        # Defaults to env.DUKKHA_WORKING_DIR
        workdir: ""

        # volume name or absolute path for image & container storage
        #
        # Defaults to "buildah"
        volume: ""
```
