function band_set=OCF_simplify(X,band_num)
%% 波段选择
% X = permute(data, [3, 1, 2]);
% Here X can be linearly normalized to [0, 1], or just keep unchanged.
% X = X(:, :);%波段数*样本数
% band_num =10;  % 选择的光谱特征的维数[5 10 15 20 25 30 35 40 45 50 55 60]
% An example to conduct TRC-OC-FDPC:
% Achieve the ranking values of band via E-FDPC algorithm
[L, ~] = size(X);
D = E_FDPC_get_D(X');
[~, bnds_rnk_FDPC] = E_FDPC(D, L);
% Construct a similarity graph
S_FG = get_graph(X);
% Get the map f in Eq. (16)
F_TRC_FDPC = get_F_TRC(S_FG, bnds_rnk_FDPC);
% Set the parameters of OCF, to indicate the objective function is TRC
para_TRC_FDPC.bnds_rnk = bnds_rnk_FDPC;
para_TRC_FDPC.F = F_TRC_FDPC;
para_TRC_FDPC.is_maximize = 0; % TRC should be minimized
para_TRC_FDPC.X = X; 
para_TRC_FDPC.operator_name = 'max'; % use 'max' operator for Eq.(8)
% Selection
band_set = ocf(para_TRC_FDPC, band_num);
sort(band_set)
% % 从data1中选择相应的波段组成一个集合
% data11=data1(:,band_set);