pkg load signal;
[ir1, fs] = audioread('p_ir.wav');
[ir2, fs] = audioread('s_ir.wav');

ir1 = resample(ir1,16000,44100);
ir2 = resample(ir2,16000,44100);


figure; hold on; grid on; grid minor;
plot(ir1, 'k-'), xlabel('samples'), ylabel('values');
plot(ir2, 'r-');
title('path impulse response');
xlim([1, 400]);


signal1 = ir1(190:254);
signal2 = ir2(100:164);


figure; plot(signal1, 'b-'), xlabel('samples'), ylabel('values');
title('path impulse response(no delay)');

hold on;
plot(signal2, 'r-');
legend('p ir','s ir');

xlim([1, 64]); ylim([-0.03 0.06]);

hold on;
grid on;
grid minor;
