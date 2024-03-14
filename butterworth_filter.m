% Örnek sinyallerin oluşturulması
Fs = 1000; % Örnekleme frekansı (Hz)
t = 0:1/Fs:1000-1/Fs; % 1 saniyelik bir zaman aralığı oluştur
f1 = 10; % İlk sinyal frekansı (Hz)
f2 = 40; % İkinci sinyal frekansı (Hz)
A1 = 1; % İlk sinyal genliği
A2 = 1; % İkinci sinyal genliği

% İlk sinyal oluşturulması
x1 = A1 * sin(2*pi*f1*t);

% İkinci sinyal oluşturulması
x2 = A2 * sin(2*pi*f2*t);

% Sinyallerin toplanması
x_sum = x1 + x2;

% DC offset eklenmesi
DC_offset = 2; % İstenilen DC offset değeri
x_sum_with_offset = x_sum + DC_offset;

% Gürültü ekleme
noise_amplitude = 0.5; % Gürültü genliği
x_sum_with_offset_and_noise = x_sum_with_offset + noise_amplitude * randn(size(x_sum_with_offset));

% Sinyalin grafiğinin çizdirilmesi
figure;
plot(t, x_sum_with_offset_and_noise);
title('Toplam Sinyal');
xlabel('Zaman (s)');
ylabel('Genlik');


% Sinyalin FFT'sini alınması
X_sum_with_fft = fft(x_sum_with_offset_and_noise);

% Frekans vektörünün oluşturulması
f_fft = Fs*(0:(length(x_sum_with_offset_and_noise)-1))/length(x_sum_with_offset_and_noise);

% % FFT'yi almak için gerekli indekslerin bulunması
% half_index = ceil(length(f_fft)/2);
% f_fft_half = f_fft(1:half_index);
% X_sum_with_fft_half = X_sum_with_fft(1:half_index);
% 
% % Yeni bir figür oluşturulması
% figure;
% 
% % FFT sonucunun grafiğinin çizdirilmesi
% plot(f_fft_half, abs(X_sum_with_fft_half));
% title('Toplam Sinyal Yarım FFT');
% xlabel('Frekans (Hz)');
% ylabel('Genlik');


% Geçiş bandı sınırları
low_fc = 0.2; % Düşük geçiş bandı sınır frekansı (Hz)
high_fc = 5; % Yüksek geçiş bandı sınır frekansı (Hz)

% Filtre sırası
order = 3; % Butterworth filtre sırası

% Butterworth band geçiren filtre tasarımı
[b, a] = butter(order, [low_fc, high_fc]/(Fs/2), 'bandpass');

% figure;
% % Filtre katsayılarının görselleştirilmesi
% freqz(b, a);
% title('Butterworth Bandpass Filtre Frekans Tepkisi');
% xlabel('Frekans (Hz)');
% ylabel('Genlik');


% filtered_signal = filter(b,a,x_sum_with_offset_and_noise);
% figure;
% plot(t, filtered_signal);
% title('Filtreli Sinyal');
% xlabel('Zaman (s)');
% ylabel('Genlik');

line = animatedline;
current_value = [];
time_buffer = [];
integral_value = 0;
for i = 1:length(x_sum_with_offset_and_noise)
    tic
    current_value (end + 1) = x_sum_with_offset_and_noise(i);
    time_buffer (end + 1) = i;
    if length(current_value) > 3
        length(current_value)
        filtered_signal = filter(b,a,current_value);
        %addpoints(line,time_buffer(end),filtered_signal(end));
        integral_value = integral_value + filtered_signal(end)*(1/Fs);
        addpoints(line,t(i),integral_value);
        drawnow limitrate;
    end
    toc
end


