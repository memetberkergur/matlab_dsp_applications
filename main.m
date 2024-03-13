clear all;
clear;
clc;

% UDP sunucu için IP adresi ve port numarası
target_ip = '192.168.1.55';
target_port = 12345;

AMD1 = AMD7003D(target_ip,target_port);

AMD1.connect();
AMD1.readData();

