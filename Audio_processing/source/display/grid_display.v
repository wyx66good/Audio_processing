module grid_display (
  input         rst_n,
  input         pclk,
  input         i_hs,
  input         i_vs,
  input         i_de,
  input  [23:0] i_data,
  output        o_hs,
  output        o_vs,
  output        o_de,
  output [23:0] o_data
);
  wire [11:0] pos_x;
  wire [11:0] pos_y;
  wire        pos_hs;
  wire        pos_vs;
  wire        pos_de;
  wire [23:0] pos_data;
  reg  [23:0] v_data;
  reg  [ 8:0] grid_x;
  reg         region_active;

  assign o_data = v_data;
  assign o_hs   = pos_hs;
  assign o_vs   = pos_vs;
  assign o_de   = pos_de;
  always @(posedge pclk) begin
    if ((pos_y == 12'd287 || pos_y == 12'd32 || pos_x == 12'd449 || pos_x == 12'd1477) && (pos_y >= 12'd32 && pos_y <= 12'd287 && pos_x >= 12'd449 && pos_x <= 12'd1477)) v_data <= {8'd25, 8'd25, 8'd112};  //pos_y == 12'd159 || (pos_y < 12'd287 && pos_y > 12'd32 && grid_x == 9'd9 && pos_y[0] == 1'b1)
    else v_data <= pos_data;
  end

  timing_gen_xy timing_gen_xy_m0 (
    .rst_n (rst_n),
    .clk   (pclk),
    .i_hs  (i_hs),
    .i_vs  (i_vs),
    .i_de  (i_de),
    .i_data(i_data),
    .o_hs  (pos_hs),
    .o_vs  (pos_vs),
    .o_de  (pos_de),
    .o_data(pos_data),
    .x     (pos_x),
    .y     (pos_y)
  );
endmodule
