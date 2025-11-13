
#' Update squba packages to align with most recent GitHub commits
#'
#' @returns a message in the console with information about which
#'          packages need to be updated based on what is currently
#'          installed
#'
#' @importFrom dplyr filter
#' @importFrom dplyr tibble
#' @importFrom dplyr union
#' @importFrom dplyr left_join
#' @importFrom purrr reduce
#' @importFrom remotes github_remote
#' @importFrom remotes remote_sha
#'
#' @export
#' @examples
#' \dontrun{
#' ## Requires that a GitHub PAT is established
#'
#' squba_update()
#' }

squba_update <- function(){

  pkg_list <- c("patientfacts",
                "patientrecordconsistency",
                "patienteventsequencing",
                "conceptsetdistribution",
                "expectedvariablespresent",
                "sourceconceptvocabularies",
                "clinicalevents.specialties",
                "sensitivityselectioncriteria",
                "cohortattrition",
                "squba.gen",
                "quantvariabledistribution")

  uptodate_list <- list()
  install_list <- list()

  for(i in pkg_list){

    pkg_rmt <- remotes::github_remote(repo = paste0('ssdqa/', i))

    uptodate_v <- remotes::remote_sha(remote = pkg_rmt)

    uptodate_list[[i]] <- dplyr::tibble('package' = i,
                                        'current_version' = uptodate_v)

    installed_v <- utils::packageDescription(pkg = i)$GithubSHA1

    install_list[[i]] <- dplyr::tibble('package' = i,
                                       'installed_version' = installed_v)
  }

  current_vs <- purrr::reduce(.x = uptodate_list,
                              .f = dplyr::union)

  installed_vs <- purrr::reduce(.x = install_list,
                                .f = dplyr::union)

  ck <- current_vs |>
    dplyr::left_join(installed_vs)|>
    dplyr::filter(current_version != installed_version)

  if(nrow(ck) == 0){
    cli::cli_inform('All SQUBA packages are up to date :)')
  }else{

    cli::cat_line(cli::pluralize(
      "The following {cli::qty(nrow(ck))}package{?s} {?is/are} out of date:"
    ))
    cli::cat_line()
    cli::cat_bullet(
      format(ck$package),
      " (",
      ck$installed_version,
      " -> ",
      ck$current_version,
      ")"
    )

    cli::cat_line()
    cli::cat_line("Start a clean R session then run:")

    pkg_str <- paste0(paste0('"ssdqa/', ck$package, '"'))
    for(k in pkg_str){
      cli::cat_line("devtools::install_github(", k, ")")
      }

    invisible()

  }

}
