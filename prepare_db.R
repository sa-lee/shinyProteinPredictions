library(tidyverse)

path <- "www/Pf_101pdb/"
match_list <- str_c(path, "Pf_pdbMatch_chain.list")

# we use the pre-aligned structures from Chimera
# constructed by B.Ansell
query_files <- list.files(str_c(path, "queryAlign"), 
                          full.names = TRUE,
                          pattern = "model1_Align.pdb$")
subject_files <- list.files(str_c(path, "subjectAlign"),
                            full.names = TRUE,
                            pattern = "_Align.pdb$")
match_files <- function(., files) {
  x <- str_subset(files, .)
  if (length(x) > 0) {
    return(x)
  } else {
    return(NA_character_)
  }
}
# prepare db file
input_files <- read_tsv(match_list,
                        col_names = c("query", "subject", "chain"),
                        col_types = c("ccc")) %>%
  mutate(subject = str_c(subject, chain),
         query_file = map_chr(query, ~match_files(., files = query_files)),
         subject_file = map_chr(subject, ~match_files(., files = subject_files))) %>%
  select(-chain)

pdb_input <- input_files %>%
  filter(!is.na(subject_file)) %>%
  mutate(message = str_c(query_file, ";", subject_file))

write_rds(pdb_input, "pdb.rds")

missing_subjects <- input_files %>%
  filter(is.na(subject_file)) 

if (nrow(missing_subjects) > 0) write_tsv(missing_subjects, 
                                          "missing_reference_proteins.tsv")
