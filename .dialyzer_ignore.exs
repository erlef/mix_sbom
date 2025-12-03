# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

[
  # Hex Archive does not contain debug information
  ~r"Function Hex\..+ does not exist\.",
  # Types not exported
  ~r"Unknown type: :xmerl\.simple_(element|attribute)\/0\."
]
