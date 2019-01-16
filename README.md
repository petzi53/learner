# How to use the `learnr` program package?

This website is my notebook for writing interactive tutorials for R wit `learnr`. But this repo is not exclusively about the relatively small packages `learnr`:

* `learnr` converts `rmarkdown` documents to interactive tutorials.
* To improve the functionality and user interface knowledge about the `botstrap` framework, CSS and Javascript are necessary. 
* `learnr` creates stand-alone Shiny apps, so it is mandatory to learn `shiny`. This is itself a huge task, not only because shiny is a complex package but also because there are many helpful add-on programs to empower the basic shiny functionality. 
* Besides knowledge about R (`learnr` is finally a package for writing tutorials to learn R!) one needs also program routines for evaluating R code submissions and auto-generate meaningful feedback messages. Then packages like `checkr` or `testwhat` will be helful. 

This following references to necessary ressources demonstrate that this is not a small taks but a major enterprise:

* Most important documents are: [learnr](https://rstudio.github.io/learnr/), [shiny](https://shiny.rstudio.com/), [rmarkdown](https://rmarkdown.rstudio.com/).
* Also important but more in details are: [R Markdown: The Definite Guide](https://bookdown.org/yihui/rmarkdown/) and [Prerendered Shiny Documents](https://rmarkdown.rstudio.com/authoring_shiny_prerendered.html).
* learnr/shiny still uses [bootstrap 3](https://getbootstrap.com/docs/3.3/), but an upgrade to [bootstrap version 4](https://getbootstrap.com/) is already under discussion.
* To use essential web technologies (HTML5, CSS and JavaScript) is the [MDN](https://developer.mozilla.org/en-US/) website the autoritative reference.
* Packages for submission correctness tests for R exercises arfe [checkr](https://github.com/dtkaplan/checkr) and [testwhat](https://datacamp.github.io/testwhat/).
