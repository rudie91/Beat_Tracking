function y = synth_onset(x, frameLen, frameHop, onsets)
% Synthesize each onset as a 1-frame long white noise signal, and add it to
% the original audio signal.
% Input
% - x : input audio waveform
% - frameLen : frame length (in samples)
% - frameHop : frame hop size (in samples)
% - onsets : detected onsets (in frames)
% Output
% - y : output audio waveform which is the mixture of x and
% synthesized onset impulses.
noise = wgn(frameLen,1,0); % white noise  (length of a frame)
nframes = floor((length(x)-frameLen)/frameHop)+1; % # of frames
i = 1; % index of "onsets" vector
for n = 1:nframes
    if n <= onsets(end) && n == onsets(i)  % when the corresponding frame index has onset => add noise
        y((n-1)*frameHop+1:(n-1)*frameHop+frameLen) = x((n-1)*frameHop+1:(n-1)*frameHop+frameLen) + noise; % corresponding frame will have the noise
        i = i+1;
    else % otherwise, just copy the original wave data
        y((n-1)*frameHop+1:(n-1)*frameHop+frameLen) = x((n-1)*frameHop+1:(n-1)*frameHop+frameLen);
    end
end
y = y./max(abs(y)); % normalization
end % end of the function
    