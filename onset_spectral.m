function [onsets, onsetStrength] = onset_spectral(x, win, hop, th, gamma)
% Spectral-based onset detection (spectral flux). The spectral flux calculation is based on the compressed magnitude spectrogram: 
% spectrogram_compressed = log(1 + gamma * spectrogram). This is to reduce the dynamic range of the spectrogram.
% Input
% - x : audio waveform
% - win : window function
% - hop : window hop size (in samples)
% - th : threshold to determine onsets
% - gamma : parameter for spectrogram compression
% Output
% - onsets : frame indices of the onsets
% - onsetsStrength : normalized onset strength curve, one value per frame, range in [0, 1]
W = length(win); % Window length in samples
M = 20; % Half size of the local averaging window
% step 1: STFT on the input (magnitude spectrum) 
X = STFT(x,W,1,hop,win);
Y = [zeros(fix(size(X,1)/2),1) log(1+gamma.*abs(X(1:fix(size(X,1)/2),:)))];
% step 2: Energy Derivative (Logarithmic)
Delta = diff(Y,1,2);
Delta(Delta<0) = 0;
Delta = sum(Delta,1);
% step 3: Postprocessing steps: compute local mean using a window with size
% of 41.
for n = 1:length(Delta)
    if  (n-1)+2*M+1 >  length(Delta)
        mu(n) = mean(Delta((n-1)+1:end));
    else
        mu(n) = mean(Delta((n-1)+1:(n-1)+2*M+1));
    end
end
Delta = Delta-mu; % substraction of local mean
% step 4: Half-wave recification
Delta(Delta<0) = 0;
onsetStrength = Delta./max(Delta); % normalized O(t):onset strength curve
onsets = find(onsetStrength>=th); % find onsets according to threshold
end