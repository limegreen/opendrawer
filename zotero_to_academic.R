
sanitizeTitle <- function(x,
                          camelCase = FALSE) {
  if (camelCase) {
    x <- gsub(" (.)",
              "\\U\\1",
              x,
              perl=TRUE);
  } else {
    x <- gsub(" ",
              "_",
              x,
              fixed=TRUE);
  }
  x <- gsub(":",
            ";",
            x,
            fixed=TRUE);
  return(x);
}

# create a function which populates the md template based on the info
# about a publication
BibEntry_to_academic_md <- function(x,
                                    hugoTypes = c("Article" = 2,
                                                  "Article in Press" = 2,
                                                  "InProceedings" = 1,
                                                  "Conference" = 1,
                                                  "Conference Paper" = 1,
                                                  "MastersThesis" = 3,
                                                  "PhdThesis" = 3,
                                                  "Manual" = 4,
                                                  "TechReport" = 4,
                                                  "Book" = 5,
                                                  "InCollection" = 6,
                                                  "InBook" = 6,
                                                  "Misc" = 0)) {
  
  ### To be able to just extract fields
  fullX <- x;
  x <- unclass(x)[[1]];
  
  res <- '+++';
  
  res <- c(res,
           paste0('title = "', gsub("\\{|}", "", x$title), '"'),
           paste0('date = "', format(attr(x, "dateobj"), "%Y-%m-%dT%H:%M:%S"), '"'),
           paste0('authors = ["', paste0(x$author, collapse='", "'), '"]'),
           paste0('publication_types = ["', hugoTypes[attr(x, 'bibtype')], '"]'));
  
    publication <-
      ifelse(is.null(x$journal),
             "",
             x$journal);
    
    if (length(x$volume)==1)
      publication <-
        paste0(publication, 
               ", (", x[["volume"]], ")");
    if (length(x$number)==1)
      publication <-
        paste0(publication,
               ", ", x[["number"]]);
    if (length(x$pages)==1)
      publication <-
        paste0(publication,
               ", _pp. ", x[["pages"]], "_");
    if (length(x$doi)==1)
      publication <-
        paste0(publication,
               ", ", paste0("https://doi.org/",
                            x[["doi"]]));
    
    res <- c(res,
             paste0('publication = "', publication, '"'),
             paste0('publication_short = "', publication, '"'),
             paste0('abstract = "', x$abstract, '"'),
             paste0('abstract_short = "', x$abstract, '"'));
    
    res <- c(res,
             paste0(c('image_preview',
                      'url_pdf',
                      'url_preprint',
                      'url_code',
                      'url_dataset',
                      'url_project',
                      'url_slides',
                      'url_video',
                      'url_poster',
                      'url_source'), ' = ""'));

    res <- c(res,
             "selected = false",
             "projects = []",
             "tags = []",
             # "math = true",
             # "highlight = true",
             # "[header]",
             # 'image = ""',
             # 'caption = ""',
             "+++",
             "");
    
    return(paste(res,
                 collapse="\n"));
    
}

### Adjusted version of
### https://www.r-bloggers.com/automatically-importing-publications-from-bibtex-to-a-hugo-academic-blog-2/

zotero_to_academic <- function(groupId,
                               outputPath,
                               language="",
                               hugoTypes = c("Article" = 2,
                                             "Article in Press" = 2,
                                             "InProceedings" = 1,
                                             "Conference" = 1,
                                             "Conference Paper" = 1,
                                             "MastersThesis" = 3,
                                             "PhdThesis" = 3,
                                             "Manual" = 4,
                                             "TechReport" = 4,
                                             "Book" = 5,
                                             "InCollection" = 6,
                                             "InBook" = 6,
                                             "Misc" = 0)) {
  
  # Import the bibtex file and convert to data.frame
  publications <-
    RefManageR::ReadZotero(group=groupId,
                           .params=list(q=""));

  fileNames <-
    lapply(publications,
           function(x) {
             return(attr(unclass(x)[[1]], "key"));
           });
  
  fileContents <-
    lapply(publications,
           BibEntry_to_academic_md);
  
  for (i in 1:length(fileNames)) {
    writeLines(fileContents[[i]],
               file.path(outputPath,
                         paste0(fileNames[i],
                                language,
                                ".md")));
  }

}

zotero_to_academic(groupId="2205665",
                   outputPath = here::here("content",
                                           "publication"),
                   language=".nl");

zotero_to_academic(groupId="2205665",
                   outputPath = here::here("content",
                                           "publication"),
                   language=".en");

#blogdown::build_site();

