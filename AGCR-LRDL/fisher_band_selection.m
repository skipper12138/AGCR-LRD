function [band_set, fisher_score] = fisher_band_selection(X, mask)

% =========================================================
% Fisher-based band selection for anomaly-background separability
%
% Input:
%   X     : [B × N]
%           hyperspectral data
%           B = number of bands
%           N = number of pixels
%
%   mask  : [1 × N] or [N × 1]
%           1 -> anomaly
%           0 -> background
%
% Output:
%   band_set     : selected top-3 band indices
%   fisher_score : Fisher score of all bands
%
% =========================================================

% ensure mask is row vector
mask = mask(:)';

[B, N] = size(X);

fisher_score = zeros(B,1);

% anomaly/background indices
idx_anomaly   = find(mask == 1);
idx_background = find(mask == 0);

for b = 1:B

    % current band
    band_data = X(b,:);

    % anomaly/background pixels
    anomaly_pixels   = band_data(idx_anomaly);
    background_pixels = band_data(idx_background);

    % mean
    mu_a = mean(anomaly_pixels);
    mu_b = mean(background_pixels);

    % std
    sigma_a = std(anomaly_pixels);
    sigma_b = std(background_pixels);

    % Fisher score
    fisher_score(b) = (mu_a - mu_b)^2 / ...
        (sigma_a^2 + sigma_b^2 + eps);

end

% descending sort
[~, idx] = sort(fisher_score, 'descend');

% select top-3 bands
band_set = idx(1:3);

% display
disp('Selected bands by Fisher score:');
disp(band_set');

end