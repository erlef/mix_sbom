# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

defmodule SBoM.CycloneDX.Protobuf do
  @moduledoc false

  alias SBoM.Cyclonedx.V17.Bom

  @spec encode(SBoM.CycloneDX.t()) :: iodata()
  def encode(%module{} = bom), do: module.encode(bom)

  @spec decode(binary()) :: SBoM.CycloneDX.t()
  def decode(data) do
    # First, decode the BOM to get the spec version
    %{} = bom = Bom.decode(data)
    version = bom.spec_version || "1.6"

    # Get the appropriate BOM struct module for this version
    bom_module = SBoM.CycloneDX.bom_struct_module(:Bom, version)

    # Decode again using the correct module
    bom_module.decode(data)
  end
end
