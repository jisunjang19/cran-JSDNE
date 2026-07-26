
#' Estimating the age using A_PCR method
#'
#' A_PCR method is the principal component linear regression analysis with Southeast Asian (A_PCR) method using the Dirichlet Normal Energy (DNE).
#' The function automatically calculates the DNE on the auricular surface
#' It provides the estimated age and standard errors (SE, 9.0yrs).
#'
#' @param x the name of inputted ply file of the whole auricular surface
#' @param y the name of inputted ply file of the apex of the auricular surface
#'
#' @return estimated result gets printed to the console
#' @export

A_PCR_result<-function(x,y){
  model_A_PCR<-subset(A_PCR_Train,select=-c(Age))
  A_PCR_df<-scale(model_A_PCR)
  A_PCR_df.pca <- prcomp(A_PCR_df)
  A_PCR_pca<-A_PCR_df.pca$x[,1:2]
  A_PCR_df2<-data.frame(Age=A_PCR_Train$Age, A_PCR_pca)
  A_PCR <-lm(Age~., data = A_PCR_df2)
  whole_raw<-molaR::DNE(x,BoundaryDiscard='None')
  whole_DED<-data.frame(whole_raw$Face_Values)
  whole_DNE<-whole_DED$Dirichlet_Energy_Densities*whole_DED$Face_Areas
  df_whole_DNE<-data.frame(whole_DNE)
  apex_raw<- molaR::DNE(y,BoundaryDiscard='None')
  apex_DED<-data.frame(apex_raw$Face_Values)
  apex_DNE<-apex_DED$Dirichlet_Energy_Densities*apex_DED$Face_Areas
  df_apex_DNE<-data.frame(apex_DNE)
  MeanDNE.Apex<-mean(df_apex_DNE$apex_DNE)
  IQRDNE.Whole<-IQR(df_whole_DNE$whole_DNE)
  Fine<-df_whole_DNE[df_whole_DNE$whole_DNE<=0.0001,]
  df_fine<-data.frame(Fine)
  Proportion.DNEunder0.0001<-nrow(df_fine)/nrow(df_whole_DNE)
  est_A_PCR<-data.frame(MeanDNE.Apex,Proportion.DNEunder0.0001,Proportion.DNEover0.6,IQRDNE.Whole)
  A_PCR_Bind<-rbind(est_A_PCR,model_A_PCR)
  A_PCR_scale_Bind<-scale(A_PCR_Bind)
  A_PCR_Bind_est.pca.x <- as.matrix(A_PCR_scale_Bind) %*% A_PCR_df.pca$rotation
  A_PCR_est_df<- A_PCR_Bind_est.pca.x[1,1:2]
  A_PCR_est<-data.frame(t(A_PCR_est_df))
  A_PCR_pred<-predict(A_PCR, A_PCR_est)
  A_PCR_result<-data.frame(A_PCR_pred)
  names(A_PCR_result)<-c("Estimated age")
  A_PCR_result[,"SE"]<-c("9.0yrs")
  A_PCR_result
}

#' @examples 
#' A_PCR_output <- A_PCR_result(WholeSurface,Apex)
