defmodule KerasEx.Examples.Xor do
  @data [
    [0.0, 0.0],
    [0.0, 1.0],
    [1.0, 0.0],
    [1.0, 1.0]
  ]

  @labels [
    [0.0],
    [1.0],
    [1.0],
    [0.0]
  ]

  def model do
    KerasEx.new("xor")
    |> KerasEx.dense(8, input_dim: 2)
    |> KerasEx.activation("tanh")
    |> KerasEx.dense(1)
    |> KerasEx.activation("sigmoid")
    |> KerasEx.compile("sgd", loss: "binary_crossentropy")
  end

  def fit(m) do
    KerasEx.fit(m, @data, @labels, batch_size: 1, epochs: 1000, verbose: 0)
  end
end
