# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2019 Bram Verburg
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

# Force Load Modules
for module <- Application.spec(:sbom, :modules) do
  Code.ensure_compiled!(module)
end

# The Burrito standalone path is only compiled in when Burrito is available.
burrito_exclude = if Code.ensure_loaded?(Burrito.Util), do: [], else: [:burrito]

ExUnit.start(
  exclude: [:property | burrito_exclude],
  capture_log: true,
  capture_io: true
)
