## code to prepare `DATASET` dataset goes here


# to fit IRT model, create "training" data named d_resp with subj id and
# one column per item, named by item.
d_mirt <- select(d_resp, -subj)
m_irt <- mirt(d_mirt, model=1, itemtype='Rasch', guess=0.5)
item_names <- names(d_mirt)

# to predict scores, prepare a dataframe with roar ability score called d_roar
m_roar_wj <- lm(wj_lwid_raw ~ roar*visit_age, data=d_roar)

# for raw -> ss conversion, create "training" data named as d_wj_ss
# requires age in months (continuously valued)
#d_wj_ss$visit_age <- d_wj_ss$age_mo
m_raw_ss <- lm(wj_lwid_ss ~ I(wj_lwid_raw^2)*visit_age + wj_lwid_raw*visit_age, data=d_wj_ss)

usethis::use_data(m_irt, m_roar_wj, m_raw_ss, item_names, internal = TRUE, overwrite = TRUE)
