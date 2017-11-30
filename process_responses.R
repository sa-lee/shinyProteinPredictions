# process responses
library(tidyverse)
fields <- c("session_id", "name", "date_time", "q1_answer", "q2_answer",
            "subject_pdb", "query_pdb")
table <- "ppp-responses.txt"

dat <- readr::read_tsv(table, col_names = fields) %>%
  mutate(name = if_else(nchar(name) == 0, NA_character_, name),
         q1_answer = if_else(q1_answer == 0, NA_integer_, q1_answer),
         subject_pdb = str_replace(basename(subject_pdb), "_Align.pdb$", ""),
         query_pdb = str_replace(basename(query_pdb), "model1_Align.pdb$", "")
  )

by_name <- dat %>%
  group_by(session_id) %>%
  filter(!is.na(name)) %>%
  select(session_id, name)

# join by name, filter any lagged response which cause duplicate records
dat_by_name <- dat %>%
  select(-name) %>%
  inner_join(by_name, by = "session_id") %>%
  distinct()

process_scores <- function(dat) {
  # filter non-response
  dat <- dat %>%
    filter(!is.na(q1_answer))
  # for each protein take the mode
  modes <- dat %>%
    count(subject_pdb, q1_answer) %>%
    group_by(subject_pdb) %>%
    filter(n == max(n)) %>%
    select(subject_pdb, mode_answer = q1_answer)
  # for each response calculate the distance between the rating and 
  # the mode of that protein
  scores <- left_join(dat, modes, by = "subject_pdb") %>%
    mutate(score = abs(mode_answer - q1_answer))
  # as a final score for each subject take the average/median distance 
  # across all proteins he/she rated (lower the better)
  scores %>% 
    group_by(name) %>% 
    # filter( n() >= 15 ) %>%
    summarise(final_score = mean(score), n = n()) %>%
    arrange(final_score)
}

# write_tsv(dat_by_name, 
#           path = paste0(format(Sys.time(), "%Y-%m-%d-%H:%M:%S"),
#                                      "_clean-responses.txt"))