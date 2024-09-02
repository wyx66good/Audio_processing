/*****************************************************************/
//
// Create Date: 2023/10/11
// Design Name: WenYiXing
//
/*****************************************************************/


`define UD #1
module key(
    input            clk,
    input            key,
    
    output  reg         key_on
);

    wire btn_deb;
    // 按键消抖
    btn_deb_fix#(                    
        .BTN_WIDTH   (  4'd8        ), //parameter                  BTN_WIDTH = 4'd8
        .BTN_DELAY   (20'h7_ffff    )
    ) u_btn_deb                           
    (                            
        .clk         (  clk         ),//input                      clk,
        .btn_in      (  key         ),//input      [BTN_WIDTH-1:0] btn_in,
                                    
        .btn_deb_fix (  btn_deb     ) //output reg [BTN_WIDTH-1:0] btn_deb
    );

    reg btn_deb_1d;
    always @(posedge clk)
    begin
        btn_deb_1d <= `UD btn_deb;
    end

    reg [1:0]  key_push_cnt=2'd0;
    always @(posedge clk)
    begin
        if(~btn_deb & btn_deb_1d)//按键按下
        begin
            key_on<=1'b1;
        end
        else 
            key_on<=1'b0;
    end
    

endmodule
