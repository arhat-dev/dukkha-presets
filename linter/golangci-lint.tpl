{{- $version := env.GOLANGCI_LINT_VERSION | default "1.43" -}}

{{- $local_version := strings.TrimPrefix "v" (
      index (
          strings.Split " " (
            strings.TrimSpace (
              eval.Shell "golangci-lint --version 2>/dev/null || true"
            )
          )
      ) 3
    )
-}}

{{- $prefer_local := and $local_version (strings.HasPrefix $version $local_version) -}}

{{- if $prefer_local -}}

  {{- if env.MATRIX_WORKDIR }}
  cd {{ env.MATRIX_WORKDIR }}
  {{- end }}

  {{- nindent 0 "" -}}

  golangci-lint run \
    {{- if matrix.config }}
    --config {{ matrix.config }} \
    {{- end }}
    --fix {{ matrix.pkgs | default "./..." }}

{{- else -}}

  {{- $cmd := strings.Split "," "docker,run,--rm" -}}

  {{- if env.RUN_CTR -}}
    {{- $cmd = fromYaml env.RUN_CTR -}}
  {{- else if values.cmd.run_container -}}
    {{- $cmd = values.cmd.run_container -}}
  {{- end -}}

  {{- range $i, $v := $cmd -}}
    {{- strings.ShellQuote $v | indent 1 -}}
  {{- end }} \
    -v "{{- env.DUKKHA_WORKING_DIR -}}:{{- env.DUKKHA_WORKING_DIR -}}" \
    -w "{{- env.MATRIX_WORKDIR | default env.DUKKHA_WORKING_DIR -}}" \
    ghcr.io/arhat-dev/golangci-lint:{{- $version }} \
    golangci-lint run \
      {{- if matrix.config }}
      --config {{ matrix.config }} \
      {{- end }}
      --fix {{ matrix.pkgs | default "./..." }}

{{- end -}}
