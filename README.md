<!--
  SPDX-License-Identifier: BSD-3-Clause
  SPDX-FileCopyrightText: 2019 Bram Verburg
  SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation
-->

<!-- ex_doc_ignore_start -->
# SBoM
<!-- ex_doc_ignore_end -->

[![EEF Security WG project](https://img.shields.io/badge/EEF-Security-black)](https://github.com/erlef/security-wg)
[![.github/workflows/branch_main.yml](https://github.com/erlef/mix_sbom/actions/workflows/branch_main.yml/badge.svg)](https://github.com/erlef/mix_sbom/actions/workflows/branch_main.yml)
[![Coverage Status](https://coveralls.io/repos/github/erlef/mix_sbom/badge.svg?branch=main)](https://coveralls.io/github/erlef/mix_sbom?branch=main)
[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/erlef/mix_sbom/badge)](https://scorecard.dev/viewer/?uri=github.com/erlef/mix_sbom)
[![OpenSSF Best Practices](https://www.bestpractices.dev/projects/11509/badge)](https://www.bestpractices.dev/projects/11509)
[![REUSE status](https://api.reuse.software/badge/github.com/erlef/mix_sbom)](https://api.reuse.software/info/github.com/erlef/mix_sbom)

Generates a Software Bill-of-Materials (SBoM) for Mix projects, in [CycloneDX](https://cyclonedx.org)
format.

<!-- ex_doc_ignore_start -->
Full documentation can be found at [https://hexdocs.pm/sbom](https://hexdocs.pm/sbom).
<!-- ex_doc_ignore_end -->

For a quick demo of how this might be used, check out [this blog post](https://blog.voltone.net/post/24).

## Installation

This tool can be installed in several ways:

### 1. Project Dependency (Recommended for development)

Add the dependency to your project's `mix.exs` (development only):

```elixir
def deps do
  [
    {:sbom, "~> 0.8", only: :dev, runtime: false},
    # If using Elixir < 1.18 and want JSON output, also add:
    # {:jason, "~> 1.4"}
  ]
end
```

> ⚠️ **Important**: We recommend using `only: :dev, runtime: false` to prevent
> including the SBoM tooling in production deployments. Do not run
> `mix sbom.cyclonedx` with `MIX_ENV=prod` as the dependency will not be
> available in that environment.

### 2. Mix Escript (Global installation)

> ⚠️ **Warning**: Requires Elixir >= 1.19.4

Install the Mix task globally on your system:

```bash
mix escript.install hex sbom
```

### 4. Burrito Binary (From releases)

Download the self-contained binary from the
[releases page](https://github.com/erlef/mix_sbom/releases)
(does not require BEAM runtime).

## Usage

### As a Mix Task (project dependency only)

When installed as a project dependency, run from the project directory
containing `mix.exs`:

```bash
mix sbom.cyclonedx
```

The result is written to `bom.cdx.json` unless a different name is specified
using the `-o` option. Use `--only dev --only test --only prod` to include
dependencies from specific environments.

### As a Standalone Binary (escript install or Burrito)

When using the globally installed escript, downloaded escript, or Burrito
binary, you must provide the project path as an argument:

```bash
# Global escript or downloaded binary
mix_sbom cyclonedx /path/to/your/project

# Or with options
mix_sbom cyclonedx --output=my-sbom.json --format=json --only prod \
  /path/to/your/project
```

### Common Notes

By default dependencies from all environments are included. To include only
production dependencies, use `--only prod`. To include specific environments,
use multiple `--only` flags like `--only dev --only test --only prod`.

*Note that MIX_ENV does not affect which dependencies are included in the
output; the task should normally be run in the default (dev) environment*

### Available Options

- `-o, --output PATH`: Output file path (defaults to `bom.cdx.json`)
  Use `-` for STDOUT
- `-s, --schema VERSION`: CycloneDX schema version - 1.3, 1.4, 1.5, 1.6, 1.7
  (defaults to 1.6)
- `-t, --format FORMAT`: Output format - xml, json, protobuf (defaults to json)
- `-l, --only ENV`: Only include dependencies from specified environments
  (defaults to all, use multiple flags for multiple environments)
- `-a, --targets TARGET`: Include components from specified Mix targets
  (defaults to all, use multiple flags for multiple targets)
- `-c, --classification TYPE`: Component classification type
  (defaults to application). Common types include `application`, `framework`,
  and `library`. See [CycloneDX documentation](https://cyclonedx.org/docs/1.7/json/#components_items_type_enum)
  for all available types.
- `-f, --force`: Overwrite existing output file
- `-r, --recurse`: Recurse into umbrella applications

For more information:

- Mix task: `mix help sbom.cyclonedx`
- Standalone binary: `mix_sbom --help`

## GitHub Action

This tool is also available as a GitHub Action for use in CI/CD workflows.
The action downloads and verifies the provenance of the binary, then generates
an SBoM for your project.

### Basic Usage

```yaml
- name: Generate SBoM
  uses: erlef/mix_sbom@v0
  id: sbom
  with:
    project-path: ${{ github.workspace }}
    schema: "1.6"
    format: "json"

- name: Display SBoM
  run: cat "$SBOM_FILE"
  env:
    SBOM_FILE: ${{ steps.sbom.outputs.sbom-path }}
```

### Inputs

- `project-path`: Path to the directory containing mix.exs
  (defaults to repository root)
- `schema`: CycloneDX schema version (defaults to "1.6")
- `format`: Output format - "json", "xml", or "protobuf"
  (defaults to "json")
- `reuse-beam`: Use local BEAM installation instead of pre-compiled binaries
  (defaults to "false")

### Outputs

- `sbom-path`: Path to the generated SBoM file

The action automatically handles downloading the correct binary for your
runner's architecture and verifies its provenance using GitHub's attestation
system.

### Using Local BEAM (Recommended)

> ⚠️ **Warning**: Using `reuse-beam: true` requires Elixir >= 1.19.4

For the most accurate dependency analysis, it's recommended to use the local
BEAM installation by setting `reuse-beam: true`. This approach:

- Properly detects Elixir and Erlang versions in the generated SBoM
- Works with your project's specific runtime environment
- Provides more accurate dependency information

To use this approach, first set up Elixir/Erlang in your workflow:

```yaml
- name: Set up Elixir
  uses: erlef/setup-beam@v1
  with:
    elixir-version: '1.17.3'
    otp-version: '27.1'

- name: Get dependencies
  run: mix deps.get

- name: Generate SBoM
  uses: erlef/mix_sbom@v0
  with:
    reuse-beam: true
```

**Note**: For most detailed dependency analysis, you should run `mix deps.get`
before using this action to ensure all dependencies are resolved.

## NPM packages and other dependencies

This tool only considers Hex, GitHub and BitBucket dependencies managed through
Mix. To build a comprehensive SBoM of a deployment, including NPM and/or
operating system packages, it may be necessary to merge multiple CycloneDX files
into one.

The [@cyclonedx/bom](https://www.npmjs.com/package/@cyclonedx/bom) tool on NPM
can not only generate an SBoM for your JavaScript assets, but it can also merge
in the output of the 'sbom.cyclonedx' Mix task and other scanners, through the
'-a' option, producing a single CycloneDX XML file.
