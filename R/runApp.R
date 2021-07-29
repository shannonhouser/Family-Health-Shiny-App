#' @export
runApp <- function() {
  shiny::shinyAppDir(system.file("apps", package = "YoloHealthApp"))
}
