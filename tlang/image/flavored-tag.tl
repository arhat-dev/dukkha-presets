# Required arguments
#   .flavor
#   .arch
#
# Optional arguments
#   .host_arch (defaults to host.arch_simple first, then "amd64")
#   .host_kernel (defaults to "linux")
#   .kernel (default to "linux")

define "image.flavored-tag"

  $host_arch := .host_arch | default host.arch_simple | default "amd64"
  $host_arch_simple := $host_arch | archconv.SimpleArch

  $host_kernel := .host_kernel | default "linux"
  $kernel := .kernel | default "linux"

  $cross := dukkha.CrossPlatform $host_kernel $kernel $host_arch .arch

  $alpine_cross_unsupported := and $cross (not (eq $host_arch_simple "amd64"))
  $debian_cross_unsupported := and $cross (not (eq $host_arch_simple "amd64" "arm64"))

  $tag := ""

  if eq .flavor "" "native" "alpine-native"
    $tag = "alpine"
  else if eq .flavor "debian-native"
    $tag = "debian"
  else if eq .flavor "cross" "alpine-cross"

    if $alpine_cross_unsupported
      $host_arch = .arch
    end

    if eq .arch "armv5" "mips64le" "mips64lesf"
      if $debian_cross_unsupported
        $host_arch = .arch
      end
      $tag = printf "debian-%s-%s" $host_arch .arch
    else
      $tag = printf "alpine-%s-%s" $host_arch .arch
    end

  else if eq .flavor "debian-cross"

    if $debian_cross_unsupported
      $host_arch = .arch
    end

    if eq .arch "armv6"
      if $alpine_cross_unsupported
        $host_arch = .arch
      end
      $tag = printf "alpine-%s-%s" $host_arch .arch
    else
      $tag = printf "debian-%s-%s" $host_arch .arch
    end

  else if eq .flavor "qemu" "alpine-qemu"

    if eq .arch "armv5" "mips64le" "mips64lesf"
      $tag = printf "debian-%s" .arch
    else
      $tag = printf "alpine-%s" .arch
    end

  else if eq .flavor "debian-qemu"

    if eq .arch "armv6"
      $tag = printf "alpine-%s" .arch
    else
      $tag = printf "debian-%s" .arch
    end

  end

$tag

end
