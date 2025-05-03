
#' Estimating the age using M_PCR method
#'
#' M_PCR method is the principal component linear regression analysis with multi-population (M_PCR) method using the Dirichlet Normal Energy (DNE).
#' The function automatically calculates the DNE on the auricular surface
#' It provides the estimated age and standard errors (SE, 10.2yrs).
#'
#' @param x the name of inputted ply file of the whole auricular surface
#' @param y the name of inputted ply file of the apex of the auricular surface
#'
#' @return estimated result gets printed to the console
#' @export

M_PCR_result<-function(x,y){
  model_M_PCR<-subset(M_PCR_Train,select=-c(Age, Population))
  M_PCR_df<-scale(model_M_PCR)
  M_PCR_df.pca <- prcomp(M_PCR_df)
  M_PCR_pca<-M_PCR_df.pca$x[,1:2]
  M_PCR_df2<-data.frame(Age=M_PCR_Train$Age, M_PCR_pca)
  M_PCR <-lm(Age~., data = M_PCR_df2)
  whole_raw<-molaR::DNE(x,BoundaryDiscard='None')
  whole_DED<-data.frame(whole_raw$Face_Values)
  whole_DNE<-whole_DED$Dirichlet_Energy_Densities*whole_DED$Face_Areas
  df_whole_DNE<-data.frame(whole_DNE)
  apex_raw<- molaR::DNE(y,BoundaryDiscard='None')
  apex_DED<-data.frame(apex_raw$Face_Values)
  apex_DNE<-apex_DED$Dirichlet_Energy_Densities*apex_DED$Face_Areas
  df_apex_DNE<-data.frame(apex_DNE)
  MeanDNE.Apex<-mean(df_apex_DNE$apex_DNE)
  MedianDNE.Apex<-median(df_apex_DNE$apex_DNE)
  MeanDNE.Convex<-whole_raw$Convex_DNE/nrow(whole_DED[whole_DED$Kappa_Values>0,])
  MeanDNE.Concave<-whole_raw$Concave_DNE/nrow(whole_DED[whole_DED$Kappa_Values<0,])
  Fine<-df_whole_DNE[df_whole_DNE$whole_DNE<=0.0001,]
  df_fine<-data.frame(Fine)
  Proportion.DNEunder0.0001<-nrow(df_fine)/nrow(df_whole_DNE)
  est_M_PCR<-data.frame(MeanDNE.Apex,MedianDNE.Apex,MeanDNE.Convex,MeanDNE.Concave,Proportion.DNEunder0.0001)
  M_PCR_Bind<-rbind(est_M_PCR,model_M_PCR)
  M_PCR_scale_Bind<-scale(M_PCR_Bind)
  M_PCR_Bind_est.pca.x <- as.matrix(M_PCR_scale_Bind) %*% M_PCR_df.pca$rotation
  M_PCR_est_df<- M_PCR_Bind_est.pca.x[1,1:2]
  M_PCR_est<-data.frame(t(M_PCR_est_df))
  M_PCR_pred<-predict(M_PCR, M_PCR_est)
  M_PCR_result<-data.frame(M_PCR_pred)
  names(M_PCR_result)<-c("Estimated age")
  M_PCR_result[,"SE"]<-c("10.2yrs")
  M_PCR_result
}

#' @examples 
#' M_PCR_output <- M_PCR_result(WholeSurface,Apex)
