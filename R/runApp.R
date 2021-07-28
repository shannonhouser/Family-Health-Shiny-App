#' @export
runApp <- function() {
  i18n <- shiny.i18n::Translator$new(translation_json_path=paste0(system.file("www/translate.js", package="YoloHealthApp")))
  i18n$set_translation_language('English')

  shinyApp(ui(i18n), serverFactory(i18n))
}
