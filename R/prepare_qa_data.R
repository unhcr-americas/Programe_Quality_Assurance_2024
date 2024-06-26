# WARNING - Generated by {fusen} from dev/function_documentation.Rmd: do not edit by hand

#' prepare_qa_data
#' 
#' Note that this function is specific to a specific DB schema -
#' the form to query as well as the columns variable name are hard coded and 
#' would need to be adjusted if the DB change
#' 
#' 
#' Implemented QA automatic Check
#'  Missing M&E Data sources
#'  Missing M&E Activity
#'  Missing Baseline
#'  Missing Baseline Numerator
#'  Missing Baseline Denominator
#'  Missing Actual
#'  Missing Actual Numerator
#'  Missing Actual Denominator
#'  Incorrect Baseline (i.e. >100%)
#'  Incorrect Actual (i.e. >100%)
#'  Baseline Higher (Lower) than Actual
#'  Significant Variance between Baseline and Actual (+/- 2*Baseline)
#'  Missing Data Limitation for Baseline
#'  Missing Data Limitation for Actual
#' 
#' 
#' Note also that the function is based on a token stored as an environment 
#' variable
#' 
#'  Credentials set up as environment variables - 
#'  
#'  # token <- "activityinfotoken.."
#'  # print(Sys.setenv(ACTIVITYINFOTOKEN = token))   
#'  # Sys.getenv("ACTIVITYINFOTOKEN")
#'  # rm(token)
#' @importFrom activityinfo activityInfoToken queryTable
#' @importFrom janitor clean_names
#' @importFrom jsonlite fromJSON

