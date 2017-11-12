library(tidyverse)

path <- "www/Pf_101pdb/"
match_list <- str_c(path, "Pf_pdbMatch_chainConcat.list")

query_files <- list.files(str_c(path, "query_db"), 
                          full.names = TRUE)
subject_files <- list.files(str_c(path, "subject_db"),
                            full.names = TRUE)
match_subject <- function(.) {
  x <- str_subset(subject_files, .)
  if (length(x) > 0) {
    return(x)
  } else {
    return(NA_character_)
  }
}
# prepare db file
input_files <- read_tsv(match_list,
                        col_names = c("query", "subject"),
                        col_types = c("cc--")) %>%
  mutate(query_file = str_subset(query_files, query),
         subject_file = map_chr(subject, match_subject)) 

pdb_input <- input_files %>%
  filter(!is.na(subject_file)) %>%
  mutate(message = str_c(query_file, ";", subject_file))

write_rds(pdb_input, "pdb.rds")

missing_subjects <- input_files %>%
  filter(is.na(subject_file)) 

if (nrow(missing_subjects) > 0) write_tsv(missing_subjects, 
                                          "missing_reference_proteins.tsv")
