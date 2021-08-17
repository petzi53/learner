
user = "OpenIntroStat"
repo = "ims-tutorials"
branch = "master"
file_extensions = "Rmd"
yaml_regex = "(?s)---\n(.*?)---\n"


get_tutorial_files <- function (directory, user, repo, branch, file_extensions)
{
    tutorials_data = tibble::tibble(user = character(),
                                    repo = character(),
                                    content = character(),
                                    file_name = character(),
                                    author = character(),
                                    name = character(),
                                    title = character(),
                                    description = character()
    )

    file_list_repo <- gizmo::github_repo_file_list(user, repo, branch)
    file_extensions_regex <- make_file_extensions_regex(file_extensions)
    file_list <- grep(paste0(file_extensions_regex),
                      file_list_repo, value = TRUE, fixed = FALSE)

    pb <- txtProgressBar(min = 0, max = length(file_list), initial = 0, style = 3)
    for (i in 1:length(file_list)) {
        setTxtProgressBar(pb, i)
        content = github_read_files(file_list[i], user, repo, branch)
        res <- stringr::str_match(content, yaml_regex)
        learnr_tutorial <- stringr::str_match(res[, 2], "learnr::tutorial:")
        if (!is.na(learnr_tutorial)) {
            split_path <- stringr::str_split(file_list[i], '/')
            tutorials_data <- tutorials_data |>
                tibble::add_case(user = user,
                         repo = repo,
                         content = content,
                         file_name = split_path[[1]][length(split_path[[1]])],
                         name = split_path[[1]][length(split_path[[1]]) - 1]
                )
        }
    }
    close(pb)
    tutorials_data <- get_yaml_data(tutorials_data)
    return(tutorials_data)
}

get_yaml_data <-  function(tutorial_tib) {
    for (i in 1:nrow(tutorial_tib)) {
        res <- stringr::str_match(tutorial_tib$content[i], yaml_regex)
        yaml_list <-  yaml::read_yaml(text = res[, 2])

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

make_file_extensions_regex <- function (string)
{
    return(paste0("/.*\\.(", paste(string, collapse = "|"), ")$"))
}


#######


if (!file.exists(here::here("R/sysdata.rda"))) {
    tutorials_data <- get_tutorial_files(directory, user, repo, branch, file_extensions)
    usethis::use_data(tutorials_data, repo, internal = TRUE)
}
load(here::here("R/sysdata.rda"))


