library(tidyverse)

# https://stackoverflow.com/a/60495352/7322615
tbl_colnames = c("user", "repo", "folder", "file", "content")
# assign(tutorial_name[2], tbl_colnames %>% purrr::map_dfc(setNames, object = list(character())))
tutorials_data <- tbl_colnames %>% purrr::map_dfc(setNames, object = list(character()))



# user = c("OpenIntroStat", "rstudio-education", "profandyfield", "profandyfield", "ProjectMOSAIC", "rstudio")
# repo = c("ims-tutorials", "dsbox", "adventr", "discovr", "ggformula", "gradethis")
# branch = c("master", "master", "master", "master", "master", "master")
# tutorial_name = c("ims_tutorials", "dsbox_tutorials", "adventr_tutorials", "discovr_tutorials", "ggformula_tutorials")
# file_extensions = "Rmd"
yaml_regex = "(?s)---\n.*?---\n"




get_tutorial_files <- function (user, repo,
                                branch = "master", file_extensions = "Rmd") {
    file_list_repo <- gizmo::github_repo_file_list(user, repo, branch)
    file_extensions_regex <- make_file_extensions_regex(file_extensions)
    file_list <- grep(paste0(file_extensions_regex),
                      file_list_repo, value = TRUE, fixed = FALSE)

    pb <- txtProgressBar(min = 0, max = length(file_list), initial = 0, style = 3)
    for (i in 1:length(file_list)) {
        setTxtProgressBar(pb, i)
        content = github_read_files(file_list[i], user, repo, branch)
        res <- stringr::str_match(content, yaml_regex)
        learnr_tutorial <- stringr::str_match(res, "learnr::tutorial")
        if (!is.na(learnr_tutorial)) {
            split_path <- stringr::str_split(file_list[i], '/')
            tutorials_data <- tutorials_data |>
                tibble::add_case(user = user,
                         repo = repo,
                         folder = split_path[[1]][length(split_path[[1]]) - 1],
                         file = split_path[[1]][length(split_path[[1]])],
                         content = content
                )
        }
    }
    close(pb)
#    tutorials_data <- get_yaml_data(tutorials_data)
    return(tutorials_data)
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

make_file_extensions_regex <- function (string)
{
    return(paste0("/.*\\.(", paste(string, collapse = "|"), ")$"))
}


#######

# assign("orca", tutorial_name_list[[i]])

# tutorial_name_list$tutorials_data2 <-  get_tutorial_files(user[2], repo[2], branch[2], file_extensions)
# dplyr::glimpse(tutorial_name_list$tutorials_data2)
# usethis::use_data(tutorial_name_list$tutorials_data2)
# file.rename(from = here::here("data/file_name.rda"), to = here::here(paste0("data/", tutorial_name[2], ".rda")))
# usethis::use_data_raw(name = tutorial_name_list[[2]])

new_tib <- get_tutorial_files(user = "profandyfield", repo = "adventr")
usethis::use_data(new_tib, overwrite = TRUE)
