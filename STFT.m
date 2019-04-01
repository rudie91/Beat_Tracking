function X = STFT(x,M,Zp,R,Win)
n = 0;
if mod(length(x),2) == 0 % if x is even length
    bins = floor((M*Zp)/2+1); % the number of frequency bins
else
    bins = floor((1+M*Zp)/2);
end
nframes = floor((length(x)-M)/R)+1; % the number of columns (frames)
    for m=1:nframes
        xt = x(n+1:n+M,1); % take one window length
        xt = xt .* Win; % window the signal
        xt_z = [xt; zeros((Zp-1)*length(xt),1)]; % zero padding
        temp = fft(xt_z,M*Zp); % take fft of zero padded windowed signal with M*Zp points
        X(:,m) = temp(1:bins); % put frequency bins into a column 
        n = n + R; % move the index by the hop size
    end
end
