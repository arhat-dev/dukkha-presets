# Container related templates

## `flavored-tag.tpl`

## `names.yml`

Generate `images_names` for

- `buildah:{build, xbuild, push}`
- `docker:{build, push}`
- `cosign:{sign-image, upload}`

and maybe more in future...

### Output

By default, add:

```yaml
- image: `{image_repo}/{app}:{version}-{kernel}-{arch}`
  manifest: `{image_repo}/app:{version}`
```

When latest evaluated as `true`, add:

```yaml
- image: `{image_repo}/{app}:latest-{kernel}-{arch}`
  manifest: `{image_repo}/app:latest`
```

When set_major evaluated as `true`, add:

```yaml
- image: `{image_repo}/{app}:{version major}-{kernel}-{arch}`
  manifest: `{image_repo}/app:{version major}`
```

When version contains multiple dot separated parts, add

```yaml
- image: `{image_repo}/{app}:{version major}.{version minor}-{kernel}-{arch}`
  manifest: `{image_repo}/app:{version major}.{version minor}`
```

### Usage

```yaml
buildah:build:
- name: foo
  image_names@tpl#use-spec:
    template: |-
      {{- include "image.names" . -}}

    include:
    - text@http:presets?str: templates/image/names.yml
    variables:
      base_name: example.com/my-repo/my-app

      # Defaults to matrix.kernel first, then env.HOST_KERNEL, finally linux
      kernel: linux

      # Defaults to matrix.arch first, then env.HOST_ARCH, finally amd64
      arch: amd64

      # Version should follow semantic versioning style (prefix `v` will be trimed)
      #
      # Defaults to matrix.version first
      #       then env.VERSION
      #       then env.GIT_TAG
      #       then env.GIT_BRANCH (normalized as kebab-case)
      #       then env.GIT_COMMIT[0:8]
      #       finally "unknown"
      version: "1.0.1"

      # Add image name with tag version major
      #
      # Default to true when version major part is not "0"
      set_major: false

      # Add image name with tag latest
      #
      # Defaults to true when env.GIT_BRANCH is the same as env.GIT_DEFAULT_BRANCH
      latest: true
```
