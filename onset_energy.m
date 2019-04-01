function [onsets, onsetStrength] = onset_energy(x, win, hop, th)
% Energy-based onset detection
%
% Input
% - x : audio waveform
% - win : window function
% - hop : window hop size (in samples)
% - th : global threshold to determine onsets
% Output
% - onsets : frame indices of the onsets
% - onsetStrength : normalized onset strength curve, one value per frame, range in [0, 1]

W = length(win); % Window length in samples
nframes = floor((length(x)-W)/hop)+1; % number of frames based on input, W, hop sizes
E = zeros(nframes,1);
for n = 1:nframes
    % step 1: Compute signal envelope of each frame
    E(n) = sum(abs(x((n-1)*hop+1:(n-1)*hop+W) .* win).^2);
end
% step 2: Energy Derivative (Logarithmic)
Delta = diff([0; log(E)]);
% step 3: Half-wave recification
Delta(Delta<0) = 0;
% step 4: normalization O(t):onset strength curve and update onsets
onsetStrength = Delta./max(Delta);
onsets = find(onsetStrength>=th);
end % end of the function



