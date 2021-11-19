{{- $version := env.EDITORCONFIG_CHECKER_VERSION | default "2.3" -}}

{{- $local_version := strings.TrimSpace (
      eval.Shell "editorconfig-checker -version 2>/dev/null || true"
    )
-}}

{{- $prefer_local := and $local_version (strings.HasPrefix $version $local_version) -}}

{{- if $prefer_local -}}

  {{- if env.MATRIX_WORKDIR }}
  cd {{ env.MATRIX_WORKDIR }}
  {{ end }}

  {{- nindent 0 "" -}}

  editorconfig-checker -config .ecrc

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
    ghcr.io/arhat-dev/editorconfig-checker:{{- $version }} \
    editorconfig-checker -config .ecrc

{{- end -}}
