{{- define "image.flavored-tag" -}}

{{- /*
Required arguments
  .flavor
  .host_arch
  .arch
*/ -}}

{{- $flavor := .flavor -}}
{{- $host_arch := .host_arch -}}
{{- $arch := .arch -}}

{{- $tag := "" -}}

{{- if eq $flavor "" "native" "alpine-native" -}}

  {{- $tag = "alpine" -}}

{{- else if eq $flavor "debian-native" -}}

  {{- $tag = "debian" -}}

{{- else if eq $flavor "cross" "alpine-cross" -}}

  {{- if and
            (ne $host_arch $arch)
            (not (eq $host_arch "amd64" "amd64v1" "amd64v2" "amd64v3" "amd64v4"))
  -}}

    {{- $host_arch = $arch -}}

  {{- end -}}

  {{- if eq $arch "armv5" "mips64le" "mips64lesf" -}}

    {{- if and
              (ne $host_arch $arch)
              (not (eq $host_arch "amd64" "amd64v1" "amd64v2" "amd64v3" "amd64v4" "arm64"))
    -}}

      {{- $host_arch = $arch -}}

    {{- end -}}

    {{- $tag = printf "debian-%s-%s" $host_arch $arch -}}

  {{- else -}}

    {{- $tag = printf "alpine-%s-%s" $host_arch $arch -}}

  {{- end -}}

{{- else if eq $flavor "debian-cross" -}}

  {{- if and
            (ne $host_arch $arch)
            (not (eq $host_arch "amd64" "amd64v1" "amd64v2" "amd64v3" "amd64v4" "arm64"))
  -}}

    {{- $host_arch = $arch -}}

  {{- end -}}

  {{- if eq $arch "armv6" -}}

    {{- if and
              (ne $host_arch $arch)
              (not (eq $host_arch "amd64" "amd64v1" "amd64v2" "amd64v3" "amd64v4"))
    -}}

      {{- $host_arch = $arch -}}

    {{- end -}}

    {{- $tag = printf "alpine-%s-%s" $host_arch $arch -}}

  {{- else -}}

    {{- $tag = printf "debian-%s-%s" $host_arch $arch -}}

  {{- end -}}

{{- else if eq $flavor "qemu" "alpine-qemu" -}}

  {{- if eq $arch "armv5" "mips64le" "mips64lesf" -}}

    {{- $tag = printf "debian-%s" $arch -}}

  {{- else -}}

    {{- $tag = printf "alpine-%s" $arch -}}

  {{- end -}}

{{- else if eq $flavor "debian-qemu" -}}

  {{- if eq $arch "armv6" -}}

    {{- $tag = printf "alpine-%s" $arch -}}

  {{- else -}}

    {{- $tag = printf "debian-%s" $arch -}}

  {{- end -}}

{{- end -}}

{{- $tag -}}

{{- end -}}
