# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2026 Erlang Ecosystem Foundation

# Drives SBoM.Application.start/2 down the Burrito standalone path in a
# subprocess, to prove the callback halts instead of returning.
#
# :sys.suspend/1 on the global name server stalls VM shutdown. Without it an
# asynchronous System.stop/1 could terminate the node before the callback
# returns, hiding the race this guards against.

{:ok, _apps} = Application.ensure_all_started(:sbom)

System.put_env("__BURRITO", "1")

:ok = :sys.suspend(:global_name_server)

SBoM.Application.start(:normal, [])

IO.puts("Application startup returned")
System.halt(99)
