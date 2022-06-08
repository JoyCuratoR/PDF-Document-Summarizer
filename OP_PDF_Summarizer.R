library(xml2)
library(rvest)
library(lexRankr)
library(textmineR)
library(tidyverse)
library(quanteda)
library(igraph)
library(here)
library(tesseract)
library(readtext)


eng <- tesseract("eng")

pdf <- pdftools::pdf_convert("D:/R_Studio/Project_Vault/GP.OP_AutoTextSummarizer/OP_PDF_Summarizer/doc_1.pdf",
                             dpi = 600)

extract <- ocr(pdf)

cat(extract)


# exporting as .html file to add html nodes in an HTML editor
write.table(extract, file = "extracted_text.html", sep = "") 

# summarizing the tagged html file 
url <- "D:/R_Studio/Project_Vault/GP.OP_AutoTextSummarizer/OP_PDF_Summarizer//extracted_text.html"
page <- read_html(url)

page %>%
  html_nodes("p") %>%
  html_text() %>%
  .[. != ""] -> text
head(text) # showed a number of \r\ and \n\

# how to replace multiple strings using nested gsub statement
cleaned <- gsub('\r\n', "",
gsub('\u0092', "'",
gsub('\u0093', "",
gsub('\u0094', "", text))))
  
head(cleaned)

# ranking for top three sentences
top3sen <- lexRank(cleaned, docId = rep(1, length(text)), n = 7, continuous = T)

# extract and display sentences from table
top3sen$sentence

# ordering sentences chronologically 
top3sen %>%
  mutate(sentenceId = as.numeric(str_remove_all(sentenceId, ".*_"))) %>%
  arrange(sentenceId) %>%
  pull(sentence)
