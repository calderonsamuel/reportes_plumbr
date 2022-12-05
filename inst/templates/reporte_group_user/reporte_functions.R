reporte_flextable <- function(dat) {
  flextable::flextable(dat) |> 
    flextable::set_table_properties("autofit") |> 
    flextable::font(part = "all", fontname = "Calibri") |> 
    flextable::fontsize(size = 10, part = "all")
}

theme_reporte <- function() {
  ggplot2::theme_minimal() +
    ggplot2::theme(
      panel.grid.major.y = ggplot2::element_line(linewidth = 1, colour = "grey75"),
      panel.grid.minor.y = ggplot2::element_line(linetype = 2, colour = "grey85"),
      panel.grid.major.x = ggplot2::element_blank()
    )
}

get_tasks_period <- function(AppData, group_id, user_id, date_min, date_max) {
  AppData$db_get_query(
    "SELECT * FROM tasks 
    WHERE 
      group_id = {group_id} AND
      assignee = {user_id} AND
      time_last_modified >= {date_min} AND
      time_last_modified <= {date_max + 1}
    ", 
    group_id = group_id,
    user_id = user_id)
}
