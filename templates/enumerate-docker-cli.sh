#!/bin/bash

# shellcheck disable=SC2154

mark_done() {
  template:dukkha.SetValue "\"${1}\"" '"done"' >/dev/null 2>&1
}

mark_todo() {
  template:dukkha.SetValue "\"${1}\"" '"todo"' >/dev/null 2>&1
}

# set_run_ctr() {
#   template:dukkha.SetValue "\"cmd.run_container\"" "\"$1\"" >/dev/null 2>&1
# }

key="Values.${PRESET}.in_ctr.podman"

if [[ "${!key}" != "done" ]]; then
  mark_done "${PRESET}.in_ctr.podman"
  if command -v podman >/dev/null 2>&1 ; then
    # set_run_ctr "[podman,run,--rm]"
    printf "[podman,run,--rm]"
    exit 0
  fi
fi

key="Values.${PRESET}.in_ctr.nerdctl"

if [[ "${!key}" != "done" ]]; then
  mark_done "${PRESET}.in_ctr.nerdctl"
  if command -v nerdctl >/dev/null 2>&1 ; then
    # set_run_ctr "[nerdctl,run,--rm]"
    printf "[nerdctl,run,--rm]"
    exit 0
  fi
fi

key="Values.${PRESET}.in_ctr.limactl"

if [[ "${!key}" != "done" ]]; then
  mark_done "${PRESET}.in_ctr.limactl"
  if command -v limactl >/dev/null 2>&1 ; then
    # set_run_ctr "[limactl,shell,${lima_instance},sudo,nerdctl,run,--rm,--privileged]"
    printf "[limactl,shell,%s,sudo,nerdctl,run,--rm,--privileged]" "${lima_instance}"
    exit 0
  fi
fi

key="Values.${PRESET}.in_ctr.docker"

if [[ "${!key}" != "done" ]]; then
  mark_done "${PRESET}.in_ctr.docker"
  if command -v docker >/dev/null 2>&1 ; then
    # set_run_ctr "[docker,run,--rm]"
    printf "[docker,run,--rm]"
    exit 0
  fi
fi

template:dukkha.SetValue "\"${PRESET}.in_ctr.done\"" '"true"' >/dev/null 2>&1

mark_todo "${PRESET}.in_ctr.podman"
mark_todo "${PRESET}.in_ctr.nerdctl"
mark_todo "${PRESET}.in_ctr.limactl"
mark_todo "${PRESET}.in_ctr.docker"
