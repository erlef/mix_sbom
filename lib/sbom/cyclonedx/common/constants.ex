# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

defmodule SBoM.CycloneDX.Common.Constants do
  @moduledoc false

  import Bitwise, only: [bsl: 2]

  # Integer type definitions and ranges
  @int32_range -bsl(1, 31)..(bsl(1, 31) - 1)
  @int64_range -bsl(1, 63)..(bsl(1, 63) - 1)
  @uint32_range 0..(bsl(1, 32) - 1)
  @uint64_range 0..(bsl(1, 64) - 1)

  @int_ranges %{
    int32: @int32_range,
    int64: @int64_range,
    sint32: @int32_range,
    sint64: @int64_range,
    sfixed32: @int32_range,
    sfixed64: @int64_range,
    fixed32: @int32_range,
    fixed64: @int64_range,
    uint32: @uint32_range,
    uint64: @uint64_range
  }

  @int_types Map.keys(@int_ranges)

  # Float type definitions
  max_float = 3.402_823_466e38
  @float_range {-max_float, max_float}
  @float_types [:float, :double]

  # Type groupings for encoding
  @int32_types ~w(int32 sint32 sfixed32 fixed32 uint32)a
  @int64_types ~w(int64 sint64 sfixed64 fixed64 uint64)a

  # Public accessors
  @spec int32_range() :: Range.t()
  def int32_range, do: @int32_range

  @spec int64_range() :: Range.t()
  def int64_range, do: @int64_range

  @spec uint32_range() :: Range.t()
  def uint32_range, do: @uint32_range

  @spec uint64_range() :: Range.t()
  def uint64_range, do: @uint64_range

  @spec int_ranges() :: map()
  def int_ranges, do: @int_ranges

  @spec int_types() :: [atom()]
  def int_types, do: @int_types

  @spec float_range() :: {float(), float()}
  def float_range, do: @float_range

  @spec float_types() :: [atom()]
  def float_types, do: @float_types

  @spec int32_types() :: [atom()]
  def int32_types, do: @int32_types

  @spec int64_types() :: [atom()]
  def int64_types, do: @int64_types
end
