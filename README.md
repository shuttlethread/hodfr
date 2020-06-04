# HODFR: Hands-on-dataframe Shiny adapter

[![Build Status](https://travis-ci.org/shuttlethread/hodfr.svg?branch=master)](https://travis-ci.org/shuttlethread/hodfr)

A Shiny input widget using [hodf](https://github.com/shuttlethread/hodf), allowing collection of data.frame objects with variable column widths.

![hodfr screenshot](https://raw.githubusercontent.com/shuttlethread/hodf/master/screenshot.png)

## Installation

You can install directly from GitHub:

    devtools::install_github('shuttlethread/hodfr')

## Quick start

Somewhere in the UI definition, include a hodfr element with::

    hodfr::hodfr(
        "catch_at_age",
        fields = list(type = "bins", max = 10),
        values = list(type = "year", min = 2000, max = 2010)),

...then in server.R, ``input$catch_at_age`` will be a data.frame with the
contents of the table.

``fields`` and ``values`` give a range for the data.frame rows and columns
respectively. These exactly match the values for a hodf template, see the
[template documentation](https://github.com/shuttlethread/hodf/blob/master/README.md#templates)
for more detail and examples.

You can also update the data.frame contents from R with:

    hodfr::updateHodfrInput(session, "catch_at_age", new_data)

For a complete example, look at the [demo/example.R](demo/example.R) script.

## HODFR Development

The package includes precompiled javascript sources, to make any changes to
javascript you need to re-build this as well as the package with either ``make
build``, or ``make install`` to rebuild and install the built R package.

## References

* [hodf](https://github.com/shuttlethread/hodf)
* [handsontable](https://handsontable.com/)

## Acknowledgements

Developed as part of [FarFish](https://www.farfish.eu/), which has received funding from the European Union’s Horizon 2020 research and innovation programme under grant agreement no. 727891.
