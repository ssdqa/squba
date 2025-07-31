
#' Update SQUBA packages to align with most recent GitHub commits
#'
#' @returns a message in the console with information about which
#'          packages need to be updated based on what is currently
#'          installed
#'
#' @importFrom dplyr filter
#' @importFrom dplyr select
#' @importFrom dplyr mutate
#' @importFrom dplyr tibble
#' @importFrom dplyr as_tibble
#' @importFrom dplyr union
#' @importFrom dplyr left_join
#' @importFrom dplyr rename
#' @importFrom purrr reduce
#' @importFrom stringr str_extract_all
#' @importFrom devtools package_info
#'
#' @export
#' @examples
#' \dontrun{
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

  for(i in pkg_list){

    uptodate_v <- utils::packageDescription(i)$GithubSHA1

    uptodate_list[[i]] <- dplyr::tibble('package' = i,
                                        'current_version' = uptodate_v)

  }

  current_vs <- purrr::reduce(.x = uptodate_list,
                              .f = dplyr::union)

  installed_vs <- dplyr::as_tibble(devtools::package_info()) |>
    dplyr::filter(package %in% pkg_list) |>
    dplyr::select(package, source) |>
    dplyr::mutate(source = stringr::str_extract_all(source, '\\@.*'),
                  source = gsub('@|)', "", source)) |>
    dplyr::rename('installed_version' = 'source')

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
