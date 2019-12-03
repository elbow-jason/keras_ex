defmodule KerasEx.Python do

  def start() do
    :python.start(python_config())
  end

  def start_link() do
    :python.start(python_config())
  end

  def python_path() do
    cfg = Application.get_env(:keras_ex, :python)
    priv_dir = cfg |> Keyword.get(:priv_dir, :keras_ex) |> :code.priv_dir
    rel_dir = cfg |> Keyword.get(:rel_dir, "python")
    [priv_dir, rel_dir]
    |> Path.join()
    |> to_charlist()
  end

  def python_options() do
    :keras_ex
    |> Application.get_env(:python)
    |> Keyword.get(:options, [])
  end

  @spec python_config() :: nonempty_maybe_improper_list()
  def python_config() do
    [ {:python_path, python_path()} | python_options()  ]
  end

  def app_module() do
    :keras_ex
    |> Application.get_env(:python)
    |> Keyword.fetch!(:app_module)
  end

  def call(pid, m \\ app_module(), f, a, k) when is_atom(m) and is_atom(f) and is_list(a) do
    args = assemble_args_and_kwargs(a, k)
    :python.call(pid, m, f, args)
  end

  defp assemble_args_and_kwargs(args, nil) do
    args
  end

  defp assemble_args_and_kwargs(args, kwargs) when is_list(kwargs) do
    args ++ [to_proplist(kwargs)]
  end

  def stop(pid) do
    :python.stop(pid)
  end

  def to_proplist(kwargs) do
    Enum.map(kwargs, fn {k, v} -> {to_string(k), v} end)
  end
end
