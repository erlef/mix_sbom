defmodule SBoM.CycloneDX.V17.ModelCard do
  @moduledoc """
  *
  A model card describes the intended uses of a machine learning model and potential limitations, including biases and ethical considerations. Model cards typically contain the training parameters, which datasets were used to train the model, performance metrics, and other relevant data useful for ML transparency. This object SHOULD be specified for any component of type `machine-learning-model` and must not be specified for other component types.

  Comment:
  Model card support in CycloneDX is derived from TensorFlow Model Card Toolkit released under the Apache 2.0 license and available from https://github.com/tensorflow/model-card-toolkit/blob/main/model_card_toolkit/schema/v0.0.2/model_card.schema.json. In addition, CycloneDX model card support includes portions of VerifyML, also released under the Apache 2.0 license and available from https://github.com/cylynx/verifyml/blob/main/verifyml/model_card_toolkit/schema/v0.0.4/model_card.schema.json.
  """

  use Protobuf,
    full_name: "cyclonedx.v1_7.ModelCard",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:bom_ref, 1, proto3_optional: true, type: :string, json_name: "bomRef")

  field(:modelParameters, 2,
    proto3_optional: true,
    type: SBoM.CycloneDX.V17.ModelCard.ModelParameters
  )

  field(:quantitativeAnalysis, 3,
    proto3_optional: true,
    type: SBoM.CycloneDX.V17.ModelCard.QuantitativeAnalysis
  )

  field(:considerations, 4,
    proto3_optional: true,
    type: SBoM.CycloneDX.V17.ModelCard.ModelCardConsiderations
  )
end
