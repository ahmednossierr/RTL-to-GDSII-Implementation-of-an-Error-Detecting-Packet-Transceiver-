module parity_gen (
    input [10:0] data_in ,
    output [3:0]  parity_out , output  [14:0] codeword_out
);

    wire p3, p2, p1, p0;

    assign p3 = data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[7] ^ data_in[10];
    assign p2 = data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[10];
    assign p1 = data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[9];
    assign p0 = data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[8];

    assign parity_out   = {p3, p2, p1, p0};
    assign codeword_out = {data_in, parity_out};

endmodule
