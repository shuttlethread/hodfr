library(shiny)
library(jsonlite)

hodfr <- function(inputId,
                  fields,
                  values = list(list(name = "value", title = "Value")),
                  params = list(),
                  value = data.frame(),
                  js_debug = FALSE,
                  orientation = "horizontal") {
    # Convert incoming data into a proper data.frame
    shiny::registerInputHandler("hodfr.jsonframe", function(x, shinysession, name) {
        hodfr_dataframe(x)
    }, force = TRUE)

    shiny::addResourcePath(
        prefix = 'hodfr', directoryPath = system.file('www', package='hodfr'))

    shiny::tagList(
        shiny::singleton(shiny::tags$head(
            shiny::tags$script(src="hodfr/hodfr.min.js"),
            shiny::tags$link(rel="stylesheet", type="text/css", href="hodfr/hodfr.min.css"))),

        shiny::tags$div(id = inputId,
            "data-tmpl" = jsonlite::toJSON(list(
                orientation = orientation,
                fields = fields,
                values = values,
                params = params), auto_unbox = TRUE),
            "data-initial-value" = hodfr_jsonframe(value),
            class = paste(
                ifelse(isTRUE(js_debug), 'js-debug', ''),
                "hodfr")),

    "")
}


# Send a new value to Hodf
updateHodfrInput <- function(session, inputId, value = data.frame()) {
    session$sendInputMessage(inputId, list(value = hodfr_jsonframe(value)))
}


# Inverse of hodfr_dataframe
hodfr_jsonframe <- function (input_df) {
    l <- as.list(input_df)
    l[['_headings']] <- list(
        fields = colnames(input_df),
        values = rownames(input_df))

    jsonlite::toJSON(l)
}


# Convert a raw JSON FFDB data.frame into proper data.frame's
hodfr_dataframe <- function (input_val) {
    to_numeric_or_char <- function (l) {
        withCallingHandlers((function (m) {
            withRestarts(
                as.numeric(m),
                as_char_restart = as.character)
        })(l), warning = function (w) {
            invokeRestart('as_char_restart', l)
        })
    }

    # Take a FFDB data.frame structure and convert it into R
    json_df <- jsonlite::fromJSON(input_val)
    do.call(data.frame, c(list(
            row.names = json_df[['_headings']]$values,
            stringsAsFactors = FALSE
        ), lapply(json_df[json_df[['_headings']]$fields], to_numeric_or_char)))
}
