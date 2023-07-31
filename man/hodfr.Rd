\name{hodfr}
\alias{hodfr}
\alias{updateHodfrInput}
\alias{renderHodfrInput}

\title{Hands-On-Data-Frame R}
\description{
  Shiny input widget for variable-size data frames, based on handsontable.
}

\usage{
hodfr(inputId,
      fields,
      values = list(list(name = "value", title = "Value")),
      params = list(),
      value = data.frame(),
      js_debug = FALSE,
      orientation = "horizontal")

updateHodfrInput(session, inputId, value = data.frame())

renderHodfrInput(session, inputId)
}

\arguments{
    \item{inputId}{The ‘input’ slot that will be used to access the data.frame.}
    \item{fields}{hodf template for data.frame columns.}
    \item{values}{hodf template for data.frame rows.}
    \item{params}{hodf parameters.}
    \item{orientation}{hodf orientation.}
    \item{js_debug}{Display debug messages in javascript console.}
    \item{session}{The \code{session} object passed to function given to \code{shinyServer}.}
    \item{value}{The initial \link{data.frame} to populate the table with}
}

\details{
\code{hodfr} adds a hodf table to a Shiny UI. \code{updateHodfrInput} replaces the content of a table at run-time.

\code{fields}, \code{values}, \code{orientation} are hodf parameters, see hodf documentation for more details:
\url{https://github.com/shuttlethread/hodf/blob/master/README.md#templates}.

\code{renderHodfrInput} forces a data table to be redrawn.
This may be required if the table is initially hidden, e.g. on a different tab. See example:
}

\examples{
## Only run examples in interactive R sessions
if (interactive()) {
    library(shiny)

    shinyApp(
      ui = bootstrapPage(hodfr(
        "demo_table",
        # We want columns called "species", 3 by default.
        fields = list(type = "bins", max = 3, prefix = list(name = 'species_', title = 'Species ')),
        # Rows repesent years, by default 2000..2001
        values = list(type = "year", min = 2000, max = 2001)),
        plotOutput('plot')),
      server = function(input, output, session) {
        # Populate the demo_table with some data
        # NB: The table will be sized to fit the data
        updateHodfrInput(session, "demo_table", data.frame(
            species_1 = c(10,11,12,13,14,15,16,17,18,19,10),
            species_2 = c(20,29,22,27,24,25,26,23,28,21,20),
            species_3 = c(30,31,38,33,36,35,34,37,32,39,30),
            row.names = 2000:2010))

        # Plot all columns of demo_table whenever it changes
        output$plot <- renderPlot({
            plot.ts(input$demo_table)
        })
      })

      shinyApp(
        ui = bootstrapPage(tabsetPanel(
          id = 'tabset',
          tabPanel('tab1_tab', hodfr('tab1_df', fields = list(
              # One year column
              list(name = 'year', title = 'Year')))),
          tabPanel('tab2_tab', hodfr('tab2_df', fields = list(
              # Year & step column
              list(name = 'year', title = 'Year'),
              list(name = 'step', title = 'Step')))),
          NULL)),
        server = function(input, output, session) {
          observeEvent(input$tabset, {
            # Re-render table for visible tab
            renderHodfrInput(session, gsub('_tab$', '_df', input$tabset))
          })
        })
}
}
