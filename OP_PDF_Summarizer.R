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

# I combined lessons from Tesseract OCR, HTML, and Basic Url Summarizer

eng <- tesseract("eng")
pdf <- pdftools::pdf_convert("D:/R_Studio/Project_Vault/GP_AutoTextSummarizer/doc_1.pdf",
                             dpi = 600)
extract <- ocr(pdf)
cat(extract)

# exporting as .txt file to add html nodes in an HTML editor
write.table(extract, file = "extracted_text.txt", sep = "") # can i export as an
#html file instead of a txt? And can I put html tags in r script instead of 
#manually doing it? 

# summarizing the imported tagged html file 
url <- "D:/R_Studio/Project_Vault/GP_AutoTextSummarizer/extracted_text.html"
page <- read_html(url)

page %>%
  html_nodes("p") %>%
  html_text() %>%
  .[. != ""] -> text
head(text) # showed a number of \r\ and \n\, don't know what this is or how to 
#get rid of them

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

# next stage is to see if you can make it into an Rshiny application
