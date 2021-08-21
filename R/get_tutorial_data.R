library(tidyverse)
# tutorial_name = c("adventr_tutorials", "discovr_tutorials")
#
#
#
#
#
# assign(tutorial_name[2], tbl_colnames %>% purrr::map_dfc(setNames, object = list(character())))
# tutorial_tibs = c("adventr_tib", "discovr_tib")
# assign(tutorial_name[2], tbl_colnames %>% purrr::map_dfc(setNames, object = list(character())))
# tutorial_name[2]
# tutorials_data <- tbl_colnames %>% purrr::map_dfc(setNames, object = list(character()))



# user = c("OpenIntroStat", "rstudio-education", "profandyfield", "profandyfield", "ProjectMOSAIC", "rstudio")
# repo = c("ims-tutorials", "dsbox", "adventr", "discovr", "ggformula", "gradethis")
# branch = c("master", "master", "master", "master", "master", "master")
# file_extensions = "Rmd"
yaml_regex = "(?s)---\n.*?---\n"
file_extension_regex = "^.*?.Rmd$"

split_url <- function(url) {
    file_name <- basename(url)
    last_folder <- basename(dirname(url))
    return (c(last_folder, file_name))
}
#
# get_tutorials_data <- function() {
#     for(i in 1:length(tutorial_tibs)) {
#         # tutorial_data <- basename(tutorial_urls[i])
#         assign(tutorial_tibs[i], tbl_colnames %>%
#                    purrr::map_dfc(setNames, object = list(character())))
#         print(tutorial_tibs[i])
#         # get_tutorial_files(tutorial_url, tutorial_data)
#         # assign(tutorial_url, tbl_colnames %>%
#         #            purrr::map_dfc(setNames, object = list(character())))
#     }
# }


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
            split_path <- stringr::str_split(file_list[j], '/')
            tut_tibble <- tut_tibble |>
                tibble::add_row(url = file_list[j],
                                user = user,
                                repo = repo,
                                folder = split_path[[1]][length(split_path[[1]]) - 1],
                                file = split_path[[1]][length(split_path[[1]])],
                                content = content
                )
        }
    } # end j loop
    close(pb)
#    tutorials_data <- get_yaml_data(tutorials_data)
    # dplyr::glimpse(get("tutorial_tib[i]"))
    # tutorial_tib[i] <- get("tutorial_tib[i]")
    # browser()
    # usethis::use_data(tbl_name[[1]], overwrite = TRUE)
    # eval(usethis::use_data(get("tutorial_tib[i]"), overwrite = TRUE))
    # save(tutorial_tib[i], file = tutorial_tib[i])
    return(tut_tibble)

}

# get_tutorial_files2 <- function(url) {
#     url_part <- split_url(url)
#     user = url_part[1]
#     repo = url_part[2]
#     branch = "master"
#     file_extension = "Rmd"
#     file_list_repo <- gizmo::github_repo_file_list(user, repo, branch)
#     file_list <- grep(paste0(file_extension_regex),
#                       file_list_repo, value = TRUE, fixed = FALSE)
#     print(url)
#     pb <- txtProgressBar(min = 0, max = length(file_list),
#                          initial = 0, style = 3)
#     for (i in 1:length(file_list)) {
#         setTxtProgressBar(pb, i)
#         content = github_read_files(file_list[i], user, repo, branch)
#         res <- stringr::str_match(content, yaml_regex)
#         learnr_tutorial <- stringr::str_match(res, "learnr::tutorial")
#         if (!is.na(learnr_tutorial)) {
#             split_path <- stringr::str_split(file_list[i], '/')
#             tutorials_data <- tutorials_data |>
#                 tibble::add_case(url = file_list[i],
#                                  user = user,
#                                  repo = repo,
#                                  folder = split_path[[1]][length(split_path[[1]]) - 1],
#                                  file = split_path[[1]][length(split_path[[1]])],
#                                  content = content
#                 )
#         }
#     }
#     close(pb)
#     #    tutorials_data <- get_yaml_data(tutorials_data)
#     return(tutorials_data)
# }
#



# get_tutorial_files1 <- function (user, repo,
#                                 branch = "master", file_extensions = "Rmd") {
#     file_list_repo <- gizmo::github_repo_file_list(user, repo, branch)
#     file_extensions_regex <- make_file_extensions_regex(file_extensions)
#     file_list <- grep(paste0(file_extensions_regex),
#                       file_list_repo, value = TRUE, fixed = FALSE)
#     pb <- txtProgressBar(min = 0, max = length(file_list), initial = 0, style = 3)
#     for (i in 0:length(file_list)) {
#         setTxtProgressBar(pb, i)
#         content = github_read_files(file_list[i], user, repo, branch)
#         res <- stringr::str_match(content, yaml_regex)
#         learnr_tutorial <- stringr::str_match(res, "learnr::tutorial")
#         if (!is.na(learnr_tutorial)) {
#             split_path <- stringr::str_split(file_list[i], '/')
#             tutorials_data <- tutorials_data |>
#                 tibble::add_case(user = user,
#                          repo = repo,
#                          folder = split_path[[1]][length(split_path[[1]]) - 1],
#                          file = split_path[[1]][length(split_path[[1]])],
#                          content = content
#                 )
#         }
#     }
#     close(pb)
# #    tutorials_data <- get_yaml_data(tutorials_data)
#     return(tutorials_data)
# }

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

make_file_extension_regex <- function (string)
{
    return("^.*?.Rmd$")
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

# new_tib <- get_tutorial_files("https://github.com/profandyfield/adventr")
# usethis::use_data(new_tib, overwrite = TRUE)



tutorial_urls = c("https://github.com/profandyfield/adventr",
                  "https://github.com/profandyfield/discovr")


adventr_tbl <- get_tutorial_files(tutorial_urls[1])
discovr_tbl <- get_tutorial_files(tutorial_urls[2])
usethis::use_data(adventr_tbl, discovr_tbl, overwrite = TRUE)



