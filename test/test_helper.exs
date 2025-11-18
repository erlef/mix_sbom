# Force Load Modules
for module <- Application.spec(:sbom, :modules) do
  Code.ensure_compiled!(module)
end

ExUnit.start()
