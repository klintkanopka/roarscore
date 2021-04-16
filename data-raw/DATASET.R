## code to prepare `DATASET` dataset goes here
library(tidyverse)
library(mirt)

d_roar <- read_csv('~/projects/roar-rt/data/metadata_all_roundeddates_newcodes (1).csv') %>%
  group_by(subj) %>%
  mutate(n = n()) %>%
  filter(n == 1) %>%
  ungroup() %>%
  filter(visit_age <= 18*12) %>%
  filter(MonthsSinceTesting < 12)

d_resp <- read_csv('~/projects/roar-rt/data/LDT_alldata_wide_v2_newcodes (1).csv') %>%
  filter(subj %in% d_roar$subj)

d_roar <- d_roar %>%
  filter(subj %in% d_resp$subj)

# to fit IRT model, create "training" data named d_resp with subj id and
# one column per item, named by item.
d_mirt <- select(d_resp, -subj)
m_irt <- mirt(d_mirt, model=1, itemtype='Rasch', guess=0.5)
item_names <- names(d_mirt)

# to predict scores, prepare a dataframe with roar ability score called d_roar
d_roar$roar <- fscores(m_irt)[,1]
m_roar_wj <- lm(wj_lwid_raw ~ roar*visit_age, data=d_roar)

# for raw -> ss conversion, create "training" data named as d_wj_ss
# requires age in months (continuously valued)
d_roar <- d_roar %>%
  select(roar, wj_lwid_ss, wj_brs, visit_age, wj_lwid_raw) %>%
  na.omit()

# add a one step loess from roar + age -> brs/ss

m_raw_ss <- lm(wj_lwid_ss ~ poly(wj_lwid_raw, 2)*poly(visit_age, 2), data=d_roar)
m_raw_brs <- lm(wj_brs ~ poly(wj_lwid_raw, 2)*poly(visit_age, 2), data=d_roar)
m_loess_brs <- loess(wj_brs ~ roar + visit_age, data=d_roar)

usethis::use_data(m_irt, m_roar_wj, m_raw_ss, m_raw_brs, m_loess_brs, item_names, internal = TRUE, overwrite = TRUE)
