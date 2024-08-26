defmodule TerminalHelpers do
  @moduledoc """
  Helper functions for printing strings to the terminal
  """
  import IO.ANSI

  @style_map %{
    bold: &bright/0,
    fg_cyan: &cyan/0,
    faint: &faint/0
  }

  def style(str, styles) do
    styled_str =
      Enum.reduce(styles, str, fn style, s ->
        ansi_fn = @style_map[style] || raise("unrecognized style keyword #{style}")
        ansi_fn.() <> s
      end)

    styled_str <> IO.ANSI.reset()
  end

  def prompt(str) do
    input = IO.gets(blink_slow() <> str)
    input
  end
end
