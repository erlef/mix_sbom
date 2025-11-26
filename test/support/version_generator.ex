defmodule VersionGenerator do
  @moduledoc false

  import StreamData

  @spec full_semver() :: StreamData.t(String.t())
  def full_semver do
    bind(
      tuple({
        non_negative_integer(),
        non_negative_integer(),
        non_negative_integer(),
        one_of([constant(nil), prerelease()]),
        one_of([constant(nil), build_metadata()])
      }),
      fn {major, minor, patch, pre, build} ->
        version = "#{major}.#{minor}.#{patch}"

        version =
          case pre do
            nil -> version
            pre -> "#{version}-#{pre}"
          end

        version =
          case build do
            nil -> version
            build -> "#{version}+#{build}"
          end

        constant(version)
      end
    )
  end

  @spec major_minor() :: StreamData.t(String.t())
  def major_minor do
    map(
      tuple({non_negative_integer(), non_negative_integer()}),
      fn {major, minor} -> "#{major}.#{minor}" end
    )
  end

  @spec major_minor_pre() :: StreamData.t(String.t())
  def major_minor_pre do
    bind(
      tuple({non_negative_integer(), non_negative_integer(), prerelease()}),
      fn {major, minor, pre} ->
        constant("#{major}.#{minor}-#{pre}")
      end
    )
  end

  @spec version_requirement() :: StreamData.t(String.t())
  def version_requirement do
    frequency([
      {3, simple_requirement()},
      {1, complex_requirement()}
    ])
  end

  @spec simple_requirement() :: StreamData.t(String.t())
  defp simple_requirement do
    bind(
      tuple({
        member_of(["==", "!=", "~>", ">", ">=", "<", "<="]),
        non_negative_integer(),
        non_negative_integer(),
        non_negative_integer()
      }),
      fn {op, major, minor, patch} ->
        constant("#{op} #{major}.#{minor}.#{patch}")
      end
    )
  end

  @spec complex_requirement() :: StreamData.t(String.t())
  defp complex_requirement do
    bind(
      tuple({simple_requirement(), member_of(["and", "or"]), simple_requirement()}),
      fn {req1, op, req2} ->
        constant("#{req1} #{op} #{req2}")
      end
    )
  end

  @spec prerelease() :: StreamData.t(String.t())
  defp prerelease do
    frequency([
      {2, map(non_negative_integer(), &to_string/1)},
      {1, prerelease_structured()}
    ])
  end

  @spec prerelease_structured() :: StreamData.t(String.t())
  defp prerelease_structured do
    bind(
      tuple({
        member_of(["alpha", "beta", "rc"]),
        one_of([constant(nil), positive_integer()])
      }),
      fn {name, version} ->
        case version do
          nil -> constant(name)
          version -> constant("#{name}.#{version}")
        end
      end
    )
  end

  @spec build_metadata() :: StreamData.t(String.t())
  defp build_metadata do
    frequency([
      {1, string(:alphanumeric, min_length: 1, max_length: 10)},
      {1, build_structured()}
    ])
  end

  @spec build_structured() :: StreamData.t(String.t())
  defp build_structured do
    bind(
      tuple({
        member_of(["build", "commit", "sha"]),
        string(:alphanumeric, min_length: 1, max_length: 8)
      }),
      fn {prefix, suffix} ->
        constant("#{prefix}.#{suffix}")
      end
    )
  end
end
