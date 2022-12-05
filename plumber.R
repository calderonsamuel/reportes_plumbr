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

#* @apiTitle Reportes API


#* Plot a histogram
#* @serializer png
#* @get /plot
function(){
  rand <- rnorm(100)
  hist(rand)
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
#* @get /reporte
function() {
  tmpdir <- tempdir()
  R.utils::copyDirectory("inst/templates/reporte_group_user", tmpdir)
  
  tmp_input_file <- file.path(tmpdir, "template.rmd")
  
  create_reporte_group_user(input = tmp_input_file)
  
  tmp_outfile <- tools::file_path_sans_ext(tmp_input_file) |> paste0(".html")
  
  message("temp_outfile is ", tmp_outfile)

  readBin(tmp_outfile, "raw", n=file.info(tmp_outfile)$size)
}


#* Return user data
#* @param id The user id
#* @get /user
function(id) {
  db$db_get_query("SELECT * FROM users WHERE user_id = {id}", id = id)
}

