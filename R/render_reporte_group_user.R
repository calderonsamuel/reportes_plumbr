render_reporte_group_user <- function(user_data, 
                                      tasks_data, 
                                      date_min = Sys.Date() - 15,
                                      date_max = Sys.Date(),
                                      input = "inst/templates/reporte_group_user/template.rmd") {
  
  rmarkdown::render(
    input = input, 
    quiet = TRUE,
    params = list(
      user_data = user_data,
      tasks_data = tasks_data,
      date_min = as.character(date_min),
      date_max = as.character(date_max)
    )
  )
  
  rendered_file <- input |> tools::file_path_sans_ext() |> paste0(".html")
  
  if(rstudioapi::isAvailable()) rstudioapi::viewer(rendered_file)
}

reporte_group_user_data <- function(date_max = Sys.Date(), 
                                    date_min = Sys.Date() - 15, 
                                    group_id = Sys.getenv("TAREAS_GROUP_ID"), 
                                    user_id = Sys.getenv("TAREAS_USER_ID")) {
  
  db <- reportesAPI::DBManager$new()
  
  user <- db$db_get_query("SELECT * FROM users WHERE user_id = {user_id}", user_id = user_id)
  
  tasks <- db$db_get_query(
    "SELECT * FROM tasks 
    WHERE 
      group_id = {group_id} AND
      assignee = {user_id} AND
      time_last_modified >= {date_min} AND
      time_last_modified <= {date_max + 1}
    ", 
    group_id = group_id,
    user_id = user_id,
    date_min = date_min,
    date_max = date_max)
  
  list(
    user = user,
    tasks = tasks
  )
}

create_reporte_group_user <- function(date_max = Sys.Date(), 
                                      date_min = Sys.Date() - 15, 
                                      group_id = Sys.getenv("TAREAS_GROUP_ID"), 
                                      user_id = Sys.getenv("TAREAS_USER_ID")) {
  
  data <- reporte_group_user_data(date_max, date_min, group_id, user_id)
  
  render_reporte_group_user(data$user, data$tasks)
}
