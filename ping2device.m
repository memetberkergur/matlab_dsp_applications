% Ping atılacak IP adresi
ipAddress = '192.168.1.4';

% Ping komutunu oluşturun ve çalıştırın
command = ['ping -n 4 ' ipAddress]; % Windows için
% command = ['ping -c 4 ' ipAddress]; % Linux/Mac için
[status, result] = system(command);

% Bilgisayar adını alın
hostName = getenv('computername');

% Bilgisayar adını IP adresine çevirin
ipAddress = char(java.net.InetAddress.getByName(hostName).getHostAddress());

% Ping sonuçlarını ekrana yazdırın
disp(result);

% IP adresini ekrana yazdırın
disp(['Bilgisayar IP Adresi: ', ipAddress]);

