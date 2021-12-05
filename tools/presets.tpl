# try to use local executable first
template: |-
  {{- $cmd := include (printf "tools.%s.local" matrix.tool) . -}}
  {{- if not $cmd -}}
    {{- $cmd = include (printf "tools.%s.ctr" matrix.tool) . -}}
  {{- end -}}
  {{- $cmd -}}

include:
- text@tpl|presets?str: |-
    {{- path.Join "tools" matrix.tool "local.yml" -}}
- text@tpl|presets?str: |-
    {{- path.Join "tools" matrix.tool "ctr.yml" -}}

variables:
  version@tpl?str: |-
    {{- matrix.version | default "" -}}
  workdir@tpl?str: |-
    {{- matrix.workdir | default "" -}}
  config@tpl?str: |-
    {{- matrix.config | default "" -}}
  args@tpl?[]obj: |-
    {{- matrix.args | default "" -}}
  packages@tpl?[]obj: |-
    {{- matrix.packages | default "" -}}
  files@tpl?[]obj: |-
    {{- matrix.files | default "" -}}
