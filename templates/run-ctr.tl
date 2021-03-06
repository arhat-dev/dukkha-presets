# description: Generate cmd list to run container
#
# usage:
#   foo@tlang#use-spec:
#     template@presets?str: templates/run-ctr.tl
#     variables:
#       # preferred tool lookup order
#       #
#       # Defaults to following order (left to right)
#       #
#       # podman: local podman installation
#       # nerdctl: local nerdctl + containerd installation
#       # lima-podman: podman installed in lima-vm, accessed via limactl
#       # lima-nerdctl: nerdctl + containerd installed in lima-vm, accessed via limactl
#       # docker: local docker installation
#       order: [podman, nerdctl, lima-podman, lima-nerdctl, docker]
#
#       # run container in privileged mode
#       #
#       # Defaults to false
#       privileged: false
#
#       # extra args passed when running command
#       args: []
#
#       # lima home dir for lima mode podman
#       # used by
#       # - podman (lima mode)
#       #
#       # Defaults to env.LIMA_HOME first, then `~/.lima`
#       lima_home: ""
#
#       # lima instance name
#       # used by
#       # - podman (lima mode)
#       # - lima-podman
#       # - lima-nerdctl
#       #
#       # Defaults to env.LIMA_INSTANCE first, then `default`
#       lima_instance: default
#
#       # podman running mode
#       #   `standalone`: cmd podman can run container directly on local host
#       #   `machine`: cmd podman is a client of the podman running inside a `podman machine`
#       #   `lima`: cmd podman is a client of the podman running inside a lima-vm
#       #
#       # Defaults to
#       # - `standalone` when host.kernel is linux
#       # - `machine` first, then `lima` when host.kernel is darwin or windows
#       #
#       podman_mode: standalone
#
#       # unix socket url used when running in `socket-client` mode
#       #
#       # Defaults to env.CONTAINER_URL first, then detect by checking lima podman installation
#       podman_url: ""
#
#       # path to sshkey used when running in `socket-client` mode
#       #
#       # Defaults to env.CONTAINER_SSHKEY first, then detect by checking lima podman installation
#       podman_sshkey: ""

$order := coll.Strings
if var.order
  $order = var.order
else
  $order = coll.Strings "podman" "nerdctl" "lima-nerdctl" "lima-podman" "docker"
end

range $_, $tool := $order
  $lima := $tool | strings.HasPrefix "lima-"

  if $lima
    if not (fs.Lookup "limactl")
      continue
    end
  else if not (fs.Lookup $tool)
    continue
  end

if eq $tool "podman"

  $standalone_mode := false

  if var.podman_mode
    $standalone_mode = eq var.podman_mode "standalone"
  else
    $standalone_mode = eq host.kernel "linux"
  end

  if and $standalone_mode var.privileged
"- sudo\n"
  end
"- podman\n"

  if not $standalone_mode

    $url := var.podman_url | default env.CONTAINER_URL
    $sshkey := var.podman_sshkey | default env.CONTAINER_SSHKEY
    $lima_mode := false

    if var.podman_mode
      # podman mode set explicitly
      $lima_mode = eq var.podman_mode "lima"
    else
      # fallback to podman lima mode when ther is no podman machine provisioned
      $lima_mode = eq "" ( \
        (eval.Shell "podman machine list --noheading 2>/dev/null").Stdout | strings.TrimSpace \
      )
    end

    if $lima_mode
      if not $url
        $url = fs.Join \
              (var.lima_home | default env.LIMA_HOME | default (fs.Join fs.UserHomeDir ".lima")) \
              (var.lima_instance | default env.LIMA_INSTANCE | default "podman") \
              "sock"

        if var.privileged
          $url = fs.Join $url "podman-root.sock"
        else
          $url = fs.Join $url "podman.sock"
        end

        $url = printf "unix://%s" $url
      end

      if not $sshkey
        $sshkey = fs.Join \
              (var.lima_home | default env.LIMA_HOME | default (fs.Join fs.UserHomeDir ".lima")) \
              "_config" "user"
      end
    end

    if $url
"- --url\n"
"- "; $url ; "\n"
    end

    if $sshkey
"- --identity\n"
"- "; $sshkey ; "\n"
    end

  end
"- run\n"
  if var.privileged
"- --privileged\n"
  end

else if eq $tool "nerdctl"

  if var.privileged
"- sudo\n"
  end
"- nerdctl\n"
"- run\n"
  if var.privileged
"- --privileged\n"
  end

else if $lima

"- limactl\n"
"- shell\n"
"- "
  var.lima_instance | default env.LIMA_INSTANCE | default "default"
"\n"

  if var.privileged
"- sudo\n"
  end

  if eq $tool "lima-nerdctl"
"- nerdctl\n"
  else if eq $tool "lima-podman"
"- podman\n"
  end

"- run\n"
  if var.privileged
"- --privileged\n"
  end

else if eq $tool "docker"

"- docker\n"
"- run\n"
  if var.privileged
"- --privileged\n"
  end

end

  range $_, $arg := var.args
"- "
    $arg
"\n"
  end

break

end
