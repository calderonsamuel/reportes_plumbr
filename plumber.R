#
# This is a Plumber API. In RStudio 1.2 or newer you can run the API by
# clicking the 'Run API' button above.
#
# In RStudio 1.1 or older, see the Plumber documentation for details
# on running the API.
#
# Find out more about building APIs with Plumber here:
#
#    https://www.rplumber.io/
#

library(plumber)

#* @apiTitle Plumber Example API

#* Echo back the input
#* @param msg The message to echo
#* @get /echo
function(msg=""){
  list(msg = paste0("The message is: '", msg, "'"))
}

#* Plot a histogram
#* @serializer png
#* @get /plot
function(){
  rand <- rnorm(100)
  hist(rand)
}

#* Plot a histogram
#* @serializer pdf
#* @get /plot2
function(){
  plot <- data.frame(x = rnorm(100)) |>
    ggplot2::ggplot(ggplot2::aes(x)) +
    ggplot2::geom_histogram()
  
  print(plot)
  # 
  # tmp_pdf <- tempfile(fileext = ".pdf")
  # 
  # ggplot2::ggsave(tmp_pdf, plot)
  # 
  # # tmp_pdf
  
  # readBin(tmp_pdf, "raw", n=file.info(tmp_pdf)$size)
  
  # htmltools::tags$h5("HTML text")
}

#* Return the sum of two numbers
#* @param a The first number to add
#* @param b The second number to add
#* @post /sum
function(a, b){
  as.numeric(a) + as.numeric(b)
}

#* Return a pdf
#* @serializer html
#* @get /pdf
function() {
  tmpdir <- tempdir()
  tmp_qmd <- tempfile(tmpdir = tmpdir, fileext = ".rmd")
  
  # tmp_qmd <- "inst/templates/test2.rmd"
  # tmp_pdf <- paste0(ids::random_id(), ".html")
  
  file.copy(from = "inst/templates/test2.rmd",to = tmp_qmd)
  rmarkdown::render(tmp_qmd)
  
  tmp_outfile <- tools::file_path_sans_ext(tmp_qmd) |> paste0(".html")
  
  message("temp_outfile is ", tmp_outfile)

  readBin(tmp_outfile, "raw", n=file.info(tmp_outfile)$size)
}

