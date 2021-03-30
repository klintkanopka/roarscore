#' Estimate Woodcock-Johnson Letter-Word ID scores from ROAR-LDT responses
#'
#' Estimates a variety of scores from ROAR-LDT responses. Function will only
#' consider item responses with precalibrated item parameters, but will handle
#' missing item responses gracefully. Models to estimate WJ scores depend on the
#' age of the respondent. If a `visit_age` is not supplied for an individual,
#' their WJ columns will be populated with NA. Additionally, since all
#' respondents perform near ceiling and age is factored into the WJ standard
#' score, estimation is poorly behaved for older respondents.
#'
#' @param d A dataframe with one row per respondent. Stimulii should be the
#' names of columns. To estimate WJ scores, must also include a `visit_age`
#' column where age is measured in months (can be continuously valued).
#'
#' @return A dataframe with columns for subject code, IRT-estimated ROAR-LDT
#' ability score, estimated WJ-LWID scores (raw and standard), and estimated
#' WJ-LWID percentile.


estimate_wj <- function(d){
  output <- data.frame(subj = d$subj, visit_age=d$visit_age)
  resp <- construct_response_matrix(d)
  print('estimate theta')
  output$roar <- mirt::fscores(m_irt, response.pattern=resp, append_response.patter=F)[,1]
  print('estimate wj raw')
  output$wj_lwid_raw <- predict(m_roar_wj, newdata=output)
  print('estimate wj ss')
  output$wj_lwid_ss <- predict(m_raw_ss, newdata=output)
  print('estimate wj pct')
  output$percentile <- pnorm(output$wj_lwid_ss, mean=100, sd=15)
  return(output)
}