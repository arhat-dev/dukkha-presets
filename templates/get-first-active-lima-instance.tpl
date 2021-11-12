{{- $lima_list := strings.Split "\n"
      (
        eval.Shell "if command -v limactl >/dev/null 2>&1; then limactl list --json; fi"
          | jq "select(.status == \"Running\") | .name"
      )
-}}

{{- if $lima_list -}}
  {{- index $lima_list 0 -}}
{{- end -}}
