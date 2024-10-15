# Spirit 💧

A series of exercises for Elixir newcomers to practice with language basics and
local development.

## Why?

There are a lot of quality sources for learning Elixir out there, the top of
which being the official documentation. Spirit was specifically developed with
these goals in mind:

- **Complement the official docs**: the exercises follow the same order as the
official [Elixir Getting Started
guide](https://hexdocs.pm/elixir/introduction.html). If you are new to Elixir,
we would love to encourage you to get used to referring to the documentation as
early in your Elixir learning journey as possible.

- **Practice in a real-life environment**: instead of writing code in an
artificial environment (like web-based learning platforms), your workflow with
Spirit would closely match working with any Elixir (or
[Phoenix](https://www.phoenixframework.org/)) project, giving you means of not
only practicing with the language but also getting used to the project
structure and builtin tooling.

## Usage

Make sure you have Elixir 1.17 and Erlang/OTP 27 installed. The recommended
method of installation is via [asdf](https://asdf-vm.com/).

To start using Spirit, clone this repo (or fork it first if you would like).
Then, the workflow should go as follows:

1. Read a section in the guide (e.g., [Basic
   Types](https://hexdocs.pm/elixir/basic-types.html))

2. Generate the section's exercises and tests using the Mix task `spirit.gen`
   (e.g., `mix spirit.gen basic_types`)

3. Solve the exercises in the generated module

4. Run the tests with `mix test`

5. Repeat steps 3 & 4 until all the tests pass

6. Proceed to the next guide

### Additional Tips

- You can use the Mix task `spirit.intro` to print the instructions above in
your terminal. Simply run `mix spirit.intro` when you are in the project root.

- Running `iex -S mix` in your terminal will compile your code and open an
interactive REPL that you can use for quick-and-dirty experimentation or
testing with the modules.

## Contribution

Contributions are welcome! And there is more than one way to help with the main
project or the exercise material. Please read [our contribution
guide](https://github.com/PracticeCraft/spirit/blob/main/CONTRIBUTING.md) to
learn more if you are interested.
