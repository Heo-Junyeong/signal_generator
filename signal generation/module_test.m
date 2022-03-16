%%
clear all;
close all;
a = 1;

function [cos_signal, sin_signal, t] = make_sin_cos_iir(fnd_freq, len, sampling_rate, fnd_amp, use_plot)
% ##############################################################################
% This function generates sinetone and cosineton
%
% Usage:
%  [cos_signal, sin_signal, t] = make_sin_cos_iir(fnd_freq, len, sampling_rate, fnd_amp, use_plot)
%
% Parameters:
%  - fnd_freq : fundamental frequency
%  - sec : signal length (seconds)
%  - sampling_rate : sampling rate of signal
%  - fnd_amp  : amplitude of signal(sine wave) ; defualt = 1
%  - use_plot : plot create sine table at generate time ; defualt = 'True'
% ##############################################################################

  % set defualt parameters
  if nargin < 5,
    use_plot = 'False';
  end
  
  if nargin < 4,
    fnd_amp = 1;
  end
  
  t = linspace(0, len, sampling_rate * len);
  
  % init
  a1 = fnd_amp * cos(2 * pi * fnd_freq * (1/sampling_rate));
  b0 = fnd_amp * sin(2 * pi * fnd_freq * (1/sampling_rate));
  
  qn1 = 1; qn2 = 0;
  
  for n = 1 : length(t),
    cos_signal(n) = qn1-a1*qn2;  % data push
    sin_signal(n) = b0 * qn2;
    
    qn0 = 2 * a1 * qn1 - qn2; % q(n) = a1 * qn(n-1) - q(n-2)
    qn2 = qn1;
    qn1 = qn0;
  end
 
  if strcmp(use_plot, "True"),
    debug_figure(); hold on; grid on; grid minor;
    plot(sin_signal, 'k-');  
    plot(cos_signal, 'r-');
    title(strcat('signal generation, f0=', num2str(fnd_freq), ' sr=', num2str(sampling_rate)));
    xlabel('samples');
    legend('sin', 'cos');
    
    figure; hold on; grid on; grid minor;
    
  end
end

function y = debug_figure,
%% wrapper function for create figure
  figure('position',[1980, 200, 800, 500]);
end


%% tool funcions
%% functions
function [P1, f] = plot_fft(time_domain_signal, signal_length, sampling_rate)
  Y = fft(time_domain_signal);
  P2 = abs(Y/signal_length);
  P1 = P2(1:signal_length/2+1);
  P1(2:end-1) = 2*P1(2:end-1);
  
  f = sampling_rate * (0:(signal_length/2))/signal_length;
  
  plot(f, P1, 'r');
  ylabel('Magnitude'), xlabel('frequency (Hz)');
end

function [P1, f] = plot_fft2(time_domain_signal, signal_length, sampling_rate)
  Y = fft(time_domain_signal);
  P2 = abs(Y/signal_length);
  P1 = P2(1:signal_length/2+1);
  P1(2:end-1) = 2*P1(2:end-1);
  
  f = sampling_rate * (0:(signal_length/2))/signal_length;
  
  plot(f, P1, 'b');
  ylabel('Magnitude'), xlabel('frequency (Hz)');
end
function [P1, f] = plot_fft_dB(time_domain_signal, signal_length, sampling_rate)
  Y = fft(time_domain_signal);
  P2 = abs(Y/signal_length);
  P1 = P2(1:signal_length/2+1);
  P1(2:end-1) = 2*P1(2:end-1);
  
  f = sampling_rate * (0:(signal_length/2))/signal_length;
  P1 = 10*log10(P1);
  plot(f, P1);
  ylabel('Magnitude(dB)'), xlabel('frequency (Hz)');
end

function plot_stft(time_domain_signal)%, signal_length, sampling_rate, window)
  specgram(time_domain_signal);
  colormap hot;
end

function plot_welch(time_domain_signal)%, signal_length, sampling_rate, windowing)
  pwelch(time_domain_signal);
  ylabel('PSD'), xlabel('frequency (Hz)');
end

function plot_welch_dB(time_domain_signal)%, signal_length, sampling_rate, windowing)
  [pxx, f] = pwelch(time_domain_signal);
  plot(f, 10*log10(pxx));
  ylabel('PSD(dB/Hz)'), xlabel('frequency (Hz)');
end

function save_fig2png(figure, filename, directory)
   if nargin < 3,
     directory = './figure/';
   end
   filename = strcat(directory, filename);
   saveas(figure, filename, 'png');
end

function [harmonics_nth] = make_harmonics(signal, nth)
% ##############################################################################
% This function generates sinetone of fundamental wave sine table
%
% Usage:
%  [harmonics_nth] = make_harmonics(signal, nth)
%
% Parameters:
%  - fnd_freq : fundamental frequency
%  - nth : nth fundamental frequency
% ##############################################################################
nSamples = length(signal);
loop = 0;

for i = 1 : nSamples,  
  harmonics_nth(i) = signal(mod(loop, nSamples) + 1);
  loop += nth;
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




fs = 4000;
freq = 20;
sec = 10;


[aa, bb, t] = make_sin_cos_iir(freq, sec, fs);
%% aa=cos, bb= sin
disp(aa*bb');

a1 = make_harmonics(aa, 1);
a2 = make_harmonics(aa, 2);
a3 = make_harmonics(aa, 3);

figure; hold on;
plot(a1, 'r-');
plot(a2, 'k-');
plot(a3, 'b-');

figure; hold on;
plot_fft(a1, length(a1), fs);
plot_fft(a2, length(a2), fs);
plot_fft(a3, length(a3), fs);
xlim([0, 100]);