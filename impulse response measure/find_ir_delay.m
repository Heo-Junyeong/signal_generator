pkg load signal;
close all;

[ir1, fs] = audioread('p_ir.wav');
[ir2, fs] = audioread('s_ir.wav');

ir1 = resample(ir1,16000,64000);
ir2 = resample(ir2,16000,64000);

figure; hold on; grid on; grid minor;
plot(ir1, 'k-'), xlabel('samples'), ylabel('values');
plot(ir2, 'r-');
title('path impulse response');
xlim([1, 400]);

sr = 4000;

% Parameters
pure_delay_sir = 70; pure_delay_pir = 142;
sir_tap = 16; pir_tap = 16;

% save directory
root_dir = './ir_results/';

% Routine
s_cut = pure_delay_sir : pure_delay_sir + sir_tap;
e_cut = pure_delay_pir : pure_delay_pir + pir_tap;

signal1 = ir1(e_cut);
signal2 = ir2(s_cut);

figure; plot(signal1, 'k-'), xlabel('samples'), ylabel('values');
title('path impulse response(no delay)');

hold on;
plot(signal2, 'r-');
legend('p ir','s ir');

xlim([1, pir_tap]);

hold on;
grid on;
grid minor;

audiowrite(strcat(root_dir, 'p_ir_nd_tap', num2str(pir_tap),'_sr' , num2str(sr), '_puredelay', num2str(pure_delay_pir), '.wav'), ir1, 4000);
audiowrite(strcat(root_dir, 's_ir_nd_tap', num2str(sir_tap),'_sr' , num2str(sr), '_puredelay', num2str(pure_delay_sir), '.wav'), ir2, 4000);