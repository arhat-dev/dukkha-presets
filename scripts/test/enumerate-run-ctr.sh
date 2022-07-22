# shellcheck shell=bash
# shellcheck disable=SC2154

# output of this script is a yaml list of command to run container

mark_done() {
  tmpl:dukkha.SetValue "${1}" "done" >/dev/null 2>&1
}

mark_todo() {
  tmpl:dukkha.SetValue "${1}" "todo" >/dev/null 2>&1
}

key="values.${PRESET}.in_ctr.podman"

if [[ "${!key}" != "done" ]]; then
  mark_done "${PRESET}.in_ctr.podman"
  if command -v podman >/dev/null 2>&1 ; then

    tmpl:dukkha.Self render <<EOF
__@tmpl#use-spec:
  template@presets?str: templates/run-ctr.tmpl
  variables:
    order: [podman]
    # for macos
    lima_instance@presets?str|tmpl: templates/first-active-lima-instance.tmpl
EOF

    exit 0
  fi
fi

key="values.${PRESET}.in_ctr.nerdctl"

if [[ "${!key}" != "done" ]]; then
  mark_done "${PRESET}.in_ctr.nerdctl"
  if command -v nerdctl >/dev/null 2>&1 ; then

    tmpl:dukkha.Self render <<EOF
__@tmpl#use-spec:
  template@presets?str: templates/run-ctr.tmpl
  variables:
    order: [nerdctl]
EOF

    exit 0
  fi
fi

key="values.${PRESET}.in_ctr.limactl"

if [[ "${!key}" != "done" ]]; then
  mark_done "${PRESET}.in_ctr.limactl"
  if command -v limactl >/dev/null 2>&1 ; then

    tmpl:dukkha.Self render <<EOF
__@tmpl#use-spec:
  template@presets?str: templates/run-ctr.tmpl
  variables:
    order: [lima-nerdctl]
    # for macos
    lima_instance@presets?str|tmpl: templates/first-active-lima-instance.tmpl
EOF

    exit 0
  fi
fi

# key="values.${PRESET}.in_ctr.docker"
#
# if [[ "${!key}" != "done" ]]; then
#   mark_done "${PRESET}.in_ctr.docker"
#   if command -v docker >/dev/null 2>&1 ; then
#
#     tmpl:dukkha.Self render <<EOF
# __@tmpl#use-spec:
#   template@presets?str: templates/run-ctr.tmpl
#   variables:
#     order: [docker]
# EOF
#
#     exit 0
#   fi
# fi

tmpl:dukkha.SetValue "${PRESET}.in_ctr.done" "true" >/dev/null 2>&1

mark_todo "${PRESET}.in_ctr.podman"
mark_todo "${PRESET}.in_ctr.nerdctl"
mark_todo "${PRESET}.in_ctr.limactl"
# mark_todo "${PRESET}.in_ctr.docker"
