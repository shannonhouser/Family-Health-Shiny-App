
<!-- README.md is generated from README.Rmd. Please edit that file -->

# YoloHealthApp

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/Data-Visualization-for-Family-Health/App/workflows/R-CMD-check/badge.svg)](https://github.com/Data-Visualization-for-Family-Health/App/actions)
<!-- badges: end -->

## Installation

You can install the development version of **YoloHealthApp** from Github
using the following R commands:

``` r
if (!require(remotes)) install.packages("remotes")
remotes::install_github("Data-Visualization-for-Family-Health/YoloHealthApp")
```

You can now launch the app as follows:

``` r
YoloHealthApp::runApp()
```

### Installation on a Shiny server

**YoloHealthApp** first needs to be installed using the above
instructions. This will install all R dependencies needed for the app as
well as the necessary data.

The `site_dir` variable of the Shiny server should then be set to
`YoloHealthApp/app` under the system’s R library folder where
YoloHealthApp is located. The location of the system R library can be
found using the `.libPaths()` R command.

Alternatively, using the default value of `site_dir`, the `inst/app`
folder of this repository can be copied to `/srv/shiny-server/`. The
application at `/srv/shiny-server/app` would then be available at
<http://myserver.org:3838/app>
