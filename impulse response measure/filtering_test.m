clear;

clean_sp = audioread('FDHC0_SI929.wav');
path = audioread('p_ir.wav');

echo = filter(path, 1, clean_sp);
figure, plot(clean_sp);
hold on, plot(echo);
sound(echo, 16000);
