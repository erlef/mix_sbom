# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2019 Bram Verburg
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

# Force Load Modules
for module <- Application.spec(:sbom, :modules) do
  Code.ensure_compiled!(module)
end

ExUnit.start(exclude: :property)
