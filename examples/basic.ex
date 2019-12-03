defmodule KerasEx.Examples.Basic do

  def model() do
    "beef"
    |> KerasEx.new()
    |> KerasEx.dense(4, input_dim: 4, activation: "relu")
    |> KerasEx.compile()
  end

  def run(model \\ model()) do
    KerasEx.fit(model, [1.0, 0.0, 0.0, 1.0], [0.0, 1.0, 1.0, 0.0], epochs: 500)
  end

end
