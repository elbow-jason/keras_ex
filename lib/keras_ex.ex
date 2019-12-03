defmodule KerasEx do
  alias KerasEx.{
    Model,
  }

  defdelegate new(name), to: Model
  defdelegate new(name, opts), to: Model
  defdelegate new(name, session, opts), to: Model

  def dense(model, size, opts \\ []) do
    Model.call(model, :dense, [size], opts)
  end

  def activation(model, activation_type) do
    Model.call(model, :activation, [activation_type], [])
  end

  def dropout(model, rate, opts \\ []) do
    Model.call(model, :dropout, [rate], opts)
  end

  def compile(model, opts \\ []) when is_list(opts) do
    model
    |> Model.set_compiled(true)
    |> Model.call(:compile_model, [], config_opts(opts, :compile))
  end

  def compile(model, optimizer, opts) when is_list(opts) do
    opts = Keyword.put_new(opts, :optimizer, optimizer)
    compile(model, opts)
  end

  def fit(model, data, labels, opts \\ []) do
    case Model.call_with_result(model, :fit, [data, labels], opts) do
      {:ok, proplist} ->
        {:ok, Enum.into(proplist, %{})}
      err ->
        err
    end
  end

  def predict(model, data, opts \\ []) do
    Model.call_with_result(model, :predict, [data], opts)
  end

  def summary(model) do
    Model.call_with_result(model, :summary, [], nil)
  end

  defp get_config(func_name) do
    Application.get_env(:keras_ex, func_name, [])
  end

  defp config_opts(opts, namespace) do
    namespace
    |> get_config()
    |> Enum.reduce(opts, fn {key, value}, acc ->
      Keyword.put_new(acc, key, value)
    end)
  end

end
