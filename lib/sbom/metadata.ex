# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

defmodule SBoM.Metadata do
  @moduledoc """
  Centralizes package-level metadata normalization for SBOM generation.

  This module provides unified functions to extract and normalize metadata
  from different sources:
  - Mix project configuration (local metadata)
  - Hex API responses (remote metadata)
  - Future SCM integrations

  All functions return a standardized metadata map with:
  - `:licenses` - List of license identifiers
  - `:source_url` - Source repository URL
  - `:links` - Map of normalized link keys to URLs
  """

  alias SBoM.Fetcher.Links

  @type metadata() :: %{
          optional(:licenses) => [String.t()],
          optional(:source_url) => String.t() | nil,
          optional(:links) => Links.t()
        }

  @doc """
  Extracts and normalizes metadata from Mix project configuration.

  This function extracts licenses, links, and source_url from a Mix config
  (typically from `Mix.Project.config()` or `Mix.Project.get!().application()`).

  ## Examples

      iex> config = [
      ...>   licenses: ["Apache-2.0"],
      ...>   source_url: "https://github.com/example/repo",
      ...>   links: %{"github" => "https://github.com/example/repo"}
      ...> ]
      ...>
      ...> SBoM.Metadata.from_mix_config(config)
      %{
        licenses: ["Apache-2.0"],
        source_url: "https://github.com/example/repo",
        links: %{"github" => "https://github.com/example/repo"}
      }

      iex> config = [
      ...>   package: [
      ...>     licenses: ["MIT"],
      ...>     links: %{"homepage" => "https://example.com"}
      ...>   ]
      ...> ]
      ...>
      ...> SBoM.Metadata.from_mix_config(config)
      %{
        licenses: ["MIT"],
        source_url: nil,
        links: %{"homepage" => "https://example.com"}
      }
  """
  @spec from_mix_config(Keyword.t()) :: metadata()
  def from_mix_config(config) when is_list(config) do
    links = config[:links] || config[:package][:links] || %{}
    normalized_links = Links.normalize_link_keys(links)

    licenses = config[:licenses] || config[:package][:licenses] || []
    licenses = List.wrap(licenses)

    source_url = config[:source_url] || Links.source_url(normalized_links)

    %{
      licenses: licenses,
      source_url: source_url,
      links: normalized_links
    }
  end

  @doc """
  Extracts and normalizes metadata from Hex API payload.

  This function extracts licenses, links, and source_url from a Hex API
  package response (typically from `:hex_api_package.get/2`).

  The payload structure is expected to be:
  ```json
  {
    "meta": {
      "licenses": ["Apache-2.0"],
      "links": {
        "GitHub": "https://github.com/example/repo"
      }
    },
    "docs_html_url": "https://hexdocs.pm/package/",
    "html_url": "https://hex.pm/packages/package"
  }
  ```

  This function also extracts additional URLs from the payload:
  - `docs_html_url` → added as `"docs"` link (if not already present)
  - `html_url` → added as `"homepage"` link (if not already present)

  ## Examples

      iex> payload = %{
      ...>   "meta" => %{
      ...>     "licenses" => ["MIT"],
      ...>     "links" => %{
      ...>       "GitHub" => "https://github.com/example/repo"
      ...>     }
      ...>   },
      ...>   "docs_html_url" => "https://hexdocs.pm/package/",
      ...>   "html_url" => "https://hex.pm/packages/package"
      ...> }
      ...>
      ...> SBoM.Metadata.from_hex_payload(payload)
      %{
        licenses: ["MIT"],
        source_url: "https://github.com/example/repo",
        links: %{
          "github" => "https://github.com/example/repo",
          "docs" => "https://hexdocs.pm/package/",
          "homepage" => "https://hex.pm/packages/package"
        }
      }

      # Existing links in meta.links take precedence
      iex> payload = %{
      ...>   "meta" => %{
      ...>     "licenses" => ["MIT"],
      ...>     "links" => %{
      ...>       "GitHub" => "https://github.com/example/repo",
      ...>       "Homepage" => "https://example.com"
      ...>     }
      ...>   },
      ...>   "docs_html_url" => "https://hexdocs.pm/package/",
      ...>   "html_url" => "https://hex.pm/packages/package"
      ...> }
      ...>
      ...> SBoM.Metadata.from_hex_payload(payload)
      %{
        licenses: ["MIT"],
        source_url: "https://github.com/example/repo",
        links: %{
          "github" => "https://github.com/example/repo",
          "homepage" => "https://example.com",
          "docs" => "https://hexdocs.pm/package/"
        }
      }

      iex> SBoM.Metadata.from_hex_payload(%{})
      %{
        licenses: [],
        source_url: nil,
        links: %{}
      }
  """
  @spec from_hex_payload(map()) :: metadata()
  def from_hex_payload(payload) when is_map(payload) do
    meta = payload["meta"] || %{}
    links = meta["links"] || %{}

    # Normalize links first (keys may be strings with mixed case from Hex API)
    normalized_links = Links.normalize_link_keys(links)

    # Add docs_html_url as "docs" link if not already present (check normalized keys)
    normalized_links =
      if docs_url = payload["docs_html_url"] do
        Map.put_new(normalized_links, "docs", docs_url)
      else
        normalized_links
      end

    # Add html_url as "homepage" link if not already present (check normalized keys)
    normalized_links =
      if homepage_url = payload["html_url"] do
        Map.put_new(normalized_links, "homepage", homepage_url)
      else
        normalized_links
      end

    # Extract licenses
    licenses = meta["licenses"] || []
    licenses = List.wrap(licenses)

    # Derive source_url using the same rules as from_mix_config
    source_url = Links.source_url(normalized_links)

    %{
      licenses: licenses,
      source_url: source_url,
      links: normalized_links
    }
  end
end
