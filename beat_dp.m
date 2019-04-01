function beats = beat_dp(wavData, onsetStrength, tempoExpected, lambda)
% beat tracking by dynamic programming.
%
% Input
% - wavData : the audio signal 
% - onsetStrength : onset strength in each audio frame
% - tempoExpected : the expected tempo (in BPM)
% - lambda : tradeoff between the onset strength objective and beat regularity objective
% Output
% - beats : the estimated beat sequence (in frame number)

% step 1: Initialize variables
N = length(onsetStrength); % number of frames
t = length(wavData)/44100; % total time of wavdata
delta_h = tempoExpected/60*length(onsetStrength)/t; % compute the expected tempo (in frames)
D(1) = onsetStrength(1); % first  accumulated score
P(1) = 0; % first preceding beat
delta = -round(N):-round(1); % a range for delta
P_d = -(log(-fliplr(delta)./delta_h)).^2; % pre-compute the penalty function
% step 2: update D(n) and P(n) 
for n = 2:N
    m = n-1;
    [temp,ind] = max(D(1:m)+lambda.*P_d(n-(1:m)));
    D(n) = onsetStrength(n) + max([0 temp]); % compute accumulated score for each frame
    % update the preceding beat according to D(n)
    if D(n) == onsetStrength(n)
            P(n) = 0;
    else 
        P(n) = ind;
    end
end
% step 3: backtracking
[~,beats] = max(D);
while beats > 1
    beats = [P(beats(1)),beats];
end
beats = beats(beats>0);
end
    
    
