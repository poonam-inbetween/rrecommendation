# utility to install package if not present already
requirePkg <- function(x)
{
  if (!require(x,character.only = TRUE))
  {
    install.packages(x, dep=TRUE)
    if(!require(x, character.only = TRUE)) stop("Given package not found")
  }
}

