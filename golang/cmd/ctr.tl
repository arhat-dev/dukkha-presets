define "golang.cmd.ctr"

  $version := var.version | default "1.18"
  $flavor := var.flavor
  if not $flavor
    if eq env.CGO_ENABLED "1" "true"
      $flavor = "cross"
    else
      $flavor = "native"
    end
  end

  $flavor_tag := include "image.flavored-tag" \
    (dict \
      "flavor" (default "native" var.flavor) \
      "arch" (var.arch | default matrix.arch | default var.host_arch | default "amd64") \
      "host_arch" var.host_arch \
    )

  $image := var.image | default ( \
    printf "ghcr.io/arhat-dev/builder-golang:%s-%s" $version $flavor_tag \
  )

  $run_ctr := var.run_ctr | default values.cmd.run_ctr | default (strings.Split "," "docker,run")

  range $_, $v := $run_ctr
    "- "; $v; "\n"
  end

    if var.volume
  "- -v\n"
  "- "; var.volume; ":/go/pkg/mod\n"
    end

  "- --workdir\n"
  "- "; var.workdir | default dukkha.WorkDir; "\n"

  "- -v\n"
  "- "; dukkha.WorkDir; ":"; dukkha.WorkDir; "\n"

  # start of go language specific settings

    if env.GOFLAGS
  "- -e\n"
  "- GOFLAGS="; env.GOFLAGS; "\n"
    end

    if env.GIT_ALLOW_PROTOCOL
  "- -e\n"
  "- GIT_ALLOW_PROTOCOL="; env.GIT_ALLOW_PROTOCOL; "\n"
    end

    if env.GO_EXTLINK_ENABLED
  "- -e\n"
  "- GO_EXTLINK_ENABLED="; env.GO_EXTLINK_ENABLED; "\n"
    end

    if env.GOGCCFLAGS
  "- -e\n"
  "- GOGCCFLAGS="; env.GOGCCFLAGS; "\n"
    end

    if env.GOEXPERIMENT
  "- -e\n"
  "- GOEXPERIMENT="; env.GOEXPERIMENT; "\n"
    end

    if env.GOEXE
  "- -e\n"
  "- GOEXE="; env.GOEXE; "\n"
    end

  # end of go language specific settings

  # start of go module related settings

  # always use go module (if available, >= go1.11)

  "- -e\n"
  "- GO111MODULE=on\n"

    if env.GOINSECURE
  "- -e\n"
  "- GOINSECURE="; env.GOINSECURE; "\n"
    end

    if env.GOINSECURE
  "- -e\n"
  "- GOPRIVATE="; env.GOPRIVATE; "\n"
    end

    if env.GOPROXY
  "- -e\n"
  "- GOPROXY="; env.GOPROXY; "\n"
    end

    if env.GOSUMDB
  "- -e\n"
  "- GOSUMDB="; env.GOSUMDB; "\n"
    end

    if env.GONOSUMDB
  "- -e\n"
  "- GONOSUMDB="; env.GONOSUMDB; "\n"
    end

    if env.GONOPROXY
  "- -e\n"
  "- GONOPROXY="; env.GONOPROXY; "\n"
    end

  # end of go module proxy related settings

  # start of GOOS/GOARCH related settings

  # always set GOOS and GOARCH

  "- -e\n"
  "- GOOS="; env.GOOS | default (host.kernel | archconv.GolangOS); "\n"

  "- -e\n"
  "- GOARCH="; env.GOARCH | default (host.arch | archconv.GolangArch); "\n"

    if env.GO386
  "- -e\n"
  "- GO386="; env.GO386; "\n"
    end

    if env.GOAMD64
  "- -e\n"
  "- GOAMD64="; env.GOAMD64; "\n"
    end

    if env.GOARM
  "- -e\n"
  "- GOARM="; env.GOARM; "\n"
    end

    if env.GOMIPS
  "- -e\n"
  "- GOMIPS="; env.GOMIPS; "\n"
    end

    if env.GOMIPS64
  "- -e\n"
  "- GOMIPS64="; env.GOMIPS64; "\n"
    end

    if env.GOWASM
  "- -e\n"
  "- GOWASM="; env.GOWASM; "\n"
    end

    if env.GOPPC64
  "- -e\n"
  "- GOPPC64="; env.GOPPC64; "\n"
    end

  # end of GOOS & GOARCH related settings

  # start of cgo related settings

    if env.CC
  "- -e\n"
  "- CC="; env.CC; "\n"
    end

    if env.CXX
  "- -e\n"
  "- CXX="; env.CXX; "\n"
    end

    if env.AR
  "- -e\n"
  "- AR="; env.AR; "\n"
    end

    if env.FC
  "- -e\n"
  "- FC="; env.FC; "\n"
    end

    if env.PKG_CONFIG
  "- -e\n"
  "- PKG_CONFIG="; env.PKG_CONFIG; "\n"
    end

    if env.CGO_ENABLED
  "- -e\n"
  "- CGO_ENABLED="; env.CGO_ENABLED | default "0"; "\n"
    end

    if env.CGO_CPPFLAGS_ALLOW
  "- -e\n"
  "- CGO_CPPFLAGS_ALLOW="; env.CGO_CPPFLAGS_ALLOW; "\n"
    end

    if env.CGO_CPPFLAGS_DISALLOW
  "- -e\n"
  "- CGO_CPPFLAGS_DISALLOW="; env.CGO_CPPFLAGS_DISALLOW; "\n"
    end

    if env.CGO_CPPFLAGS
  "- -e\n"
  "- CGO_CPPFLAGS="; env.CGO_CPPFLAGS; "\n"
    end

    if env.CGO_CFLAGS_ALLOW
  "- -e\n"
  "- CGO_CFLAGS_ALLOW="; env.CGO_CFLAGS_ALLOW; "\n"
    end

    if env.CGO_CFLAGS_DISALLOW
  "- -e\n"
  "- CGO_CFLAGS_DISALLOW="; env.CGO_CFLAGS_DISALLOW; "\n"
    end

    if env.CGO_CFLAGS
  "- -e\n"
  "- CGO_CFLAGS="; env.CGO_CFLAGS; "\n"
    end

    if env.CGO_CXXFLAGS_ALLOW
  "- -e\n"
  "- CGO_CXXFLAGS_ALLOW="; env.CGO_CXXFLAGS_ALLOW; "\n"
    end

    if env.CGO_CXXFLAGS_DISALLOW
  "- -e\n"
  "- CGO_CXXFLAGS_DISALLOW="; env.CGO_CXXFLAGS_DISALLOW; "\n"
    end

    if env.CGO_CXXFLAGS
  "- -e\n"
  "- CGO_CXXFLAGS="; env.CGO_CXXFLAGS; "\n"
    end

    if env.CGO_FFLAGS_ALLOW
  "- -e\n"
  "- CGO_FFLAGS_ALLOW="; env.CGO_FFLAGS_ALLOW; "\n"
    end

    if env.CGO_FFLAGS_DISALLOW
  "- -e\n"
  "- CGO_FFLAGS_DISALLOW="; env.CGO_FFLAGS_DISALLOW; "\n"
    end

    if env.CGO_FFLAGS
  "- -e\n"
  "- CGO_FFLAGS="; env.CGO_FFLAGS; "\n"
    end

    if env.CGO_LDLAGS_ALLOW
  "- -e\n"
  "- CGO_LDLAGS_ALLOW="; env.CGO_LDLAGS_ALLOW; "\n"
    end

    if env.CGO_LDLAGS_DISALLOW
  "- -e\n"
  "- CGO_LDLAGS_DISALLOW="; env.CGO_LDLAGS_DISALLOW; "\n"
    end

    if env.CGO_LDLAGS
  "- -e\n"
  "- CGO_LDLAGS="; env.CGO_LDLAGS; "\n"
    end

  # end of cgo related settings

`- --entrypoint
- ""
`

  "- "; $image; "\n"
  "- go\n"

end
