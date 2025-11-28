# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

readme_path = Path.join(__DIR__, "../README.md")

readme_content =
  readme_path
  |> File.read!()
  |> String.replace(~r/<!-- ex_doc_ignore_start -->.*?<!-- ex_doc_ignore_end -->/s, "")

defmodule SBoM do
  @moduledoc readme_content
  @external_resource readme_path
end
