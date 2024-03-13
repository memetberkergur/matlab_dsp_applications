% Sinyal parametreleri
Fs = 100; % Örnekleme frekansı (Hz)
t = 0:(1/Fs):5; % 10 saniye boyunca örneklenen zaman aralığı (0 dan 5'e 1/Fs adımlar ile)
f1 = 10; % Temel frekans (Hz)
A = 1; % Genlik

% Gürültü ekleme
noise = 0.5*randn(size(t)); % Gürültü oluşturma

% DC bileşeni oluşturma
dc_offset = ones(size(t)); % 1 birimlik DC bileşeni

% Sinyal oluşturma
x = A*sin(2*pi*f1*t) + noise + dc_offset; % Gürültülü sinüs sinyali + DC bileşeni

% Grafik penceresi oluşturma
figure;

% For döngüsü
for i = 1:500
    % Anlık zaman dilimi seçimi
    time_slice = t(1:i)
    signal_slice = x(1:i);
    
    % FFT hesaplama
    Y = fft(signal_slice);
    f = (0:length(Y)-1)*Fs/length(Y); % Frekans aralığı
    
    % Zaman ve frekans alanında sinyal grafiği çizimi
    subplot(2, 1, 1);
    plot(time_slice, signal_slice, 'b');
    title('Zaman Alanı');
    xlabel('Zaman (s)');
    ylabel('Genlik');
    
    subplot(2, 1, 2);
    plot(f, abs(Y), 'r');
    title('Frekans Alanı');
    xlabel('Frekans (Hz)');
    ylabel('Genlik');
    
    % Grafiği güncelleme
    drawnow;
end
