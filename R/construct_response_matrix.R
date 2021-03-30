#' Construct an item response matrix from ROAR-LDT data
#'
#' Extracts a dichotomously coded response matrix to estimate ability scores
#' using pre-calibrated mirt model. This function is internally called by
#' estimate_wj() and is unlikely to be particularly useful otherwise
#'
#' @param d A dataframe with one row per respondent. Stimulii should be the
#' names of columns
#'
#' @return A matrix suitable for factor score estimation using pre-calibrated
#' mirt model


construct_response_matrix <- function(d){
  N <- nrow(d)
  column_names <- names(d)
  resp_columns <- c()
  for (i in 1:length(item_names)){
    if (item_names[i] %in% column_names){
      resp_columns <- c(resp_columns, d[[item_names[i]]])
    }else{
      resp_columns <- c(resp_columns, rep(NA, N))
    }
  }
  resp <- matrix(resp_columns, nrow=N)
  return(resp)
}
