# lifed from Phoenix gen secret
# https://raw.githubusercontent.com/phoenixframework/phoenix/master/lib/mix/tasks/phx.gen.secret.ex
defmodule Mix.Tasks.Guardian.Gen.Secret do
  @shortdoc "Generates a secret"

  @moduledoc """
  Generates a secret and prints it to the terminal.

      mix guardian.gen.secret [length]

  By default, mix guardian.gen.secret generates a key 64 characters long.

  The minimum value for `length` is 32.
  """
  use Mix.Task

  @doc false
  def run([]),    do: run(["64"])
  def run([int]), do: int |> parse!() |> random_string() |> Mix.Shell.IO.info()
  def run([_|_]), do: invalid_args!()

  defp parse!(int) do
    case Integer.parse(int) do
      {int, ""} -> int
      _ -> invalid_args!()
    end
  end

  defp random_string(length) when length > 31 do
    length |> :crypto.strong_rand_bytes() |> Base.encode64() |> binary_part(0, length)
  end
  defp random_string(_), do: Mix.raise "The secret should be at least 32 characters long"

  @spec invalid_args!() :: no_return()
  defp invalid_args! do
    Mix.raise "mix guardian.gen.secret expects a length as integer or no argument at all"
  end
end
