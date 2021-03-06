define "image.names"

  $base_name := var.base_name
  $manifest_suffix := var.manifest_suffix | default ""
  $kernel := var.kernel | default matrix.kernel | default host.kernel | default "linux"
  $arch := var.arch | default matrix.arch | default host.arch_simple | default "amd64"
  $version := var.version | default matrix.version | default env.VERSION \
              | default git.tag | default "" | strings.TrimPrefix "v"

  $can_set_major := true

  if not $version
    # no potential semantic version found,
    # defaulting to git branch and commit,
    # do not set major anyway

    $can_set_major = false
    $version = git.branch | strings.KebabCase | default (git.commit | substr 0 8) | default "unknown"

  end

  $version_parts := strings.SplitN "." 3 $version
  $version_major := index 0 $version_parts

  $can_set_major = and $can_set_major (gt (len $version_parts) 1)

  $version_minor := ""
  if gt (len $version_parts) 1
    $version_minor = index 1 $version_parts
  end

  $set_major := false
  if $can_set_major
    $set_major = var.set_major | default (ne $version_major "0")
  end

  $latest := var.latest | default (eq git.branch git.default_branch)

  # always generate a image name with full version
  "- image: "
      $base_name
      ":"
      $version
      "-"
      $kernel
      "-"
      $arch
  "\n"
  "  manifest: "
      $base_name
      ":"
      $version
      $manifest_suffix
  "\n"

  if $set_major
    "- image: "
        $base_name
        ":"
        $version_major
        "-"
        $kernel
        "-"
        $arch
    "\n"
    "  manifest: "
        $base_name
        ":"
        $version_major
        $manifest_suffix
    "\n"
  end

  if $version_minor
    "- image: "
        $base_name
        ":"
        $version_major
        "."
        $version_minor
        "-"
        $kernel
        "-"
        $arch
    "\n"
    "  manifest: "
        $base_name
        ":"
        $version_major
        "."
        $version_minor
        $manifest_suffix
    "\n"
  end

  if $latest
    "- image: "
        $base_name
        ":latest-"
        $kernel
        "-"
        $arch
    "\n"
    "  manifest: "
        $base_name
        ":latest"
        $manifest_suffix
    "\n"
  end

end
