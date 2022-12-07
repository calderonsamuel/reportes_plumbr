library(shiny)
library(httr2)

ui <- fluidPage(
  actionButton("get_random", "Generate random number"),
  verbatimTextOutput("random"),
  downloadButton("get_report", "Generar reporte")
)

server <- function(input, output, session) {
  
  random_number <- reactive({
    request("http://127.0.0.1:5828/random") |> 
      req_perform() |> 
      resp_body_json()
  }) |> 
    bindEvent(input$get_random)
  
  output$random <- renderPrint({
    paste("Value is", random_number())
  })
  
  
  output$get_report <- downloadHandler(
    filename = function() {"reporte.pdf"},
    content = function(file) {
      
      report <- request("http://127.0.0.1:5828/reporte") |>
        req_perform() |>
        resp_body_string()
      
      file_html <- tempfile(fileext = ".html")
      file_pdf <- tools::file_path_sans_ext(file_html) |> paste0(".pdf")
      
      writeLines(report, file_html)
      pagedown::chrome_print(input = file_html, output = file)
      
    }
  )
  
}

shinyApp(ui, server)
