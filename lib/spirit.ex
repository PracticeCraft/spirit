defmodule Spirit do
  @moduledoc """
  Documentation for `Spirit`.
  """
  import TerminalHelpers

  @doc """
  Hello world.

  ## Examples

      iex> Spirit.hello()
      :world

  """
  def hello do
    IO.puts("")
    IO.puts(style("Welcome to Spirit! 💧", [:fg_cyan, :bold]))
    IO.puts(style("\nPress enter to continue", [:faint]))
    IO.gets("")

    :bye
  end
end
