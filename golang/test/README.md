# `golang:test`

## Usage

### `pkg.tmpl`

Test local package `./{pkg}`

```yaml
golang:test:
- name: foo
  env:
  - name: PROFILE_DIR
    value: build/test-profile

  matrix:
    # here we generate pkg vector automatically for all your packages
    pkg@tlang: |-
        eval.Shell ("go list ./pkg/... ./cmd/... ./internal/...").Stdout
          | removePrefix (eval.Shell "go list -m" | trimSpace).Stdout
          | removePrefix "/"
          | addPrefix "- "
  hooks:
    before:
    # create profile dir before test start
    - shell: tmpl:mkdir ${PROFILE_DIR}

  __@tmpl#use-spec:
    template: |-
      {{- include "golang.test.pkg" . -}}
    include:
    - text@presets?str: golang/test/pkg.tmpl

    variables:
      # Directory to write profile generated during test
      #
      # Defaults to "build/test-profile"
      profile_dir@tlang: env.PROFILE_DIR

      # package to test, should be relative path to DUKKHA_WORKDIR
      #
      # Defaults to matrix.pkg first, then ""
      pkg: ""

      # Which package to do coverage report
      #
      # Defaults to ./{pkg}
      cover_pkg: ./...
```
