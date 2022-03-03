clear;

clean_sp = audioread('FDHC0_SI929.wav');
path = audioread('ir_2.wav');
path = path(1:744);
##path = audioread('Impulse_Response_1.wav');

echo = filter(path, 1, clean_sp);
figure, plot(clean_sp);
hold on, plot(echo);
