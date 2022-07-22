if fs.Lookup "limactl"

  $lima_list := (eval.Shell "limactl list --json").Stdout \
      | jq "select(.status == \"Running\") | .name" \
      | strings.Split "\n"

  if $lima_list
    index 0 $lima_list
  end

end
