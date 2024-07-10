
#'
#' Estimating the age using DNE_PCQDA method
#'
#' DNE_PCQDA method is the principal component quadratic discriminant analysis (PCQDA) method using the Dirichlet Normal Energy (DNE).
#' This method involves 4 age groups.
#' The function automatically calculates the DNE on the auricular surface.
#' It provides the estimated age group and age range of the estimated age group.
#'
#' @param x the name of inputted ply file of the whole auricular surface
#' @param y the name of inputted ply file of the apex of the auricular surface
#'
#' @return estimated result gets printed to the console
#' @export

PCQDA_result<-function(x,y){
  model_PCQDA<-subset(PCQDA_Train,select=-c(Cluster2,Age))
  PCQDA_df<-scale(model_PCQDA)
  PCQDA_df.pca <- prcomp(PCQDA_df)
  PCQDA_pca<- PCQDA_df.pca$x[,1:2]
  PCQDA_df2<-data.frame(Cluster=PCQDA_Train$Cluster2, PCQDA_pca)
  PCQDA<-MASS::qda(Cluster~.,data=PCQDA_df2)
  whole_raw<-molaR::DNE(x,BoundaryDiscard='None')
  whole_DED<-data.frame(whole_raw$Face_Values)
  whole_DNE<-whole_DED$Dirichlet_Energy_Densities*whole_DED$Face_Areas
  df_whole_DNE<-data.frame(whole_DNE)
  apex_raw<- molaR::DNE(y,BoundaryDiscard='None')
  apex_DED<-data.frame(apex_raw$Face_Values)
  apex_DNE<-apex_DED$Dirichlet_Energy_Densities*apex_DED$Face_Areas
  df_apex_DNE<-data.frame(apex_DNE)
  TotalDNE.TotalPolygonFaces<-mean(df_whole_DNE$whole_DNE)
  MeanDNE.Apex<-mean(df_apex_DNE$apex_DNE)
  Fine<-df_whole_DNE[df_whole_DNE$whole_DNE<=0.0001,]
  Macro<- df_whole_DNE[df_whole_DNE$whole_DNE>0.6,]
  df_fine<-data.frame(Fine)
  df_macro<-data.frame(Macro)
  Proportion.DNEunder0.0001<-nrow(df_fine)/nrow(df_whole_DNE)
  Proportion.DNEover0.6<- nrow(df_macro)/nrow(df_whole_DNE)
  est_PCQDA<-data.frame(Proportion.DNEunder0.0001, Proportion.DNEover0.6, MeanDNE.Apex, TotalDNE.TotalPolygonFaces)
  PCQDA_Bind<-rbind(est_PCQDA,model_PCQDA)
  PCQDA_scale_Bind<-scale(PCQDA_Bind)
  PCQDA_Bind_est.pca.x <- as.matrix(PCQDA_scale_Bind) %*% PCQDA_df.pca$rotation
  PCQDA_Bind_est<-data.frame(PCQDA_Bind_est.pca.x)
  PCQDA_est <- PCQDA_Bind_est[1,1:2]
  PCQDA_pred<-predict(PCQDA, PCQDA_est,type="class")
  PCQDA_Estimated <- PCQDA_pred$class
  PCQDA_result<-data.frame(PCQDA_Estimated)
  PCQDA_result<-dplyr::mutate(PCQDA_result, Age= dplyr::case_when(PCQDA_Estimated == 1 ~ '20-44', PCQDA_Estimated == 2 ~ '31-74', PCQDA_Estimated == 3 ~ '63-93', PCQDA_Estimated == 4~ 'Over 77', TRUE~'x'))
  names(PCQDA_result)<-c("Estimated age group","Estimated age range")
  PCQDA_result
}

#' @examples 
#' PCQDA_output <- PCQDA_result(WholeSurface,Apex)