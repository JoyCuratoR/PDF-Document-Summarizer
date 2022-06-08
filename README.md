# How to summarize an academic paper in a PDF document with R
This project was built in part using [LADA's text summarization tutorial](https://slcladal.github.io/txtsum.html).

Somtimes with academic research papers, you don't know which ones are relevant to your topic. To save time, let's write a script in R that can summarize & rank the most important sentences of an academic paper in a PDF document.

# Step 1: Importing the libraries
``` r
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
```
Run all the libraries after importing them. 

# Step 2: Loading in the PDF and extracting the text 
To extract the text from the PDF, we're going to use the ```TessseractOCR``` package. Before we begin, make sure the working directory is set. 
``` r
getwd()
> "D:/R_Studio/Project_Vault/GP.OP_AutoTextSummarizer"

setwd("D:/R_Studio/Project_Vault/GP.OP_AutoTextSummarizer")
> setwd("D:/R_Studio/Project_Vault/GP.OP_AutoTextSummarizer")
```

Next, we're going to create a variable that identifies the language the PDF document is in. 
``` r
eng <- tesseract("eng")
```
To download different languages use the function ```  tesseract_download() ``` and go to the [TesseractOCR GitHub](https://github.com/tesseract-ocr/tessdata) to find out what three letters represents each language.

Then we're going to load and render our PDF using the function ``` pdf_convert ``` from the ```pdftools``` package. This will convert all the pages of the PDF into .png files. After it's done converting the PDF into .png files, we're going to extract the text. 

``` r
pdf <- pdftools::pdf_convert("D:/R_Studio/Project_Vault/GP_AutoTextSummarizer/doc_1.pdf",
                             dpi = 600)

extract <- ocr(pdf)

cat(extract) # view the text from all the .png files together
```
# Step 3: Exporting as .html file
``` r
write.table(extract, file = "extracted_text.html", sep = "")
```
We're going to open ``` extracted_text.html ``` in RStudio to clean it up a bit. This part is a bit tedious depending on how long the PDF is because the PDF has been split into (in my case 8) different .png files, and when we open up our ``` extracted_text.html ``` file, there's going to be extra text that looks like this <strong> "x""1"" </strong> and <strong> 1""2"</strong> that marks the beginning and end of each .png file. 

These extra text are what we'll have to manually go through our file to delete. After we've cleaned up our text, the next thing to do is to add some ``` <p> </p> ``` HTML tags to the start and end of the body text we want to summarize. In my case, I placed mine starting from ``` <p> A considerable amount of research in recent decades has been dedicated to stress and burn out ``` and ending at ``` There is enough conceptual
support to encourage such research. </p> ``` forgoing both the title of the paper and the end page references. 

# Step 5: Loading & Reading the cleaned HTML file
We're going to create a new variable with our cleaned ``` extracted_text.html ``` file and use the function ``` read_html ``` to read the HTML tags we added.

``` r
url <- "D:/R_Studio/Project_Vault/GP.OP_AutoTextSummarizer/OP_PDF_Summarizer//extracted_text.html"
page <- read_html(url)
```
Then we'll specify which HTML tags to recognize. 
``` r
page %>%
  html_nodes("p") %>%
  html_text() %>%
  .[. != ""] -> text

head(text) 
```
When we view our text, we'll find som ``` \r\n ``` scattered about.

We can get rid of them by using the function ``` gsub() ``` however, I found that it will just return more text we need to replace such as ``` \u0092 ```(indicates apostrophe punctuation mark), ``` \u0093 ```, ```\u0094```

So to replace them all at once, we'll use a nested ``` gsub()``` function instead. 

``` r
cleaned <- gsub('\r\n', "",
gsub('\u0092', "'", # instead of replacing with a blank space, replace with an apostrophe
gsub('\u0093', "",
gsub('\u0094', "", text))))

head(cleaned)
```
Now we should be free of any more text to clean.

# Step 6: Ranking and Summarizing
``` r
# ranking for top seven sentences
top3sen <- lexRank(cleaned, docId = rep(1, length(text)), n = 7, continuous = T) 

# extract and display sentences
top3sen$sentence 

# ordering sentences chronologically
top3sen %>%
  mutate(sentenceId = as.numeric(str_remove_all(sentenceId, ".*_"))) %>%
  arrange(sentenceId) %>%
  pull(sentence)
``` 
Voila! We should now have the top seven most significant sentences out of the entire paper.







