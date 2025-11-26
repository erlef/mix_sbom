# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

defmodule SBoM.Fetcher.Links do
  @moduledoc false

  @type t() :: %{optional(String.t()) => String.t()}

  @source_url_names [
    "github",
    "gitlab",
    "git",
    "source",
    "repository",
    "bitbucket"
  ]

  @spec source_url(links :: %{String.t() => String.t()}) :: String.t() | nil
  def source_url(links) do
    Enum.find_value(links, fn {name, url} ->
      if String.downcase(name) in @source_url_names do
        url
      end
    end)
  end
end
