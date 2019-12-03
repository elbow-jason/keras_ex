defmodule KerasEx.Model do
  alias KerasEx.Model

  defstruct [
    compiled?: false,
    name: nil,
    session: nil,
    layers: [],
  ]

  def new(name) do
    {:ok, session} = KerasEx.Python.start_link()
    new(name, session, [])
  end

  def new(name, opts) when is_list(opts) do
    {:ok, session} = KerasEx.Python.start_link()
    new(name, session, opts)
  end

  def new(name, session) when is_pid(session) do
    new(name, session, [])
  end

  def new(name, session, opts) when is_binary(name) and is_pid(session) and is_list(opts) do
    %Model{
      name: name,
      session: session,
    }
    |> call(:sequential, [], nil)
  end

  def add_layer(%Model{layers: prev} = model, key, params) do
    %__MODULE__{model | layers: prev ++ [{key, params}]}
  end

  def call(%Model{session: session, name: name} = model, func_name, args, kwargs \\ nil) when is_list(args) do
    params =
      session
      |> KerasEx.Python.call(func_name, [name | args], kwargs)
      |> handle_result
    add_layer(model, func_name, params)
  end

  def call_with_result(%Model{session: session, name: name}, func_name, args, kwargs \\ nil) when is_list(args) do
    KerasEx.Python.call(session, func_name, [name | args], kwargs)
  end

  def mute(%Model{session: session}) do
    mute(session)
  end

  def mute(session) when is_pid(session) do
    KerasEx.Python.call(session, :mute, [], nil)
  end

  def unmute(%Model{session: session}) do
    unmute(session)
  end

  def unmute(session) when is_pid(session) do
    KerasEx.Python.call(session, :unmute, [], nil)
  end

  def set_compiled(%Model{} = model, compiled?) do
    %Model{model | compiled?: compiled?}
  end

  defp handle_result([{key, _} | _ ] = result) when is_binary(key) do
    proplist_to_map(result)
  end

  defp handle_result([]) do
    []
  end

  defp handle_result(result) do
    result
  end

  defp proplist_to_map(result) do
    result
    |> Enum.into(%{})
    |> case do
      %{"options" => options} = map ->
        Map.put(map, "options", Enum.into(options, %{}))
      map ->
        map
    end
  end
end
