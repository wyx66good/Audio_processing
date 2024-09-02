/*****************************************************************/
//
// Create Date: 2023/10/11
// Design Name: WenYiXing
//
/*****************************************************************/


`define UD #1
module key(
    input            clk,
    input   [6:0]         key,
    
    output  reg  [6:0]       key_on
);

    wire [6:0]  btn_deb;
    // 按键消抖
    btn_deb_fix#(                    
        .BTN_WIDTH   (  4'd7        ), //parameter                  BTN_WIDTH = 4'd8
        .BTN_DELAY   (20'h7_ffff    )
    ) u_btn_deb                           
    (                            
        .clk         (  clk         ),//input                      clk,
        .btn_in      (  key         ),//input      [BTN_WIDTH-1:0] btn_in,
                                    
        .btn_deb_fix (  btn_deb     ) //output reg [BTN_WIDTH-1:0] btn_deb
    );

    reg [6:0]  btn_deb_1d;
    always @(posedge clk)
    begin
        btn_deb_1d <= `UD btn_deb;
    end

    reg [1:0]  key_push_cnt=2'd0;
    always @(posedge clk)
    begin
        if(~btn_deb[0] & btn_deb_1d[0])//按键按下
        begin
            key_on[0]<=1'b1;
        end
        else 
            key_on[0]<=1'b0;
    end

    always @(posedge clk)
    begin
        if(~btn_deb[1] & btn_deb_1d[1])//按键按下
        begin
            key_on[1]<=1'b1;
        end
        else 
            key_on[1]<=1'b0;
    end


    always @(posedge clk)
    begin
        if(~btn_deb[2] & btn_deb_1d[2])//按键按下
        begin
            key_on[2]<=1'b1;
        end
        else 
            key_on[2]<=1'b0;
    end

    always @(posedge clk)
    begin
        if(~btn_deb[3] & btn_deb_1d[3])//按键按下
        begin
            key_on[3]<=1'b1;
        end
        else 
            key_on[3]<=1'b0;
    end


    always @(posedge clk)
    begin
        if(~btn_deb[4] & btn_deb_1d[4])//按键按下
        begin
            key_on[4]<=1'b1;
        end
        else 
            key_on[4]<=1'b0;
    end


    always @(posedge clk)
    begin
        if(~btn_deb[5] & btn_deb_1d[5])//按键按下
        begin
            key_on[5]<=1'b1;
        end
        else 
            key_on[5]<=1'b0;
    end

    always @(posedge clk)
    begin
        if(~btn_deb[6] & btn_deb_1d[6])//按键按下
        begin
            key_on[6]<=1'b1;
        end
        else 
            key_on[6]<=1'b0;
    end
    

endmodule
