
#' Estimating the age using PCR method
#'
#' DNE_PCR method is the principal component linear regression analysis (PCR) method using the Dirichlet Normal Energy (DNE).
#' The function automatically calculates the DNE on the auricular surface
#' It provides the estimated age and standard errors (SE).
#'
#' @param x the name of inputted ply file of the whole auricular surface
#' @param y the name of inputted ply file of the apex of the auricular surface
#'
#' @return estimated result gets printed to the console
#' @export

PCR_result<-function(x,y){
  set.seed(2)
  model_PCR<-subset(data_PCR,select=-c(Age))
  PCR_df<-scale(model_PCR)
  PCR_df.pca <- prcomp(PCR_df)
  PCR_df2<-data.frame(Age=data_PCR$Age, PCR_df.pca$x)
  PCR <-lm(Age~., data = PCR_df2)
  whole_raw<-molaR::DNE(x,BoundaryDiscard='None')
  whole_DED<-data.frame(whole_raw$Face_Values)
  whole_DNE<-whole_DED$Dirichlet_Energy_Densities*whole_DED$Face_Areas
  df_whole_DNE<-data.frame(whole_DNE)
  apex_raw<- molaR::DNE(y,BoundaryDiscard='None')
  apex_DED<-data.frame(apex_raw$Face_Values)
  apex_DNE<-apex_DED$Dirichlet_Energy_Densities*apex_DED$Face_Areas
  df_apex_DNE<-data.frame(apex_DNE)
  MedianDNE.Apex<-median(df_apex_DNE$apex_DNE)
  IQRDNE.Apex<-IQR(df_apex_DNE$apex_DNE)
  MeanDNE.Convex<-whole_raw$Convex_DNE/nrow(whole_DED[whole_DED$Kappa_Values>0,])
  MeanDNE.Concave<-whole_raw$Concave_DNE/nrow(whole_DED[whole_DED$Kappa_Values<0,])
  Fine<-df_whole_DNE[df_whole_DNE$whole_DNE<=0.0001,]
  Macro<- df_whole_DNE[df_whole_DNE$whole_DNE>0.6,]
  df_fine<-data.frame(Fine)
  df_macro<-data.frame(Macro)
  Proportion.DNEunder0.0001<-nrow(df_fine)/nrow(df_whole_DNE)
  Proportion.DNEover0.6<- nrow(df_macro)/nrow(df_whole_DNE)
  MedianDNE.Whole<-median(df_whole_DNE$whole_DNE)
  est_PCR<-data.frame(MedianDNE.Apex, IQRDNE.Apex, MeanDNE.Convex, MeanDNE.Concave, Proportion.DNEunder0.0001, Proportion.DNEover0.6, MedianDNE.Whole)
  PCR_Bind<-rbind(est_PCR,model_PCR)
  PCR_scale_Bind<-scale(PCR_Bind)
  PCR_Bind_est.pca.x <- as.matrix(PCR_scale_Bind) %*% PCR_df.pca$rotation
  PCR_Bind_est<-data.frame(PCR_Bind_est.pca.x)
  PCR_est <- PCR_Bind_est[-540:-2,]
  PCR_pred<-predict(PCR, PCR_est)
  PCR_result<-data.frame(PCR_pred)
  names(PCR_result)<-c("Estimated age")
  PCR_result[,"SE"]<-c("12.4yrs")
  PCR_result
}