#' @param activityInfoTable activityInfo link to the db where indicators got reported
#' 
#' @return frame with the content of the activity info DB plus indicator reference
#'         and applied QA
#' 
#' @export
#' @examples
#' #prepare_qa_data(activityInfoTable= "cdn6y40lm87wi522", activityInfoPlan ="caqxz3lrqv8wig3", activityInfoCountry="cwpgxrfllcr4wv66")
#' data <- prepare_qa_data(activityInfoTable= "cdn6y40lm87wi522")
prepare_qa_data <- function(activityInfoTable ){
  
 # Connect to ActivityInfo using Token  
 activityinfo::activityInfoToken(Sys.getenv("ACTIVITYINFOTOKEN"),
                                prompt = FALSE)
  
  df  <- activityinfo::queryTable( form= activityInfoTable) |>
          janitor::clean_names()
  
  

  #Plan  <- activityinfo::queryTable(  activityInfoPlan,  "Operation" =  activityInfoPlan) |>
  # Plan  <- activityinfo::queryTable("caqxz3lrqv8wig3",  "Operation" = "clsk9d2lrqv90su4") |>
  #         janitor::clean_names()
  # #Country  <- activityinfo::queryTable(   activityInfoCountry,  
  # Country  <- activityinfo::queryTable( "cwpgxrfllcr4wv66", 
  #             "Operation" = "cri1wrylrqvanj2j.clsk9d2lrqv90su4",
  #             "Country" = "c3gm12qlrqv4kih12") |>
  #                     janitor::clean_names()
   
  # plan <- readr::read_csv(system.file("M_E_Plan1.csv", 
  #               package = "ProgQA"))
  # country <- readr::read_csv(system.file("M_E_Plan.csv", 
  #               package = "ProgQA"))
  
  #plan <- jsonlite::fromJSON(system.file("caqxz3lrqv8wig3.json", package = "ProgQA"))
  
  ### Workaround... not sure the API does not work... downloaded the JSOn file 
  ## as it is the only one with the ID
  country <- jsonlite::fromJSON(system.file("cwpgxrfllcr4wv66.json", package = "ProgQA"))|>
          janitor::clean_names()
  
  
  # names(df)
  
#    [1] "x_id"                                        
#  [2] "x_last_edit_time"                            
#  [3] "means_verification_id"                       
#  [4] "means_verification_operation_country_id"     
#  [5] "means_verification_year"                     
#  [6] "means_verification_results_level"            
#  [7] "means_verification_impact_area"              
#  [8] "means_verification_outcome_area"             
#  [9] "means_verification_indicator_code"           
# [10] "means_verification_indicator"                
# [11] "means_verification_population_type"          
# [12] "means_verification_disaggregation"           
# [13] "means_verification_data_source"              
# [14] "means_verification_additional_data_sources"  
# [15] "means_verification_data_source_comments"     
# [16] "means_verification_mn_e_activity"            
# [17] "means_verification_mn_e_activity_comments"   
# [18] "means_verification_data_collection_frequency"
# [19] "means_verification_responsibility_internal"  
# [20] "means_verification_responsibility_external"  
# [21] "means_verification_target2023"               
# [22] "means_verification_target2024"               
# [23] "means_verification_target2025"               
# [24] "means_verification_target2026"               
# [25] "means_verification_actual_num_2022"          
# [26] "means_verification_actual_den_2022"          
# [27] "means_verification_actual_2022"              
# [28] "means_verification_baseline_2023_rounded"    
# [29] "disaggregation"                              
# [30] "data_collection_frequency"                   
# [31] "me_activity_comments"                        
# [32] "additional_data_sources"                     
# [33] "data_source_comments"                        
# [34] "same_source"                                 
# [35] "data_source_revised"                         
# [36] "data_comments_revised"                       
# [37] "data_source_link"                            
# [38] "target_2023"                                 
# [39] "use_actuals"                                 
# [40] "baseline_change_comm"                        
# [41] "baseline_2023_numerator"                     
# [42] "baseline_2023_denominator"                   
# [43] "baseline_2023_percent"                       
# [44] "baseline_2023_data_limitations"              
# [45] "actual_2023_numerator"                       
# [46] "actual_2023_denominator"                     
# [47] "actual_2023_percent"                         
# [48] "actual_2023_data_limitations"                
# [49] "please_check_value_over_100"                 
# [50] "please_check_value_not_between_1_3"          
# [51] "the_actual_value_is_higher_than_the_baseline"
# [52] "the_actual_value_is_lower_than_the_baseline" 
# [53] "the_actual_value_is_higher_than_the_target"  
# [54] "the_actual_value_is_lower_than_the_target"  
  
  df1 <- df |>
    dplyr::left_join(country, by = c( "means_verification_operation_country_id" = "id" ) ) |>
    dplyr::left_join(ProgQA::mapping_indicator , by = c("means_verification_indicator_code" = "Indicator_Code") )  |>
    
    # Clean the below
#     > levels(as.factor(df1$means_verification_population_type))
# [1] "IDPs"                                        
# [2] "None"                                        
# [3] "Others of Concern"                           
# [4] "Others of Concern - Retornados/deportados"   
# [5] "Others of Concern - Riesgo de desplazamiento"
# [6] "Refugees and Asylum-seekers"                 
# [7] "Returnees"                                   
# [8] "Stateless Persons"  
    dplyr::mutate(means_verification_population_type =  dplyr::recode(means_verification_population_type,
                 "Others of Concern - Retornados/deportados" ="Others of Concern",
                 "Others of Concern - Riesgo de desplazamiento"= "Others of Concern"  )) |>
    
    
    ## let's create the actual indicator value - independetly of wether is it's a percent or not..
    dplyr::mutate( actual_2023 = dplyr::if_else( Show_As == "Percent" ,
                                                 actual_2023_percent, 
                                                 actual_2023_numerator),
                   baseline_2023 = dplyr::if_else( Show_As == "Percent" ,
                                                 baseline_2023_percent, 
                                                 baseline_2023_numerator) ) |>
    
    ## Fix - issue in ActivityInfo that fills to 0% even if numerator is NA
    dplyr::mutate( actual_2023 = dplyr::if_else( Show_As == "Percent" &
                                                       is.na(actual_2023_numerator) ,
                                                 NA, 
                                                actual_2023),
                   baseline_2023 = dplyr::if_else( Show_As == "Percent"  &
                                                       is.na(baseline_2023_numerator) ,
                                                 NA, 
                                                 baseline_2023 ) ) |>
    
    
    
      # __Comp1.__ All mandatory core impact indicators and core outcome indicators from relevant outcome areas have been selected for all relevant population groups
      dplyr::mutate(Comp1_1 = dplyr::if_else( is.na(means_verification_population_type), "Missing Population Type", NA ) #,
                    # Comp1_2 = dplyr::if_else( !( is.na(means_verification_population_type)) & 
                    #                             stringr::str_detect(means_verification_population_type ,popmatch),
                    #                           "Population Type not matching indicator", NA ) 
                    ) |>
        
        # __Comp2.__ Values for baselines, targets and actuals have been entered for all selected indicators and all relevant population groups
        dplyr::mutate(Comp2_1 = dplyr::if_else( is.na(actual_2023), "Missing Actual", NA ),
                      Comp2_2 = dplyr::if_else( is.na(baseline_2023_percent), "Missing Baseline", NA ),
                      Comp2_3 = dplyr::if_else( is.na(target_2023) & means_verification_results_level == "Outcome", "Missing Target", NA ) ) |>
        
        # __Comp3.__ Appropriate means of verification have been selected - aka data source is not empty
        dplyr::mutate(Comp3 = dplyr::if_else( is.na(means_verification_data_source), "Missing Data Source", NA ) ) |>
        
        # __Comp4.__ Data limitations have been recorded for each indicator, as applicable - when no data is provided, while that indicator was selected for that population group 
        dplyr::mutate(Comp4 = dplyr::if_else( is.na(actual_2023)   & 
                                                is.na(actual_2023_data_limitations) ,
                                              "Missing Data limitations while there's no data", NA ) ) |> 
        
        # __Acc1.__ Percentage indicators are correctly calculated, when both numerator and baseline
        dplyr::mutate(Acc1_1 = dplyr::if_else( Show_As == "Percent"   & 
                                                 is.na(actual_2023_numerator) ,
                                               "Numerator for Actual is missing", NA ),
                      Acc1_2 = dplyr::if_else( Show_As == "Percent"   & 
                                                 is.na(actual_2023_denominator) ,
                                               "Denominator for Actual is missing", NA ),
                      Acc1_3 = dplyr::if_else( Show_As == "Percent"   & 
                                                 !( is.na(actual_2023_denominator)& 
                                                      is.na(actual_2023_numerator) & 
                                                      is.na(actual_2023)) &
                                                 round(actual_2023,0) != round((actual_2023_numerator/actual_2023_denominator *100),0),
                                               "Percentage Calculation for Actual is not correct", NA ),
                      Acc1_4 = dplyr::if_else( Show_As == "Percent"   & 
                                                 is.na(baseline_2023_numerator) ,
                                               "Numerator for baseline is missing", NA ),
                      Acc1_5 = dplyr::if_else( Show_As == "Percent"   & 
                                                 is.na(baseline_2023_denominator) ,
                                               "Denominator for baseline is missing", NA ),
                      Acc1_6 = dplyr::if_else( Show_As == "Percent"   & 
                                                 !( is.na(baseline_2023_denominator)& 
                                                      is.na(baseline_2023_numerator) & 
                                                      is.na(baseline_2023_percent)) &
                                                 round(baseline_2023_percent,0) != round((baseline_2023_numerator/baseline_2023_denominator *100),0),
                                               "Percentage Calculation for baseline is not correct", NA ) ) |> 
        
        # __Acc2.__ Appropriate scales are used for text indicators. If a text unit, should be between 1 & 3
        dplyr::mutate(Acc2_1 = dplyr::if_else( Show_As == "Text"   &  
                                                 !( is.na(actual_2023)) &
                                                 !( actual_2023 %in% c(1,2,3)) ,
                                               "Appropriate scales is not used for actual text indicators", NA ),
                      Acc2_2 = dplyr::if_else( Show_As == "Text"   & 
                                                 !( is.na(baseline_2023_percent)) &
                                                 !( baseline_2023_percent %in% c(1,2,3)) ,
                                               "Appropriate scales is not used for baseline text indicators", NA ) ) |> 
        
        # __Acc3.__ Units of measurements are consistently used for baselines, actuals and targets. , if pecent between 0 & 100, if a number no denominator 
        dplyr::mutate(Acc3_1 = dplyr::if_else( Show_As == "Percent"   &  
                                                 !( is.na(actual_2023)) &
                                                 ( actual_2023 < 0 | actual_2023 >100) ,
                                               "Appropriate scales is not used for actual percent indicators", NA ),
                      Acc3_2 = dplyr::if_else( Show_As == "Percent"   & 
                                                 !( is.na(baseline_2023_percent)) &
                                                 ( baseline_2023_percent <0 | baseline_2023_percent >100) ,
                                               "Appropriate scales is not used for baseline percent indicators", NA ) ) |> 
        
        # __Acc4.__ The approach to missing values is correct, i.e., the use of “0” vs NA
        
        # __Acc5.__ The relationship between baseline and target data is logical, e.g., targets are equal to or higher than the baselines
        dplyr::mutate(Acc5_1 = dplyr::if_else( standard_direction == "more_or_equal"   &  
                                                 means_verification_results_level == "Outcome" &
                                                 !( is.na(baseline_2023_percent)) & 
                                                 !( is.na(target_2023)) &
                                                 target_2023 < baseline_2023_percent ,
                                               "Target value is below the baseline", NA ) ,
                      Acc5_2 = dplyr::if_else( standard_direction == "less_or_equal"   &  
                                                 means_verification_results_level == "Outcome" & 
                                                 !( is.na(baseline_2023_percent)) & 
                                                 !( is.na(target_2023)) &
                                                 target_2023 > baseline_2023_percent ,
                                               "Target value is above the baseline", NA ) ,
                      Acc5_3 = dplyr::if_else( standard_direction == "more_or_equal"   &  
                                                 means_verification_results_level == "Outcome" & 
                                                 !( is.na(threshold_green)) & 
                                                 !( is.na(target_2023)) &
                                                 target_2023 < threshold_green ,
                                               "Target value is below acceptable standard", NA ) ,
                      Acc5_4 = dplyr::if_else( standard_direction == "less_or_equal"   &  
                                                 means_verification_results_level == "Outcome" & 
                                                 !( is.na(threshold_green)) & 
                                                 !( is.na(target_2023)) &
                                                 target_2023 > threshold_green ,
                                               "Target value is above acceptable standard", NA )  )   |>
        
        # __Cons1.__ Detect strange issue
        dplyr::mutate(Cons1_1 = dplyr::if_else( Show_As == "Percent"    &  
                                                  means_verification_results_level == "Outcome" &
                                                  !( is.na(baseline_2023_percent)) & 
                                                  !( is.na(target_2023)) &
                                                  abs(target_2023 - baseline_2023_percent) > 40 ,
                                                "More than 40% difference between Target and Baseline", NA ) ,
                      Cons1_2 = dplyr::if_else( Show_As == "Percent"  & 
                                                  !( is.na(baseline_2023_percent)) & 
                                                  !( is.na(actual_2023)) &
                                                  abs(actual_2023 - baseline_2023_percent) > 40 ,
                                                "More than 20% difference between Actual and Baseline", NA ) #,
                      # Cons1_3 = dplyr::if_else( Show_As == "Percent"   & 
                      #                             !( is.na(baseline_2023_denominator) ) &
                      #                           #  !( is.na(asr2022)) &
                      #                             baseline_2023_denominator > asr2022 ,
                      #                           "Baseline Denominator is superior to last public release of ASR data", NA ) ,
                      # Cons1_4 = dplyr::if_else( Show_As == "Percent"   & 
                      #                             !( is.na(actual_2023_denominator) ) &
                      #                           #  !( is.na(asr2022)) &
                      #                             actual_2023_denominator > asr2022 ,
                      #                           "Actual Denominator is superior to last public release of ASR data", NA ) 
                      )   |>
        
        
        ## Summary QA
        tidyr::unite(col =  "QA_logical", 
                     all_of( c("Comp1_1",#"Comp1_2",
                               "Comp2_1","Comp2_2","Comp2_3", 
                               "Comp3",
                               "Comp4",
                               "Acc1_1","Acc1_2","Acc1_3",
                               "Acc1_4","Acc1_5","Acc1_6",
                               "Acc2_1","Acc2_2",  
                               "Acc3_1","Acc3_2", 
                               "Acc5_1","Acc5_2","Acc5_3","Acc5_4", 
                               "Cons1_1","Cons1_2" #,"Cons1_3","Cons1_4"
                               ) ), 
                     na.rm = TRUE, 
                     sep = " - ",
                     remove = FALSE)  |>
    dplyr::select(operation_mco, country, Indicator,  
                  actual_2023, baseline_2023, target_2023,
                  actual_2023_numerator,  actual_2023_percent, 
                  baseline_2023_numerator, baseline_2023_percent,

 x_id, x_last_edit_time, means_verification_id, means_verification_operation_country_id, 
  means_verification_year, means_verification_results_level, 
  means_verification_impact_area, means_verification_outcome_area, 
  means_verification_indicator_code, means_verification_indicator, 
  means_verification_population_type, means_verification_disaggregation, 
  means_verification_data_source, means_verification_additional_data_sources, 
  means_verification_data_source_comments, means_verification_mn_e_activity, 
  means_verification_mn_e_activity_comments, means_verification_data_collection_frequency, 
  means_verification_responsibility_internal, means_verification_responsibility_external, 
  means_verification_target2023, means_verification_target2024, 
  means_verification_target2025, means_verification_target2026, 
  means_verification_actual_num_2022, means_verification_actual_den_2022, 
  means_verification_actual_2022, means_verification_baseline_2023_rounded, 
  disaggregation, data_collection_frequency, me_activity_comments, 
  additional_data_sources, data_source_comments, same_source, 
  data_source_revised, data_comments_revised, data_source_link, 
   use_actuals, baseline_change_comm,  
  baseline_2023_denominator,  baseline_2023_data_limitations, 
   actual_2023_denominator,
  actual_2023_data_limitations, please_check_value_over_100, 
  please_check_value_not_between_1_3, the_actual_value_is_higher_than_the_baseline, 
  the_actual_value_is_lower_than_the_baseline, the_actual_value_is_higher_than_the_target, 
  the_actual_value_is_lower_than_the_target, last_edit_time, 
  operation, indic_short, 
  Indicator_lab2, 'Area of work', theme, subtheme, Results_Level, 
  area_id, Area, Area_id, Ind_id, Ind_seq, Show_As, 
  Reverse, threshold_red, threshold_orange, threshold_green, 
  standard_direction, survey, RAS, STA, IDP, RET, OOC, 
  all, DEN, max,  QA_logical, 
  Comp1_1, Comp2_1, Comp2_2, Comp2_3, Comp3, Comp4, 
  Acc1_1, Acc1_2, Acc1_3, Acc1_4, Acc1_5, Acc1_6, Acc2_1, 
  Acc2_2, Acc3_1, Acc3_2, Acc5_1, Acc5_2, Acc5_3, Acc5_4, 
  Cons1_1, Cons1_2)
  
  #df12 <- df1[, duplicated(colnames(df1))]
  
  # write.csv(df1, "dev/indic.csv",na = "")
  # writexl::write_xlsx( df1, path = "dev/indic.xlsx")
 #  openxlsx::write.xlsx(df1,   "dev/indic.xlsx",   firstActiveRow=2, withFilter = TRUE)
  
  return(df1)
    
}
