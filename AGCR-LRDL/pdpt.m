
tmp=tmp_GCRLRDL;
[m,n]=size(tmp);
mode_eq=1;
M=m*n;
det_map=reshape(tmp,M,1);
GT=reshape(mask_GCRLRDL,M,1);
[tau]=plot_3DROC1(det_map,GT,mode_eq);
tau_GCRLRDL=tau;
save ('E:\study\yyfprogram\matlab\GCR-LRDL\Hohai\GCRLRDL', 'tau_GCRLRDL');
tmp=wt;