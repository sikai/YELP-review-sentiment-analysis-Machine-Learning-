clear all
close all

load maomao.mat;


idx_shrink = idx_final(:,1:size(idx_final,2)-350);

clear idx_final;
save maomao2.mat;
