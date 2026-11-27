clear; clc; close all;

for i = 1:1000 
    % Generating random stream
    D = randi([0,1],1,11);
    D_flipped = flip(D);
    
    P(4) = red_xor(D_flipped([1 2 3 5 7 8 11]));
    P(3) = red_xor(D_flipped([3 4 5 6 8 10 11]));
    P(2) = red_xor(D_flipped([2 3 4 5 7 9 10]));
    P(1) = red_xor(D_flipped([1 2 3 4 6 8 9]));

    y = [D_flipped P(4:-1:1)];

    y_golden = encode(D, 15, 11, 'hamming/binary');
    y_golden = [flip(y_golden(5:15)), y_golden(1:4)];

    % Validating the Tx Encoding generation
    if any(y ~= y_golden) 
        error("Hamming encoder is incorrect");
    end

    % Rx side
    rx_in = y;
    rx_data = rx_in(1:11);
    rx_parity = rx_in(12:15);

    P_rx(4) = red_xor(rx_data([1 2 3 5 7 8 11]));
    P_rx(3) = red_xor(rx_data([3 4 5 6 8 10 11]));
    P_rx(2) = red_xor(rx_data([2 3 4 5 7 9 10]));
    P_rx(1) = red_xor(rx_data([1 2 3 4 6 8 9]));

    % Syndrome
    S = xor(P_rx(4:-1:1), rx_parity);

    if any(S ~= 0)
        error("Hamming decoder is incorrect");
    end
end
disp("Hamming encoder/decoder is correct, Modelling matches MATLAB's built-in function");


function y = red_xor(x)
    y = 0;
    for i = 1:length(x)
        y =  xor(x(i),y);
    end
end