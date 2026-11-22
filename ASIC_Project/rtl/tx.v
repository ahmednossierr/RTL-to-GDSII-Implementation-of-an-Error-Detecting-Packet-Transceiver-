module tx (
    input clk , input rst_n , input tx_start , input [10:0] tx_data,
    output reg tx_busy, output reg [14:0] tx_link_out
  );

  ///Parameters 
  localparam [14:0] header_word = 15'h7EBE;

  //states
  localparam [1:0] tx_idle = 2'b00 , tx_hdr  = 2'b01 , tx_pay  = 2'b10;


  //signals
  reg  [1:0]  state, nxt_state;
  reg  [10:0] tx_data_reg;
  wire [14:0] payload_codeword;


  // instatiation
  parity_gen u_parity_gen (
               .data_in      (tx_data_reg),
               .parity_out   (),
               .codeword_out (payload_codeword)
             );



//FSM Of the TX  
  always @(posedge clk or negedge rst_n)
  begin
    if (!rst_n)begin
      state <= tx_idle;
      tx_data_reg <= 11'h000;
    end
    else
    begin
      state <= nxt_state;
      if (nxt_state == tx_hdr)
        tx_data_reg <= tx_data; // bn7ot el data fe reg 3shan lw input hyt8yr we e7na lsa fel tx_hdr state
    end
  end

  //fsm states
  always @(*)
  begin
    case (state)

      //idle case
      tx_idle:begin
        if (tx_start)
          nxt_state = tx_hdr;
        else
          nxt_state = tx_idle;
      end

      // header case , directly goes to the tx_pay
      tx_hdr:begin
        nxt_state = tx_pay;
      end

      // payload 
      tx_pay:begin
        if (tx_start)
          nxt_state =tx_hdr;
        else
          nxt_state =tx_idle;
      end

      default:nxt_state = tx_idle;

    endcase
  end

  // output logic
  always @(*)
  begin
    case (state)

      tx_idle:begin
        tx_busy = 1'b0;
        tx_link_out = 15'h0000;
      end

      tx_hdr:begin
        tx_busy = 1'b1;
        tx_link_out = header_word;
      end

      tx_pay:begin
        tx_busy = 1'b1;
        tx_link_out = payload_codeword;
      end

      default:begin
        tx_busy = 1'b0;
        tx_link_out = 15'h0000;
      end
    endcase
  end

endmodule


