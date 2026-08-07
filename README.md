# yieldcurve
An R-based template for modelling the spot and par yield curves of a selected bond class.

## Spot Yield Curve
A zero-coupon continuously compounded yield curve is fitted following the methodology presented in Svensson (1994). The parsimonious (parametric) model of spot rates is given as

   ```math
   r(t)=\beta_0
   +\beta_1\left(\frac{1-e^{-t/\lambda_1}}{t/\lambda_1}\right)
   +\beta_2\left(\frac{1-e^{-t/\lambda_1}}{t/\lambda_1}-e^{-t/\lambda_1}\right)
   +\beta_3\left(\frac{1-e^{-t/\lambda_2}}{t/\lambda_2}-e^{-t/\lambda_2}\right),
   ```                                           

the first two parameters  $β_0$, $β_1$ representing the level and the slope of the desired yield curve, $β_2$, λ_1$ being the first curvature factor (the magnitude of the first “hump” in the curve) and its location (typically the short-to-medium maturities), respectively, and the parameters $β_3$, $λ_2$ corresponding to the second curvature factor and its location (longer maturities due to the amplified convexity effect), respectively.

The R package utilized to conduct the procedure is *termstrc*, described in the manual ([Package ‘termstrc’](https://web.archive.org/web/20150919123640/https://cran.r-project.org/web/packages/termstrc/termstrc.pdf)) and the companion paper ([Zero-Coupon Yield Curve Estimation with the Package termstrc](https://www.jstatsoft.org/article/view/v036i01)).

## Par Yield Curve
A zero-coupon yield curve is converted to a par curve via the package *yieldcurves*. The compounding convention selected is annual, mirroring the Czech government bond standard.

## References
The original paper by Svensson, presenting the methodology:

    Svensson, L. E. (1994). Estimating and interpreting forward interest rates: Sweden 1992-1994. IMF Working Paper WP/94/114. 
    https://larseosvensson.se/files/papers/estimating-and-interpreting-forward-rates-sweden-1992-1994-IMFwp94-114.pdf


 
