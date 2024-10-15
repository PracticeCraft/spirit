# How to contribute

Probably the most important thing we want contributers to know is that there are
many ways to contribute and they are all helpful. In no particular order, here's
what we can use a hand with: 

- Writing exercises to contribute
- Testing out exercises others have written
- Reviewing code 
- Making sure the [main repo](https://github.com/PracticeCraft/spirit) stays up to date as the language and best practices progress. 
- Making sure the [exercises repo](https://github.com/PracticeCraft/spirit-exercises) and all exercises also stay up to date
- Starting another exercises repo if you have a specific concept you want to go
deeper on in Elixir. Spirit's generator has a `--path` flag to point to
another github repo. As long as the directory structure matches, it will work
just like the main exercises repo does. 
- Getting in touch if you have ideas, advice, concerns, or just want to say
hello
- Giving us a star if you like what we are doing

## How to add exercises

The way Spirit works, is the generator will by default make a call to Github's
API and fetch the top level information for the exercises repo. The exercises
repo is just a collection of top level directories, each representing a part of
the official [Elixir docs](https://hexdocs.pm/elixir/introduction.html). If the generator was run with no arguments or there isn't a match for the argument supplied, the generator will list out directory
names in the exercises directory. If there is a match, Spirit knows how to
download just the contents of the target directory and where to put the files it
finds. 

For the purposes of developing exercises before they are merged, or in the event
that someone wants to start their own repo of exercises, the generator takes a
`--path` flag that accepts any github repo URL. We recommend forking the
exercises repo and then pointing to your fork during exercise development, then
submitting PR's to the main repo when the exercises are ready. 

Inside each directory should be 2 files. 

- An exercises file with the name `exercises.ex`
- A tests file with the name `exercises_test.exs`

When the files are downloaded and injected, they become part of your local clone
of the main repo. If you run the generator again with the same argument, one of
two things will happen. 

- If the files don't already exist, or they do exist but haven't been modified
by you, they will simply be injected. 
- If the files do exist and they have been modified since injection, you will be
prompted by the generator to confirm if you want to overwrite them. 

Once the files are injected, you can run `mix test` to see the test failures,
and then start filling in the function bodies to get the tests to pass. 

Adding your own exercises is very simple following this model, just add a
directory to the top level of the repo and add the two files with the names
mentioned above to the directory. 

## Criteria for adding exercises

When a PR is submitted we're looking for the following: 

- Each directory name should be unique and also align with the docs section it
provides exercised for.
- Each directory should contain 2 files (for now, we can discuss other
structures down the road) - an `exercises.ex` and an `exercises_test.exs` file.
Note that those names are important - the `.ex` and `.exs` extensions are how
the generator decides which is a test and which isn't, and the test file has to
have `_test.exs` or ExUnit doesn't pick it up by default. 
- Each file should be a module matching the directory and file name AFTER
INJECTION, per the convention Elixir
  uses. So the directory for `basic_types` would have the modules
`Spirit.Exercises.BasicTypes` for the exercises file, and
`Spirit.Exercises.BasicTypesTest` for the tests file. 
- The exercises file should have a `moduledoc` block explaining the docs section
  it connects with and a link to the related docs
- The exercises file should also have a series of empty functions, each with a
`@doc` block. There should be doc examples added as well, to clarify to
  users what the function is expected to return when the function works correctly. 
- The test file should include a `doctest` call, but if specific functions need
  to be excluded because they are being problematic that's fine with us. 
- Each function in the exercises file should have a related series of tests. When the user fills in the function and the function outputs the correct result, the tests should pass. Simple enough.  

Our workflow for the first of the exercises has been writing the functions and
tests in tandem inside the main repo, and then removing the function bodies when we are done. We then copy the prepared files over to the exercises repo when it's time, into the right files. From there we test the generator to make sure it all works. 




