clear all
close all

%% function
function plot_fft(time_domain_signal, signal_length, sampling_rate)
  Y = fft(time_domain_signal);
  P2 = abs(Y/signal_length);
  P1 = P2(1:signal_length/2+1);
  P1(2:end-1) = 2*P1(2:end-1);
  
  f = sampling_rate * (0:(signal_length/2))/signal_length;
  
  plot(f, P1); grid on; grid minor;
  ylabel('Magnitude'), xlabel('frequency (Hz)');
end

function plot_fft_dB(time_domain_signal, signal_length, sampling_rate)
  Y = fft(time_domain_signal);
  P2 = abs(Y/signal_length);
  P1 = P2(1:signal_length/2+1);
  P1(2:end-1) = 2*P1(2:end-1);
  
  f = sampling_rate * (0:(signal_length/2))/signal_length;
  P1 = 10*log10(P1);
  plot(f, P1); grid on; grid minor;
  ylabel('Magnitude(dB)'), xlabel('frequency (Hz)');
end

function plot_stft(time_domain_signal)#, signal_length, sampling_rate, window)
  specgram(time_domain_signal);
  colormap hot;
end

function plot_welch(time_domain_signal)#, signal_length, sampling_rate, windowing)
  pwelch(time_domain_signal);
  grid on; grid minor;
  ylabel('PSD'), xlabel('frequency (Hz)');
end

function plot_welch_dB(time_domain_signal)#, signal_length, sampling_rate, windowing)
  [pxx, f] = pwelch(time_domain_signal);
  plot(f, 10*log10(pxx));
  grid on; grid minor;
  ylabel('PSD(dB/Hz)'), xlabel('frequency (Hz)');
end

function save_fig2png(figure, filename)
  saveas(figure, filename, 'png');
end

%% signal generation
fs = 2000;
sec = 5;

t = linspace(0, sec, fs*sec);

A = 100;

f0 = 100;
f1 = 200;
f2 = 300;

for n=1:length(t),
  
  x1(n) = A*cos(2*pi*(f0/fs)*n);
  x2(n) = A*cos(2*pi*(f1/fs)*n);
  x3(n) = A*cos(2*pi*(f2/fs)*n);
end

for n=1:length(t),
  y1(n) = A*sin(2*pi*(f0/fs)*n);
  y2(n) = A*sin(2*pi*(f1/fs)*n);
  y3(n) = A*sin(2*pi*(f2/fs)*n);
end

s = x1+y2+y3;
plot_stft(s);

plot_fft_dB(s, length(s), fs)

#view(-45,65);
#colormap jet;

##
##figure; plot(s); xlim([1, 100]);
##
##figure; plot_fft(s, length(s), fs);
