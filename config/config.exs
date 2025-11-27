# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

import Config

if config_env() == :test do
  config :stream_data, max_runs: 100
end
