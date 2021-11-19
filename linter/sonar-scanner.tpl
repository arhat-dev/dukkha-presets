{{- $version := env.SONAR_SCANNER_VERSION | default "4.6" -}}

{{- $local_version_parts := strings.Split "\n" (
      eval.Shell "sonar-scanner --version 2>/dev/null || true"
    )
-}}

{{- $local_version := "" -}}
{{- if gt (len $local_version_parts) 2 -}}
  {{- $local_version_parts = strings.Split " " (
      index $local_version_parts 2
    )
  -}}

  {{- if gt (len $local_version_parts) 2 -}}
    {{- $local_version = (index $local_version_parts 2) -}}
  {{- end -}}
{{- end -}}

{{- $prefer_local := and $local_version (strings.HasPrefix $version $local_version) -}}

{{- if $prefer_local -}}

  sonar-scanner \
    -D sonar.projectBaseDir={{ env.MATRIX_WORKDIR | default env.DUKKHA_WORKING_DIR }}

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
    -e SONAR_HOST_URL -e SONAR_TOKEN \
    docker.io/sonarsource/sonar-scanner-cli:{{- $version }} \
    sonar-scanner \
      -D sonar.projectBaseDir={{ env.MATRIX_WORKDIR | default env.DUKKHA_WORKING_DIR }}

{{- end -}}
