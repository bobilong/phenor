#' Photothermal Time model as defined in
#' Basler et al. 2016 (Agr. For. Meteorlogy)
#' with a sigmoidal temperature response (Kramer 1994)
#'
#' @param data: a nested list of data
#' @param par: a vector of parameter values, this is functions specific
#' @keywords phenology, model, sequential
#' @export
#' @examples
#'
#' \dontrun{
#' estimate = PTTs(data = data, par = par)
#'}

PTTs = function(par, data){

  # exit the routine as some parameters are missing
  if (length(par) != 4){
    stop("model parameter(s) out of range (too many, too few)")
  }

  # extract the parameter values from the
  # par argument for readability
  t0 = par[1]
  b = par[2]
  c = par[3]
  F_crit = par[4]

  # create forcing/chilling rate vector
  # forcing
  Rf = 1 / (1 + exp(-b * (data$Ti - c)))
  Rf = (data$Li / 24) * Rf
  Rf[1:t0,] = 0

  # DOY of budburst criterium
  doy = apply(Rf,2, function(xt){
    doy = data$doy[which(cumsum(xt) >= F_crit)[1]]
    doy[is.na(doy)] = 9999
    return(doy)
  })
  return(doy)
}
