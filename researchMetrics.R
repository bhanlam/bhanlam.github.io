library(rpublons)
library(rjson)

#Get Publons review
publonsInfo<-function(orcid){
  reviews.json<-publons(base_url = "https://publons.com/wos-op/api/v2/",
                         token = "75bb003ba55db9c7a799c549d80766f534942f99",
                         "GET", "academic/review/", 
                         query = list(academic = orcid))
  
  reviews.df <- fromJSON(json_str = reviews.json)
  
  #retrieve publications info
  pubs.df<-fromJSON(json_str = publons(base_url = "https://publons.com/wos-op/api/v2/",
                        token = "75bb003ba55db9c7a799c549d80766f534942f99",
                        "GET", "academic/publication/?", 
                        query = list(academic = orcid)))
  
  #initiate publication count
  pubs.count<-length(pubs.df$results)
  
  #retrieve all publications
  while(!is.null(pubs.df$`next`)){
    pubs.df<-fromJSON(json_str = 
                        publons("GET",gsub("https://publons.com/wos-op/api/v2/","",pubs.df$`next`),
                                token = "75bb003ba55db9c7a799c549d80766f534942f99"))
    pubs.count<-pubs.count+length(pubs.df$results)
  }
  
  return(data.frame(review.count=reviews.df$count,
                    pubs.count=pubs.count))
}
