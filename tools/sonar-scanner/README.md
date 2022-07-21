# sonar-scanner

## Prerequisites

Environment Variables:

- SONAR_HOST_URL
- SONAR_TOKEN

## Usage

```yaml
cmd@tmpl:
  template@presets?str: tools/sonar-scanner/ctr.yml
  variables:
    # version of sonar-scanner
    #
    # Defaults to "4.7"
    version: "4.7"

    # workdir when running sonar-scanner
    #
    # Defaults to dukkha.WorkDir
    workdir: ""

    # cmd list to run container, so we can run sonar-scanner
    # in container if no local installation found
    #
    # Defaults to values.cmd.run_ctr, then [docker, run, --rm]
    run_ctr: []

    # container image to run when local installtion not found
    #
    # Defaults to docker.io/sonarsource/sonar-scanner-cli:{{ var.version }}
    image: ""
```
