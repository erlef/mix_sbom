# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

[
  # Hex Archive does not contain debug information
  ~r"Function Hex\..+ does not exist\.",
  # Hex API functions from hex archive (no debug info available)
  ~r"Function :hex_api_package\.get\/2 does not exist\.",
  ~r"Function :hex_core\.default_config\/0 does not exist\.",
  # Types not exported
  ~r"Unknown type: :xmerl\.simple_(element|attribute)\/0\."
]
