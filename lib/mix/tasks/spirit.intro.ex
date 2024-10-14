defmodule Mix.Tasks.Spirit.Intro do
  use Mix.Task

  @message """

  #{IO.ANSI.cyan() <> IO.ANSI.bright() <> "Welcome to Spirit! 💧" <> IO.ANSI.reset()}

  Spirit gives you exercises that accompany the Elixir Getting Started guide.
  The project is structured to mimic typical Elixir project workflow and give
  you some hands-on experience. You are also encouraged to start a REPL with
  `iex -S mix` if you want to do more interactive testing.

  Your workflow should be something like this:

    1. Read one of the guides
       (e.g., Basic Types: https://hexdocs.pm/elixir/basic-types.html)

    2. Generate the exercises and tests using the Mix task `spirit.gen`
       (e.g., `mix spirit.gen basic_types`)

    3. Solve the exercises in the generated module

    4. Run the tests with `mix test`

    5. Repeat steps 2 & 3 until all the tests pass

    6. Proceed to the next guide

  If you find any issues or need support, open an issue at:
  https://github.com/PracticeCraft/spirit/issues
  """

  def run(_) do
    IO.puts(@message)
  end
end
