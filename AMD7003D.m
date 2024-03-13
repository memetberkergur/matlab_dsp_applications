classdef AMD7003D
    properties (Access = private)
        device_params
        destination_ip;
        destination_port;
        udp_socket;
    end

    %Public Methods
    methods (Access = public)
        % Constructor for AMD7003D
        function obj = AMD7003D(device_ip, device_port)
            obj.device_params = struct('destination_ip', device_ip, 'destination_port', device_port);
        end
        % Connect to AMD
        function connect(obj)
            % CONNECT : Connect to AMD
            % write(udp_object,data,destinationAddress,destinationPort)
            obj.udp_socket = udpport;
            message = uint8('2');
            write(obj.udp_socket,message,obj.device_params.destination_ip,obj.device_params.destination_port);
        end
        function [ACCX,ACCY,ACCZ,ENCODER,TEMPERATURE] = readData(obj)
           data = read(obj.udp_socket,100,'string');
           [ACCX,ACCY,ACCZ,ENCODER,TEMPERATURE] = parseData(data);
        end
        
    end
    methods (Access = private)
        function [ACCX,ACCY,ACCZ,ENCODER,TEMPERATURE] = parseData(obj,data)
            ACCX = 0;
            ACCY = 0;
            ACCZ = 0;
            ENCODER = 0;
            TEMPERATURE = 0;
        end
    end

end
