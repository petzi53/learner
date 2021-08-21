library(tidyverse)


yaml_regex = "(?s)---\n.*?---\n"
file_extension_regex = "^.*?.Rmd$"


get_tutorial_files <- function(tut_url) {

    # https://stackoverflow.com/a/60495352/7322615
    tbl_colnames = c("url", "user", "repo", "folder", "file", "content")
    tut_tibble <- tibble(tbl_colnames %>% purrr::map_dfc(setNames, object = list(character())))

    url_part <- split_url(tut_url[1])
    user = url_part[1]
    repo = url_part[2]
    branch = "master" # try to solve it automatically
    file_extension = "Rmd"
    file_list_repo <- gizmo::github_repo_file_list(user, repo, branch)
    file_list <- grep(paste0(file_extension_regex),
                      file_list_repo, value = TRUE, fixed = FALSE)
    print(tut_url)
    pb <- txtProgressBar(min = 0, max = length(file_list),
                         initial = 0, style = 3)
    for (j in 1:length(file_list)) {
        setTxtProgressBar(pb, j)
        content = github_read_files(file_list[j], user, repo, branch)
        res <- stringr::str_match(content, yaml_regex)
        learnr_tutorial <- stringr::str_match(res, "learnr::tutorial")
        if (!is.na(learnr_tutorial)) {
            tut_tibble <- tut_tibble |>
                tibble::add_row(url = file_list[j],
                                user = user,
                                repo = repo,
                                folder = basename(dirname(file_list[j])),
                                file = basename(file_list[j]),
                                content = content
                )
        }
    } # end j loop
    close(pb)
    return(tut_tibble)

}

split_url <- function(url) {
    file_name <- basename(url)
    last_folder <- basename(dirname(url))
    return (c(last_folder, file_name))
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

github_read_files <- function(file_name,
                              user,
                              repo,
                              branch) {
    # Create the source paths
    source_path <- paste(
        "https://github.com",
        user,
        repo,
        "raw",
        branch,
        file_name,
        sep = "/"
    )
    return(readr::read_file(source_path))
}



tutorial_urls = c("https://github.com/profandyfield/adventr",
                  "https://github.com/profandyfield/discovr")


adventr_tbl <- get_tutorial_files(tutorial_urls[1])
discovr_tbl <- get_tutorial_files(tutorial_urls[2])
usethis::use_data(adventr_tbl, discovr_tbl,
                  overwrite = TRUE, compress = "xz", version = 3)



