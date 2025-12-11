defmodule SBoM.CycloneDX.V17.LicenseAcknowledgementEnumeration do
  @moduledoc """
  Declared licenses and concluded licenses represent two different stages in the licensing process within software development. Declared licenses refer to the initial intention of the software authors regarding the licensing terms under which their code is released. On the other hand, concluded licenses are the result of a comprehensive analysis of the project's codebase to identify and confirm the actual licenses of the components used, which may differ from the initially declared licenses. While declared licenses provide an upfront indication of the licensing intentions, concluded licenses offer a more thorough understanding of the actual licensing within a project, facilitating proper compliance and risk management. Observed licenses are defined in `@.evidence.licenses`. Observed licenses form the evidence necessary to substantiate a concluded license.
  """

  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:LICENSE_ACKNOWLEDGEMENT_ENUMERATION_UNSPECIFIED, 0)
  field(:LICENSE_ACKNOWLEDGEMENT_ENUMERATION_DECLARED, 1)
  field(:LICENSE_ACKNOWLEDGEMENT_ENUMERATION_CONCLUDED, 2)
end
