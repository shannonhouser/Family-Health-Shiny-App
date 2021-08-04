#' @export
runApp <- function() {
  shiny::shinyAppDir(system.file("app", package = "YoloHealthApp"))
}
