# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :keras_ex, :python,
  priv_dir: :keras_ex,
  rel_path: "python",
  app_module: :app_v_0_1_0

config :keras_ex, :compile,
  optimizer: "rmsprop",
  loss: "mse"
