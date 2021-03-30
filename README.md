# roarscore

`R` package for estimating WJ scores from ROAR-LDT item responses. 

To install package within `R`:

```
devtools:install_github('klintkanopka/roarscore')
```

Afterward, package can be loaded like any other:

```
library(roarscore)
```

In its present form, `roarscore` provides a single function, `estimate_wj()`. Usage is simple. First construct a dataframe with the following columns:

- `subj`: A unique subject ID
- `visit_age`: The age of the subject in months at the time of testing. This need not be an integer value.
- One column per stimulus responded to, with the title of the column being the stimulus. Example columns can include `farmer`, `guess`, and `throomba`.

Estimate scores by calling `estimate_wj` on your dataframe like so:

```
output <- estimate_wj(d)
```

The output will have the following columns:

- `subj`: A unique subject ID. This is unchaged from `d`
- `visit_age`: The age of the subject in months at the time of testing. This is unchanged from `d`
- `roar`: The estimated ability of the respondent. This is estimated using a Rasch model with a fixed guessing floor of 0.5 on pilot data. Note that this estimate will only consider responses to items that are in the calibration sample. Having addtiional items or missing responses does not effect functionality, though missing responses will result in less precise estimtes.
- 'wj_lwid_raw': The estimated raw Woodcock-Johnson Letter-Word Identification score. This is currently estimated from `roar` and `visit_age` and model parameters are trained on pilot data.
- 'wj_lwid_ss': The estimated Woodcock-Johnson Letter-Word Identification standard score. This is currently estiamted from `wj_lwid_raw` and `visit_age` and model paramters are trained on pilot data.
- `percentile`: The percentile that `wj_lwid_ss` correspondes to, given that WJ standard scores are mean 100 with a standard deviation of 15.

The primary feature of this package are that the models used to estimate `roar`, `wj_lwid_raw`, and `wj_lwid_ss` can be updated without changing the functionality of the package itself. As more data becomes available, these models will be updated.
