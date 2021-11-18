{{- $version := env.YAMLLINT_VERSION | default "1.26" -}}

{{- $local_version := strings.TrimPrefix "yamllint " (strings.TrimSpace (
      eval.Shell "yamllint --version 2>/dev/null || true"
    ))
-}}

{{- $prefer_local := and $local_version (strings.HasPrefix $version $local_version) -}}

{{- if $prefer_local -}}

  {{- if env.MATRIX_WORKDIR }}
  cd {{ env.MATRIX_WORKDIR }}
  {{- end }}

  {{- nindent 0 "" -}}

  yamllint -c {{ matrix.config | default ".yaml-lint.yml" }} .

{{- else -}}

  {{- $cmd := env.RUN_CONTAINER -}}
  {{- if values.cmd.run_container -}}
    {{- $cmd = join values.cmd.run_container " " -}}
  {{- end -}}

  {{- $cmd | default "docker run --rm" }} \
    -v "{{- env.DUKKHA_WORKING_DIR -}}:{{- env.DUKKHA_WORKING_DIR -}}" \
    -w "{{- env.MATRIX_WORKDIR | default env.DUKKHA_WORKING_DIR -}}" \
    ghcr.io/arhat-dev/yamllint:{{- $version }} \
    yamllint -c {{ matrix.config | default ".yaml-lint.yml" }} .

{{- end -}}
