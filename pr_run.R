if (!interactive()) {
  plumber::pr("plumber.R") |> 
    plumber::pr_run(port=5828)
}
