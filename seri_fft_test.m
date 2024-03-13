% Sinyal parametreleri
Fs = 100; % Örnekleme frekansı (Hz)
duration = 10; % Sinyal süresi (saniye)
f1 = 10; % Temel frekans (Hz)
A = 1; % Genlik

% Gürültü oluşturma
noise_level = 0.2;

% Zaman aralığı oluşturma
t = linspace(0, duration, duration*Fs);

% Başlangıç verisi oluşturma
initial_data_length = 500; % Başlangıç veri uzunluğu
initial_data = zeros(initial_data_length, 1); % Başlangıç verisi oluşturma

% Grafik penceresi oluşturma
figure;
subplot(7, 1, 1);
title('Zaman Alanı');
xlabel('Zaman (s)');
ylabel('Genlik');
grid on;
subplot(7, 1, 2);
title('Frekans Alanı');
xlabel('Frekans (Hz)');
ylabel('Genlik');
grid on;
subplot(7, 1, 3);
title('Zaman Alanında İnverse FFT (Filtreli)');
xlabel('Zaman (s)');
ylabel('Genlik');
grid on;
subplot(7, 1, 4);
title('Filtreli Sinyalin Integrali');
xlabel('Zaman (s)');
ylabel('Genlik');
grid on;
subplot(7, 1, 5);
title('Band Geçiren Filtre Uygulanmış Sinyal');
xlabel('Zaman (s)');
ylabel('Genlik');
grid on;
subplot(7, 1, 6);
title('Band Geçiren Filtre Uygulanmış Sinyal');
xlabel('Zaman (s)');
ylabel('Genlik');
grid on;
subplot(7, 1, 7);
title('Zaman Alanında İnverse FFT (Filtresiz)');
xlabel('Zaman (s)');
ylabel('Genlik');
grid on;

% FFT için pencere boyutu
N = 1024; % Önerilen değerler: 256, 512, 1024, 2048

% Veri tamponu oluşturma
data_buffer_size = 100;
data_buffer = initial_data; % Başlangıç verisini veri tamponuna ekleyin

% Band geçiren filtre parametreleri
bandpass_low_freq = 5; % Hz
bandpass_high_freq = 15; % Hz
filter_order = 50; % Filtre sırası

% Band geçiren filtre tasarımı
filt_obj = designfilt('bandpassfir', 'FilterOrder', filter_order, 'CutoffFrequency1', bandpass_low_freq, 'CutoffFrequency2', bandpass_high_freq, 'SampleRate', Fs);

% For döngüsü
for i = (initial_data_length+1):length(t)
    % Sürekli veri alımını simüle etmek için rastgele bir sayı oluştur
    random_value = noise_level * randn(); % Gürültü oluşturma
    
    % Sinyale rastgele değeri ekleme
    current_signal_value = A*sin(2*pi*f1*t(i))+0.5 + random_value;
    
    % Veri tamponunu güncelleme
    data_buffer = [data_buffer(2:end); current_signal_value]; % Veri tamponunu güncelle
    
    % Veri tamponunu FFT'ye gönderme
    Y = fft(data_buffer, N); % FFT hesaplama
    f = (0:length(Y)-1)*Fs/N; % Frekans aralığı
    
    % Zaman ve frekans alanında sinyal grafiği çizimi
    subplot(7, 1, 1);
    plot((0:length(data_buffer)-1)/Fs, data_buffer, 'b'); % Zaman alanında veri noktalarını çiz
    title('Zaman Alanı');
    xlabel('Zaman (s)');
    ylabel('Genlik');
    hold on;
    grid on;
    hold off; % Önceki veri noktalarını temizle
    
    % FFT grafiği çizimi
    subplot(7, 1, 2);
    plot(f(1:N/2), abs(Y(1:N/2)), 'r'); % Sadece pozitif frekanslar için FFT sonucunu çiz
    title('Frekans Alanı');
    xlabel('Frekans (Hz)');
    ylabel('Genlik');
    grid on;
    
    % İnverse FFT işlemi (filtreli)
    alt_sinir_frekansi = 5; % Hz
    alt_sinir_endeksi = ceil(alt_sinir_frekansi * N / Fs);
    Y_filtreli = Y;
    Y_filtreli(1:alt_sinir_endeksi) = 0; % İstenen frekans aralığındaki bileşenleri sıfırla
    inverse_Y_filtreli = real(ifft(Y_filtreli, N));
    subplot(7, 1, 3);
    plot((0:length(inverse_Y_filtreli)-1)/Fs, inverse_Y_filtreli, 'g'); % Zaman alanında İnverse FFT sonucunu çiz (filtreli)
    title('Zaman Alanında İnverse FFT (Filtreli)');
    xlabel('Zaman (s)');
    ylabel('Genlik');
    grid on;
    xlim([0 5]); % x ekseni sınırlarını belirle
    
    % Filtreli sinyalin integralini al
    t_current = (0:length(inverse_Y_filtreli)-1)/Fs; % Güncel zaman vektörü
    integral_filtreli = cumtrapz(t_current, inverse_Y_filtreli);
    
    % Filtreli sinyalin integralini çiz
    subplot(7, 1, 4);
    plot(t_current, integral_filtreli, 'b'); % Zaman alanında filtreli sinyalin integralini çiz
    title('Filtreli Sinyalin Integrali');
    xlabel('Zaman (s)');
    ylabel('Integral');
    grid on;
    xlim([0 5]); % x ekseni sınırlarını belirle
    
    % Band geçiren filtre uygulama
    filtered_signal = filtfilt(filt_obj, data_buffer);
    
    % Band geçiren filtre uygulanmış sinyalin grafiğini çizme
    subplot(7, 1, 5);
    plot((0:length(filtered_signal)-1)/Fs, filtered_signal, 'm'); % Zaman alanında filtre uygulanmış sinyal
    title('Band Geçiren Filtre Uygulanmış Sinyal');
    xlabel('Zaman (s)');
    ylabel('Genlik');
    grid on;
    xlim([0 5]); % x ekseni sınırlarını belirle

    % Bandpass filtreli sinyalin integralini al
    t_current_band_pass = (0:length(filtered_signal)-1)/Fs; % Güncel zaman vektörü
    integral_filtreli = cumtrapz(t_current_band_pass, filtered_signal);
    
    % Bandpas Integral
    subplot(7, 1, 6);
    plot(t_current_band_pass, integral_filtreli, 'r'); % Zaman alanında filtreli sinyalin integralini çiz
    title('Filtreli Sinyalin Integrali');
    xlabel('Zaman (s)');
    ylabel('Integral');
    grid on;

    % İnverse FFT işlemi (filtresiz)
    inverse_Y_filtresiz = real(ifft(Y, N));
    subplot(7, 1, 7);
    plot((0:length(inverse_Y_filtresiz)-1)/Fs, inverse_Y_filtresiz, 'm'); % Zaman alanında İnverse FFT sonucunu çiz (filtresiz)
    title('Zaman Alanında İnverse FFT (Filtresiz)');
    xlabel('Zaman (s)');
    ylabel('Genlik');
    grid on;
    xlim([0 5]); % x ekseni sınırlarını belirle
    
    % Grafiği güncelleme
    drawnow;
end
