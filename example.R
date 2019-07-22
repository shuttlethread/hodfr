# Example HODF application
#
# Run with Rscript example.R and visit http://localhost:9755
library(hodfr)
library(shiny)

shinyApp(
    ui = bootstrapPage(
        hodfr(
            # Name of table, used to refer to it below
            "demo_table",
            # We want columns called "species", 3 by default.
            fields = list(type = "bins", max = 3, prefix = list(name = 'species_', title = 'Species ')),
            # We want rows 2000..2010
            values = list(type = "year", min = 2000, max = 2010)),
        # Example controls to show how to use output
        plotOutput('plot'),
        verbatimTextOutput("dataframe")),

    server = function(input, output, session) {
        # Populate the demo_table with some data
        updateHodfrInput(session, "demo_table", data.frame(
            species_1 = c(10,11,12,13,14,15,16,17,18,19,10),
            species_2 = c(20,29,22,27,24,25,26,23,28,21,20),
            species_3 = c(30,31,38,33,36,35,34,37,32,39,30),
            row.names = 2000:2010))

        # Plot all columns of demo_table whenever it changes
        output$plot <- renderPlot({
            plot.ts(input$demo_table)
        })

        # Dump demo_table into text box whenever it changes
        output$dataframe <- renderPrint({
            input$demo_table
        })
    }, options = list(host = '0.0.0.0', port = 9755))
