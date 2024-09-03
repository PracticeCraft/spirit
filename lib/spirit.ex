defmodule Spirit do
  @moduledoc """
  Documentation for `Spirit`.
  """
  import TerminalHelpers

  @welcome_message """

  #{style("Welcome to Spirit! 💧", [:fg_cyan, :bold])}

  This repo consists of a number of exercises that accompany the Elixir Getting
  Started Guides.

  The following paragraphs explain some of the Elixir philosophies that drive
  the intended workflow of doing this exercise. If this is your first time
  doing the exercises, it is highly recommended that you read them.
  """

  @intro_message """
  Your workflow should be something like this:
    1. Read one of the guides (e.g., Basic Types:
       https://hexdocs.pm/elixir/basic-types.html)
    2. Solve the exercises here in the module corresponding to that guide
    3. Run the tests for that module
    4. Repeat steps 2 & 3 until all the tests pass
    5. Proceed to the next guide

  The repo is structured like any typical Elixir project with no extra magic.
  This should get your hands on working with Elixir projects, interacting with
  modules and functions, running tests, etc.

  Also, as documentation is a first class citizen in Elixir, you are encouraged
  to use the documentation system in many ways:
    1. The Getting Started guides are part of the official documentation
    2. In the interactive Elixir shell (IEx) you can use `h` to view the
    documentation of any module or function (e.g., `h Spirit`).
    3. The `Spirit` module contains a `help` function, which you can call to
    give you a few hints that may help you work with this project.
      - `Spirit.help()` for listing available help pages
      - `Spirit.help(:arg)` for a specific help page
  """

  @help_message """
  """

  defp prompt_intro() do
    input = IO.gets(style("Continue with the intro? [Y/n]\n", [:faint]))

    case input do
      "n\n" -> :exit
      "N\n" -> :exit
      _ -> :continue
    end
  end

  @doc """
  Get started with Spirit

  This is an interactive introduction to Spirit and the workflow of solving the
  exercises.
  """
  def hello() do
    IO.puts(@welcome_message)
    if prompt_intro() == :continue, do: IO.puts(@intro_message)
    :have_fun
  end

  def help(), do: @help_message
  def help(arg), do: raise("No help page named `#{arg}`, run `Spirit.help()` for info")
end
