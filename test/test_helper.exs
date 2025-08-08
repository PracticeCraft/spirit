ExUnit.start()

ExUnit.after_suite(fn suite ->
  if suite.failures === 0 do
    IO.puts("\nAll tests pass. Great work!")
    IO.puts("Running Mix task spirit.gen to get the next exercise...")
    Mix.Task.run("spirit.gen")
  end
end)
