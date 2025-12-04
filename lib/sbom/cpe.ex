# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Stritzinger GmbH

defmodule SBoM.CPE do
  @moduledoc false

  # CPE (Common Platform Enumeration) generation for components.
  #
  # CPE is a structured naming scheme for software. Format:
  # `cpe:2.3:a:vendor:product:version:*:*:*:*:*:*:*`
  #
  # This module generates CPE identifiers for Hex packages:
  # - Uses predefined EEF CNA vendor assignments for known packages
  # - Falls back to GitHub organization from project links
  # - Returns nil if vendor cannot be determined

  @cpe_version "2.3"
  @cpe_postfix ":*:*:*:*:*:*:*"

  # Known packages with predefined CPE vendors (EEF CNA assignments)
  @known_cpes %{
    "hex_core" => "hex",
    "plug" => "elixir-plug",
    "phoenix" => "phoenixframework",
    "coherence" => "coherence_project",
    "xain" => "emetrotel",
    "sweet_xml" => "kbrw",
    "rebar3" => "erlang",
    "elixir" => "elixir-lang"
  }

  @doc """
  Generate CPE for a Hex package.

  ## Examples

  Known packages use predefined EEF CNA vendor assignments:

      iex> SBoM.CPE.hex("phoenix", "1.7.0", nil)
      "cpe:2.3:a:phoenixframework:phoenix:1.7.0:*:*:*:*:*:*:*"

      iex> SBoM.CPE.hex("elixir", "1.16.0", nil)
      "cpe:2.3:a:elixir-lang:elixir:1.16.0:*:*:*:*:*:*:*"

  When version is nil or empty, uses "*":

      iex> SBoM.CPE.hex("phoenix", nil, nil)
      "cpe:2.3:a:phoenixframework:phoenix:*:*:*:*:*:*:*:*"

      iex> SBoM.CPE.hex("jason", nil, "https://github.com/michalmuskala/jason")
      "cpe:2.3:a:michalmuskala:jason:*:*:*:*:*:*:*:*"

  For unknown packages, extracts vendor from GitHub URL:

      iex> SBoM.CPE.hex("jason", "1.4.0", "https://github.com/michalmuskala/jason")
      "cpe:2.3:a:michalmuskala:jason:1.4.0:*:*:*:*:*:*:*"

  Returns nil when no URL and package is unknown:

      iex> SBoM.CPE.hex("unknown_pkg", "1.0.0", nil)
      nil
  """
  @spec hex(String.t(), String.t() | nil, String.t() | nil) :: String.t() | nil
  def hex(name, version, github_url)

  # Handle nil or empty version -> use "*"
  def hex(name, nil, github_url), do: hex(name, "*", github_url)
  def hex(name, "", github_url), do: hex(name, "*", github_url)

  # Known packages
  def hex(name, version, _url) when is_map_key(@known_cpes, name) do
    vendor = @known_cpes[name]
    build_cpe(vendor, name, version)
  end

  # No URL - can't determine vendor
  def hex(_name, _version, nil), do: nil

  # Extract vendor from GitHub URL
  def hex(name, version, url) do
    case extract_github_org(url) do
      nil -> nil
      org -> build_cpe(org, name, version)
    end
  end

  @spec build_cpe(String.t(), String.t(), String.t()) :: String.t()
  defp build_cpe(vendor, product, version) do
    "cpe:#{@cpe_version}:a:#{vendor}:#{product}:#{version}#{@cpe_postfix}"
  end

  @spec extract_github_org(String.t()) :: String.t() | nil
  defp extract_github_org(url) when is_binary(url) do
    case Regex.run(~r{https?://github\.com/([^/]+)}, url) do
      [_full_match, org] -> String.downcase(org)
      _other -> nil
    end
  end

  @spec extract_github_org(any()) :: nil
  defp extract_github_org(_other), do: nil
end
