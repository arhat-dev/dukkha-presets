# Container related templates

## `flavored-tag.tmpl`

## `names.tmpl`

Generate value for `images_names` in tasks like

- `buildah:{build, xbuild, push}`
- `docker:{build, push}`
- `cosign:{sign-image, upload}`

### Usage

```yaml
buildah:build:
- name: foo
  image_names@tmpl#use-spec:
    template: |-
      {{- include "image.names" . -}}

    include:
    - text@presets?str: templates/image/names.tmpl
    variables:
      base_name: example.com/my-repo/my-app

      # Defaults to matrix.kernel first, then host.kernel, finally linux
      kernel: linux

      # Defaults to matrix.arch first, then host.arch_simple, finally amd64
      arch: amd64

      # Version should follow semantic versioning style (prefix `v` will be trimed)
      #
      # Defaults to
      #            matrix.version first
      #       then env.VERSION
      #       then git.tag
      #       then git.branch (normalized as kebab-case)
      #       then git.commit[0:8]
      #       finally "unknown"
      version: "1.0.1"

      # Add image name with tag version major
      #
      # Default to true when version major part is not "0"
      set_major: false

      # Add image name with tag latest
      #
      # Defaults to true when git.branch is the same as git.default_branch
      latest: true

      # Add extra suffix to manifest name
      manifest_suffix: ""
```

### Output

By default, adds:

```yaml
- image: `{base_name}:{version}-{kernel}-{arch}`
  manifest: `{base_name}:{version}`
```

When latest evaluated as `true`, additionaly adds:

```yaml
- image: `{base_name}:latest-{kernel}-{arch}`
  manifest: `{base_name}:latest`
```

When set_major evaluated as `true`, additionaly adds:

```yaml
- image: `{base_name}:{version major}-{kernel}-{arch}`
  manifest: `{base_name}:{version major}`
```

When version contains multiple dot separated parts, additionaly adds

```yaml
- image: `{base_name}:{version major}.{version minor}-{kernel}-{arch}`
  manifest: `{base_name}:{version major}.{version minor}`
```
