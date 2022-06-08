# PDF-Document-Summarizer
This is the Raw Documentation of my thought process while figuring out how to build a PDF document summarizer. It's not a tutorial or a coherent explanation of how I created the PDF document summarizer.

## Raw Documentation 
- My pain point to resolve is to summarize long academic pdfs
- Found a [guide](https://slcladal.github.io/txtsum.html) that summarizes online articles through searching on Google for 'build text summarizers in r'
- After searching for a guide that summarizes text in pdfs but to no avail, I thought to convert pdf to html
- Discovered a function "pdf2html" in the BrailleR package however after some testing, I couldn't make it work
- Then I looked for online conversion tools, found one that converts pdfs to html files but the finished result gave me a blank html file
- So I converted the pdf to a txt file and then to an html file so that I could load it into my R environment
- Though copying the html file name registered the R environment not being able to detect the file because of the extra 'file:///' After deleting that small bit, I was able to create a variable
- Performing this code:

      page %>%
  
        html_nodes("p") %>%
    
        html_text() %>%
    
        .[. != ""] -> text
        
     
      head(text)


Returned: character(0)


- Which means there are no objects in my R environment and the conversion to pdf -> txt -> html did not work
- Hours later I thought to put the pdf file into a corpus since that's how I was able to extract the text for a word frequency analysis in a previous project
- I was able to perform a centrality analysis after conversion to a corpus however it returned the same exact lines and I don't know where to go from there
- Found a [5 part tutorial](https://cran.r-project.org/web/packages/textmineR/index.html) for document summarizer, I don't know if it is referring to URLs or other types of files like pdfs too.
- Because of an Upwork job posting about transforming a screenshot photo into text to then be put in a spreadsheet, I looked up how to do that and came across OCR packages in R
- I learned Tesseract OCR in R which taught me how to extract text data from PDFs
- After learning that package, it gave me an idea to use Tesseract OCR to extract text data from a PDF, edit some HTML tags into the sections of text that I want to summarize, and then essentially apply the article summarizer script
- When adding HTML tags to the extacted text in the .txt file, I had to do some manual cleaning of headers and footer text
- Once I only had the main body text I wanted to summarize did I add the paragraph HTML tag to the beginning and end of the text
- Following my idea through, it returned a successful summary of my academic PDF article
