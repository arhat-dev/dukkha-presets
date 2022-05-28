# `golang:test`

## Usage

### `pkg.yml`

Test local package `./{pkg}`

```yaml
golang:test:
- name: foo
  env:
  - name: PROFILE_DIR
    value: build/test-profile

  matrix:
    # here we generate pkg vector automatically
    pkg@tpl: |-
      {{-
        eval.Shell ("go list ./pkg/... ./cmd/... ./internal/...").Stdout
          | removePrefix (eval.Shell "go list -m" | trimSpace).Stdout
          | removePrefix "/"
          | addPrefix "- "
      -}}
  hooks:
    before:
    # create profile dir before test start
    - shell: tpl:mkdir ${PROFILE_DIR}

  __@tpl#use-spec:
    template: |-
      {{- include "golang.test.pkg" . -}}
    include:
    - text@presets?str: golang/test/pkg.yml

    variables:
      # Directory to write profile generated during test
      #
      # Defaults to "build/test-profile"
      profile_dir@tpl: |-
        {{- env.PROFILE_DIR -}}

      # package to test, should be relative path to DUKKHA_WORKDIR
      #
      # Defaults to matrix.pkg first, then ""
      pkg: ""

      # Which package to do coverage report
      #
      # Defaults to ./{pkg}
      cover_pkg: ./...
```
