
#' Estimating the age using DNE_PCLR method
#'
#' DNE_PCLR method is the principal component logistic regression analysis (PCLR) method using the Dirichlet Normal Energy (DNE).
#' This method involves 2 age groups to distinguish if the specimen is over 63 or under 67.
#' The function automatically calculates the DNE on the auricular surface.
#' It provides the estimated age group and age range of the estimated age group.
#'
#' @param x the name of inputted ply file of the whole auricular surface
#' @param y the name of inputted ply file of the apex of the auricular surface
#'
#' @return estimated result gets printed to the console
#' @export

PCLR_result<-function(x,y){
  model_PCLR<-subset(PCLR_Train,select=-c(Cluster1,Age))
  PCLR_df<-scale(model_PCLR)
  PCLR_df.pca <- prcomp(PCLR_df)
  PCLR_pca<-PCLR_df.pca$x[,1:2]
  PCLR_df2<-data.frame(Cluster=PCLR_Train$Cluster1, PCLR_pca)
  PCLR<-nnet::multinom(Cluster~.,data=PCLR_df2)
  whole_raw<-molaR::DNE(x,BoundaryDiscard='None')
  whole_DED<-data.frame(whole_raw$Face_Values)
  whole_DNE<-whole_DED$Dirichlet_Energy_Densities*whole_DED$Face_Areas
  df_whole_DNE<-data.frame(whole_DNE)
  apex_raw<- molaR::DNE(y,BoundaryDiscard='None')
  apex_DED<-data.frame(apex_raw$Face_Values)
  apex_DNE<-apex_DED$Dirichlet_Energy_Densities*apex_DED$Face_Areas
  df_apex_DNE<-data.frame(apex_DNE)
  TotalDNE.TotalPolygonFaces<-mean(df_whole_DNE$whole_DNE)
  MedianDNE.Whole<-median(df_whole_DNE$whole_DNE)
  IQRDNE.Whole<-IQR(df_whole_DNE$whole_DNE)
  MeanDNE.Convex<-whole_raw$Convex_DNE/nrow(whole_DED[whole_DED$Kappa_Values>0,])
  MeanDNE.Apex<-mean(df_apex_DNE$apex_DNE)
  est_PCLR<-data.frame(TotalDNE.TotalPolygonFaces, MeanDNE.Apex, MeanDNE.Convex, MedianDNE.Whole, IQRDNE.Whole)
  PCLR_Bind<-rbind(est_PCLR, model_PCLR)
  PCLR_scale_Bind<-scale(PCLR_Bind)
  PCLR_Bind_est.pca.x <- as.matrix(PCLR_scale_Bind) %*% PCLR_df.pca$rotation
  PCLR_Bind_est<-data.frame(PCLR_Bind_est.pca.x)
  PCLR_est <- PCLR_Bind_est [1,1:2]
  PCLR_pred<-predict(PCLR,PCLR_est,type="class")
  PCLR_result<-data.frame(PCLR_pred)
  PCLR_result<-dplyr::mutate(PCLR_result, Age= dplyr::case_when(PCLR_pred == 1 ~ 'Under 67', PCLR_pred == 2 ~ 'Over 63', TRUE~'x'))
  names(PCLR_result)<-c("Estimated age group","Estimated age range")
  PCLR_result
}

#' @examples 
#' PCLR_output <- PCLR_result(WholeSurface,Apex)
