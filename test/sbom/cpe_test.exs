# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

defmodule SBoM.CPETest do
  use ExUnit.Case, async: false

  alias SBoM.CPE

  doctest CPE

  test "component includes CPE when GitHub link present" do
    bom = SBoM.CycloneDX.bom()

    if bom.metadata.component.cpe do
      assert String.starts_with?(bom.metadata.component.cpe, "cpe:2.3:a:")
    end
  end
end
