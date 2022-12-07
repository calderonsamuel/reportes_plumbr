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

list.files("R", full.names = TRUE) |> 
  purrr::walk(source)

library(plumber)
library(promises)

future::plan(future::multisession())

#* @apiTitle Reportes API


#* Return a pdf
#* 
#* @param date_max The maximun date for the report
#* @param date_min The minimun date for the report
#* @param group_id The group ID
#* @param user_id The userID
#* 
#* @get /reporte
#* @serializer html
function(
    date_max = as.character(Sys.Date()), 
    date_min = as.character(Sys.Date() - 15), 
    group_id = NULL, 
    user_id = NULL
  ) {
  
  future_promise({
    tmpdir <- tempdir()
    R.utils::copyDirectory("inst/templates/reporte_group_user", tmpdir)
    
    tmp_input_file <- file.path(tmpdir, "template.rmd")
    
    create_reporte_group_user(
      input = tmp_input_file, 
      date_max = as.Date(date_max), 
      date_min = as.Date(date_min),
      group_id = group_id %||% Sys.getenv("TAREAS_GROUP_ID"),
      user_id = user_id %||% Sys.getenv("TAREAS_USER_ID")
    )
    
    tmp_outfile <- tools::file_path_sans_ext(tmp_input_file) |> paste0(".html")
    
    message("temp_outfile is ", tmp_outfile)
    
    readBin(tmp_outfile, "raw", n=file.info(tmp_outfile)$size)
  })
  
}




#* Random number
#* 
#* @get /random
function() {
  
  future_promise(rnorm(1), seed = NULL)
}



