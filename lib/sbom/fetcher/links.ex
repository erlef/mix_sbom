# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation
# SPDX-FileCopyrightText: 2025 Stritzinger GmbH

defmodule SBoM.Fetcher.Links do
  @moduledoc false

  @type t() :: %{optional(atom() | String.t()) => String.t()}

  @source_url_names [
    "github",
    "gitlab",
    "git",
    "source",
    "repository",
    "bitbucket"
  ]

  @spec source_url(links :: t()) :: String.t() | nil
  def source_url(links) do
    links
    |> normalize_link_keys()
    |> Enum.find_value(fn {name, url} ->
      if name in @source_url_names do
        url
      end
    end)
  end

  @spec normalize_link_keys(links :: t()) :: %{String.t() => String.t()}
  def normalize_link_keys(links) do
    Map.new(links, fn {name, value} ->
      {name |> to_string() |> String.downcase(), value}
    end)
  end
end
