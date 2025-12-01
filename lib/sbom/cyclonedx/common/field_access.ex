# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

defmodule SBoM.CycloneDX.Common.FieldAccess do
  @moduledoc false

  @callback fetch_field_value(%Protobuf.FieldProps{}, map()) :: {:ok, term()} | :error
  @callback decode_bool_scalar(atom(), term()) :: boolean()
  @callback decode_embedded(term(), module()) :: struct()
end
