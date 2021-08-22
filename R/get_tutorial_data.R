library(tidyverse)


yaml_regex = "(?s)---\n.*?---\n"

get_tutorial_files <- function(tut_url) {

    # https://stackoverflow.com/a/60495352/7322615
    tbl_colnames = c("url", "owner", "repo", "updated", "branch",
                     "license", "homepage", "description", "folder",
                     "file", "content", "package")
    tut_tibble <- tibble(tbl_colnames %>%
                 purrr::map_dfc(setNames, object = list(character())))
    url_parts <- split_url(tut_url)
    owner = url_parts$folder_name
    repo = url_parts$file_name
    api_info <- (github_api_repo(owner, repo))
    branch = api_info[["default_branch"]]
    file_list <-  github_file_exts(owner, repo, "Rmd")

    print(tut_url)
    pb <- txtProgressBar(min = 0, max = length(file_list),
                         initial = 0, style = 3)
    for (j in 1:length(file_list)) {
        setTxtProgressBar(pb, j)
        if (repo == "primers" & j == 108) {next} # error in file name!
        content = github_read_files(file_list[j], owner, repo, branch)
        res <- stringr::str_match(content, yaml_regex)
        learnr_tutorial <- stringr::str_match(res, "learnr::tutorial")
        if (!is.na(learnr_tutorial)) {
            if (stringr::str_detect(file_list[j], "inst/tutorials/")) {
                is_package = "TRUE"
            } else {
                is_package = "FALSE"
            }
            tut_tibble <- tut_tibble |>
                tibble::add_row(url = file_list[j],
                                package = is_package,
                                owner = owner,
                                repo = repo,
                                branch = branch,
                                folder = basename(dirname(file_list[j])),
                                file = basename(file_list[j]),
                                content = content,
                                updated = api_info[["updated_at"]],
                                license = api_info[["license"]][["name"]],
                                homepage = api_info[["homepage"]],
                                description = api_info[["description"]]
                )
        }
    } # end j loop
    close(pb)
    return(tut_tibble)

}

split_url <- function(url) {
    file_name <- basename(url)
    folder_name <- basename(dirname(url))
    return (url_list = list(folder_name = folder_name, file_name = file_name))
}

github_value <-  function(owner, repo, returnValue) {
    api_info <- github_api_repo(owner, repo)
    return(api_info[[returnValue]])
}


github_api_repo <- function(owner, repo) {
    api_info <- gh::gh("/repos/{owner}/{repo}", owner = owner, repo = repo)
    return(api_info)
}

github_file_exts <-  function(owner, repo, file_ext) {
    file_extension_regex = paste0("^.*?.", file_ext, "$")
    file_list_repo <- gh::gh("/repos/{owner}/{repo}/git/trees/master",
                                owner = owner,
                                repo = repo,
                                recursive = "true")
    file_list_vector <- purrr::map(file_list_repo[["tree"]], "path")
    file_list <- grep(file_extension_regex, file_list_vector,
                      value = TRUE, fixed = FALSE)
    return(file_list)
}

github_read_files <- function(file_name,
                              owner,
                              repo,
                              branch) {
    # Create the source paths
    source_path <- paste(
        "https://github.com",
        owner,
        repo,
        "raw",
        branch,
        file_name,
        sep = "/"
    )
    return(readr::read_file(source_path))
}

get_yaml_data <-  function(tutorial_tib) {
    for (i in 1:nrow(tutorial_tib)) {
        res <- stringr::str_match(tutorial_tib$content[i], yaml_regex)
        yaml_list <-  yaml::read_yaml(text = res)

        if (!is.null(yaml_list$author)) {
            tutorial_tib$author[i] = yaml_list$author
        }
        if (!is.null(yaml_list$title)) {
            tutorial_tib$title[i] = yaml_list$title
        }
        if (!is.null(yaml_list$description)) {
            tutorial_tib$description[i] = yaml_list$description
        }
    }
    return(tutorial_tib)
}

################################################################################

tutorial_urls = c("https://github.com/profandyfield/adventr",
                  "https://github.com/profandyfield/discovr",
                  "https://github.com/allisonhorst/dplyr-learnr",
                  "https://github.com/rstudio-education/dsbox",
                  "https://github.com/ProjectMOSAIC/ggformula",
                  "https://github.com/rstudio/gradethis",
                  "https://github.com/OpenIntroStat/ims-tutorials",
                  "https://github.com/rstudio/learnr",
                  "https://github.com/tidymodels/learntidymodels",
                  "https://github.com/rstudio/parsons",
                  "https://github.com/demar01/penguinsbox",
                  "https://github.com/rstudio-education/primers",
                  "https://github.com/rstudio/sortable",
                  "https://github.com/dtkaplan/submitr")


# adventr <- get_tutorial_files(tutorial_urls[1])
# discovr <- get_tutorial_files(tutorial_urls[2])
# dplyr_learnr <- get_tutorial_files(tutorial_urls[3])

dsbox <- get_tutorial_files(tutorial_urls[4])
ggformula <- get_tutorial_files(tutorial_urls[5])
gradethis <- get_tutorial_files(tutorial_urls[6])

usethis::use_data(dsbox, ggformula, gradethis,
                  overwrite = TRUE, compress = "xz", version = 3)

ims_tutorials <- get_tutorial_files(tutorial_urls[7])
learnr <- get_tutorial_files(tutorial_urls[8])
learntidymodels <- get_tutorial_files(tutorial_urls[9])

usethis::use_data(ims_tutorials, learnr, learntidymodels,
                  overwrite = TRUE, compress = "xz", version = 3)

parsons <- get_tutorial_files(tutorial_urls[10])
penguinsbox <- get_tutorial_files(tutorial_urls[11])
# primers <- get_tutorial_files(tutorial_urls[12])
sortable <- get_tutorial_files(tutorial_urls[13])
submitr <- get_tutorial_files(tutorial_urls[14])

usethis::use_data(parsons, penguinsbox, sortable, submitr,
                  overwrite = TRUE, compress = "xz", version = 3)
# usethis::use_data(dplyr_learnr,
#                   overwrite = TRUE, compress = "xz", version = 3)
