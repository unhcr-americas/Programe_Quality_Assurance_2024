# WARNING - Generated by {fusen} from dev/function_documentation.Rmd: do not edit by hand

# usethis::use_rmarkdown_template(
#   template_name = "report_country",
#   template_dir = NULL,
#   template_description = "Report Country",
#   template_create_dir = TRUE
# )
#' Generate a summary word report
#' 
#' @param activityInfo activityInfo link to the db
#' @param resource file with budget resource
#' @param folder folder within your project where to put the generated report. 
#'              Folder will be created if it does not exist
#' 
#' @importFrom unhcrdown pptx_slides
#' @importFrom dplyr filter select pull
#' @importFrom rmarkdown render
#' @importFrom here here
#' @importFrom countrycode countrycode
#' @importFrom stringr str_replace_all
#' 
#' @return nothing the file for the report is generated
#' 
#' @export 
#'
#' @examples
#'
#' # ProgQA::report_country(year = 2023, activityInfoTable= "cdn6y40lm87wi522",   folder = "dev/report")
report_country <- function(year = 2023, 
                      activityInfoTable,
                      folder = "Report") {
  
  ## Create the outfolder if it does not exist
  output_dir <- paste0(getwd(),"/",folder)
  if (!dir.exists(output_dir)) {dir.create(output_dir)}
  
  rmarkdown::render(
    system.file("rmarkdown/templates/report_country/skeleton/skeleton.Rmd", 
                package = "ProgQA"),
    output_file = here::here(folder, paste0('report_country-', 
                                            format(Sys.Date(),  '%d-%B-%Y'),  '.pptx') ),
    params = list(activityInfoTable  = activityInfoTable,
                  year = year)  )
}
 
