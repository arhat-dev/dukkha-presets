define "cosign.cmd.ctr"

  $version := var.version | default "latest"
  $image := var.image | default (printf "ghcr.io/sigstore/cosign/cosign:%s" $version)

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
  "- \""
      var.workdir | default dukkha.WorkDir
  "\"\n"

  "- -v\n"

  "- \""
      dukkha.WorkDir
      ":"
      dukkha.WorkDir
  "\"\n"

  "- "
      $image
  "\n"
  "- cosign\n"

end
