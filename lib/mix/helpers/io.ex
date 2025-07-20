defmodule Mix.Helpers.IO do
  @moduledoc """
  Helper functions for console IO messages and user prompts.
  """

  @type result :: {:ok, :fetched | :complete} | {:error, :complete | :aborted}

  @doc """
  Prints a message based on the fetch result.

  The second argument `module_list` is needed to list the modules for the user
  in the case where an invalid command or module name is provided.
  """
  @spec print_result_message(result(), list(String.t())) :: :ok
  def print_result_message(result, module_list) do
    case result do
      {:ok, :fetched} ->
        Mix.Shell.IO.info("Exercises generated. Good luck!")

      {:ok, :complete} ->
        Mix.Shell.IO.info("Nothing to generate. You have all available exercises!")

      {:error, :aborted} ->
        Mix.Shell.IO.info("Aborted")

      {:error, _} ->
        Mix.Helpers.IO.print_options(module_list)
    end
  end

  @doc """
  Prompts the user to download the next module. Returns a boolean.
  """
  @spec confirm_download?(String.t()) :: boolean()
  def confirm_download?(next_module) do
    Mix.Shell.IO.info(
      "Based on what you have saved in your project, " <>
        "the next module to fetch is:\n\n#{next_module}\n"
    )

    Mix.Shell.IO.yes?("Proceed to generate exercises for this module?")
  end

  @doc """
  Prints an error message with the available modules to fetch.
  """
  @spec print_options(list(String.t())) :: :ok
  def print_options(module_list) do
    info_block_output()

    Mix.Shell.IO.info("Available options are:\n")
    Enum.map(module_list, &Mix.Shell.IO.info/1)
    Mix.Shell.IO.info("")
  end

  @spec info_block_output() :: :ok
  defp info_block_output() do
    Mix.Shell.IO.error("** Error: invalid command")

    Mix.Shell.IO.info("""

    Spirit Gen needs to run with one string argument for the exercise to download
    Each string argument should be snake case
    Either no arg was provided or there was no match

    Example: basic_types
    """)
  end
end
