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
    ghcr.io/arhat-dev/yamllint:{{- $version }} \
    yamllint -c {{ matrix.config | default ".yaml-lint.yml" }} .

{{- end -}}
