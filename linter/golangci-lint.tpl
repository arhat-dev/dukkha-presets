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

  {{- $cmd := env.RUN_CONTAINER -}}
  {{- if values.cmd.run_container -}}
    {{- $cmd = join values.cmd.run_container " " -}}
  {{- end -}}

  {{- $cmd | default "docker run --rm" }} \
    -v "{{- env.DUKKHA_WORKING_DIR -}}:{{- env.DUKKHA_WORKING_DIR -}}" \
    -w "{{- env.MATRIX_WORKDIR | default env.DUKKHA_WORKING_DIR -}}" \
    ghcr.io/arhat-dev/golangci-lint:{{- $version }} \
    golangci-lint run \
      {{- if matrix.config }}
      --config {{ matrix.config }} \
      {{- end }}
      --fix {{ matrix.pkgs | default "./..." }}

{{- end -}}
