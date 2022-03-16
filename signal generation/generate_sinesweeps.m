start = 1;

function sdb1 = generate_sinesweeps(f1,f2,fs, N, iter)
% sdbl = generate_sinesweeps(f1,f2,fs,N)
%
% f1:      starting frequency [Hz]
% f2:      ending frequency [Hz]
% fs:      sampling rate (Hz)
% N:       If N is an integer, the total length of the excitation sound file is
%          2*(2^N) samples, or 2*(2^N)/fs seconds.  This helps speed up
%          computation.
%
%http://ccrma.stanford.edu/realsimple/imp_meas/generate_sinesweeps.m
%
% A sine sweep ranging from f1 to f2 is created.  It is repeated
% twice so that cyclical (de)convolution may be applied to easily
% find the inverse filter.  The result is also written to 'sinesweeps.wav'
%
% T:       the length of the excitation in samples
%
% 
% RealSimPLE Project
% Edgar Berdahl, 6/10/07
% Updated on 8/19/08
%
% e.g. generate_sinesweeps(20,20000,44100,17);

  T = (2^N)/fs;

  % Create the swept sine tone
  w1 = 2*pi*f1;
  w2 = 2*pi*f2;
  K = T*w1/log(w2/w1);
  L = T/log(w2/w1);
  t = linspace(0,T-1/fs,fs*T);
  s = sin(K*(exp(t/L) - 1));
  
  sdb1 = zeros(1);
  % Double the length so that it is easy to use cyclical (de)convolution
  for n = 1 : iter,
    sdb1 = [sdb1, s];
  end
% Scaling by 0.9999 suppresses a warning message about clipping.
  audiowrite('sinesweeps.wav', sdb1 * 0.9999, fs);
  
end

sdb1 = generate_sinesweeps(20, 8000, 16000, 17, 1);
specgram(sdb1);