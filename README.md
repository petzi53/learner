# How to use the `learnr` program package?

## Content of this repo

This website is my notebook for writing interactive tutorials for R with `learnr`. But this repo is not exclusively about the relatively small packages `learnr`:

* `learnr` converts `R Markdown` documents to interactive tutorials.
* To improve the functionality and user interface knowledge about the `bootstrap` framework, CSS and Javascript are necessary. 
* `learnr` creates stand-alone Shiny apps, so it is essential to learn `shiny` too. Learning Shiny is a heavy task because Shiny is not only a complex package but there are also many helpful add-on programs to empower Shiny's functionality. [Mastering Shiny](https://mastering-shiny.org/) – a new book by Hadley Wickham – is the leading resource. 
* Besides knowledge about R (`learnr` is a package for writing tutorials to learn R!), one also needs program routines for evaluating R code submissions and auto-generate meaningful feedback messages. Then packages like `gradethis` or `submitr` will be helpful. 

## Some references

The following paragraph references some resources demonstrating that master the `learnr` packages is not a small task but a significant enterprise:

* Most important documents are: [learnr](https://rstudio.github.io/learnr/), [shiny](https://shiny.rstudio.com/), [rmarkdown](https://rmarkdown.rstudio.com/).
* Also important but more in detail are: [R Markdown: The Definite Guide](https://bookdown.org/yihui/rmarkdown/) and [Prerendered Shiny Documents](https://rmarkdown.rstudio.com/authoring_shiny_prerendered.html).
* Shiny and R Markdown default to Bootstrap 3 and will continue to avoid breaking legacy code. But with [bslib](https://rstudio.github.io/bslib/) – an R package providing tools for customizing Bootstrap themes directly from R supports custom theming and [upgrading Bootstrap 3 to 4 and beyond](https://rstudio.github.io/bslib/articles/bslib.html#versions).
* To use essential web technologies (HTML5, CSS and JavaScript) is the [MDN](https://developer.mozilla.org/en-US/) website the authoritative reference.
* Packages for submission correctness tests for R exercises are [checkr](https://github.com/dtkaplan/checkr) and [testwhat](https://datacamp.github.io/testwhat/). I think these packages are, in the meanwhile, outdated! Instead, check for the RStudio package [gradethis](https://pkgs.rstudio.com/gradethis/index.html), the complementary package to `learnr`. Another approach to test submissions comes from Daniel Kaplan with the [submitr](https://github.com/dtkaplan/submitr/) package. Maybe I should also look into the [learnrhash](https://github.com/rundel/learnrhash) and  [ghclass](https://rundel.github.io/ghclass/) packages for [administering online courses](https://datasciencebox.org/version-control.html#ghclass).
* Very useful are also the example GitHub sites like [learnr examples](https://rstudio.github.io/learnr/examples.html) and the [Shiny gallery](https://shiny.rstudio.com/gallery/). There exist at the near bottom of [Shiny Use Cases](https://www.rstudio.com/products/shiny/shiny-user-showcase/) even a section on Shiny Apps for Teaching.


## Interactive Tutorials with `learnr`

In the meanwhile, there are many full-fledged tutorials written with `learnr`:

- [RStudio Primers](https://rstudio.cloud/learn/primers)
- [Data Science in a Box Interactive Tutorials](https://datasciencebox.org/interactive-tutorials.html)
- [Introduction to Modern Statistics Tutorial](https://openintrostat.github.io/ims-tutorials/)
- Two packages [adventr](https://github.com/profandyfield/adventr) and [discovr](https://github.com/profandyfield/discovr) with R Tutorials by Andy Field accompanying his books. 

## Installation

