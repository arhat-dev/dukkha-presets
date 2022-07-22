define "buildah.cmd.ctr"

  $version := var.version | default "latest"
  $image := var.image | default (printf "quay.io/containers/buildah:%s" $version)

  $run_ctr := var.run_ctr | default values.cmd.run_ctr | default (strings.Split "," "docker,run")

  range $_, $v := $run_ctr
    "- "
        $v
    "\n"
  end

`- --entrypoint
- ""
- --workdir
`

  "- "; var.workdir | default dukkha.WorkDir; "\n"
  "- -v\n"
  "- \""; dukkha.WorkDir; ':'; dukkha.WorkDir; "\"\n"
  "- -v\n"
  "- "; var.volume | default "buildah"; ':'; "/var/lib/containers\n"

`- --device
- /dev/fuse:rw
`
  - {{ $image }}
  "- buildah\n"

end
