# library(tidyverse)
#
# split_yaml_body = function(x) {
#     i = grep('^---\\s*$', x)
#     n = length(x)
#     res = if (n < 2 || length(i) < 2 || (i[1] > 1 && !knitr:::is_blank(x[seq(i[1] - 1)]))) {
#         list(yaml = character(), body = x)
#     } else list(
#         yaml = x[i[1]:i[2]], yaml_range = i[1:2],
#         body = if (i[2] == n) character() else x[(i[2] + 1):n]
#     )
#     res$yaml_list = if ((n <- length(res$yaml)) >= 3) {
#         yaml_load(res$yaml[-c(1, n)])
#     }
#     res
# }
#
#
# available_tutorials_for_package <- function (package)
# {
#     an_error <- function(...) {
#         list(tutorials = NULL, error = paste0(...))
#     }
#     if (!file.exists(system.file(package = package))) {
#         return(an_error("No package found with name: \"", package,
#                         "\""))
#     }
#     tutorials_dir <- system.file("tutorials", package = package)
#     if (!file.exists(tutorials_dir)) {
#         return(an_error("No tutorials found for package: \"",
#                         package, "\""))
#     }
#     tutorial_folders <- list.dirs(tutorials_dir, full.names = TRUE,
#                                   recursive = FALSE)
#     names(tutorial_folders) <- basename(tutorial_folders)
#     rmd_info <- lapply(tutorial_folders, function(tut_dir) {
#         dir_rmd_files <- dir(tut_dir, pattern = "\\.Rmd$", recursive = FALSE,
#                              full.names = TRUE)
#         dir_rmd_files_length <- length(dir_rmd_files)
#         if (dir_rmd_files_length == 0) {
#             return(NULL)
#         }
#         if (dir_rmd_files_length > 1) {
#             warning("Found multiple .Rmd files in \"", package,
#                     "\"'s \"", tut_dir, "\" folder.", "  Using: ",
#                     dir_rmd_files[1])
#         }
#         yaml_front_matter <- rmarkdown::yaml_front_matter(dir_rmd_files[1])
#         data.frame(package = package, name = basename(tut_dir),
#                    title = yaml_front_matter$title %||% NA, description = yaml_front_matter$description %||%
#                        NA, private = yaml_front_matter$private %||%
#                        FALSE, package_dependencies = I(list(tutorial_dir_package_dependencies(tut_dir))),
#                    yaml_front_matter = I(list(yaml_front_matter)), stringsAsFactors = FALSE,
#                    row.names = FALSE)
#     })
#     has_no_rmd <- vapply(rmd_info, is.null, logical(1))
#     if (all(has_no_rmd)) {
#         return(an_error("No tutorial .Rmd files found for package: \"",
#                         package, "\""))
#     }
#     rmd_info <- rmd_info[!has_no_rmd]
#     tutorials <- do.call(rbind, rmd_info)
#     class(tutorials) <- c("learnr_available_tutorials", class(tutorials))
#     rownames(tutorials) <- NULL
#     list(tutorials = tutorials, error = NULL)
# }
#
# yaml_front_matter <- function (input, encoding = "UTF-8")
# {
#     parse_yaml_front_matter(read_utf8(input))
# }
#
# parse_yaml_front_matter <- function (input_lines)
# {
#     partitions <- partition_yaml_front_matter(input_lines)
#     if (!is.null(partitions$front_matter)) {
#         front_matter <- partitions$front_matter
#         if (length(front_matter) > 2) {
#             front_matter <- front_matter[2:(length(front_matter) -
#                                                 1)]
#             front_matter <- one_string(front_matter)
#             validate_front_matter(front_matter)
#             parsed_yaml <- yaml_load(front_matter)
#             if (is.list(parsed_yaml))
#                 parsed_yaml
#             else list()
#         }
#         else list()
#     }
#     else list()
# }
#
#
# yaml_regex <- "(?s)---\n(.*?)---\n"
# res <- stringr::str_match(tutorial_data$content[2], yaml_regex)
# res[,2]
#
#
# yaml_front_matter <- function(input, encoding = 'UTF-8') {
#     parse_yaml_front_matter(read_utf8(input))
# }
#
