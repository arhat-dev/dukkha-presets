# dukkha-presets

[![CI](https://github.com/arhat-dev/dukkha-presets/workflows/CI/badge.svg)](https://github.com/arhat-dev/dukkha-presets/actions?query=workflow%3ACI)

Shared `dukkha` config recipes for `arhat-dev`

## Usage

Add dukkha-presets as `presets` renderer

```yaml
include:
- text@http: https://raw.githubusercontent.com/arhat-dev/dukkha-presets/master/setup-master.yml
```

## Convensions

### Image Flavor

- `native` (alias of alpine-native)
- `alpine-native`
  - default, use same arch image as host arch, no cross gcc toolchain, alpine based
- `debian-navive`
  - same as alpine-native, but based on debian

- `cross` (alias of alpine-cross)
- `alpine-cross`
  - use same arch image as host arch, with cross gcc, alpine based, when `matrix.arch` is not supported by alpine, switch to debian based image automatically.
  - if no cross toolchain for host_arch, switch to qemu mode automatically
- `debian-cross` (same as alpine-cross, but debian based)

- `qemu` (alias of alpine-qemu)
- `alpine-qemu`
  - use target `matrix.arch` image, should have qemu-static configured in host, when `matrix.arch` is not supported by alpine, switch to debian based image automatically.
- `debian-qemu` (same as alpine-qemu, but debian based)

## LICENSE

```txt
Copyright 2021 The arhat.dev Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
