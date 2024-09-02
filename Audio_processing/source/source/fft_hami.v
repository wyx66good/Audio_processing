module fft_hami(
input wire sys_clk,
input wire rest ,

input wire fft_finish,
input wire [63:0]fft_data,
output wire [10:0] fft_addr,

input wire [31:0]vudio_data,
output wire [10:0] vudio_addr,

output reg ddr_fft_en,
output wire ddr_rst,
output reg  [31:0]fft_ddr_data

   );


wire signed [31:0] o_fft_Real;
reg signed [31:0] o_fft_Real_1;
wire [31:0] o_fft_Real_z;
wire [31:0] o_vudio_Real_z;
//´òÅÄ
reg ddr_fft_en_1;
reg ddr_fft_en_2;
reg ddr_fft_en_3;
reg ddr_fft_en_4;
reg ddr_fft_en_5;

reg ddr_rst_1;
reg ddr_rst_2;
reg ddr_rst_3;
reg ddr_rst_4;
reg ddr_rst_5;

reg [31:0] fft_z/*synthesis PAP_MARK_DEBUG="1"*/;
reg [31:0]fft_z_1;
reg [31:0]fft_z_2;
reg [31:0]fft_z_3;
reg [31:0] vudio_z/*synthesis PAP_MARK_DEBUG="1"*/;
reg [31:0] vudio_z_1;
reg [31:0] vudio_z_2;
reg [31:0] vudio_z_3;

reg [10:0]fft_location;
reg [10:0]vudio_location;
reg o_fft_Real_1_1;
reg o_fft_Real_1_2;
reg o_fft_Real_1_3;
reg o_fft_Real_1_4;

reg o_vudio_Real_1_1;
reg o_vudio_Real_1_2;
reg o_vudio_Real_1_3;
reg o_vudio_Real_1_4;

reg [10:0] fft_cnt_h;
reg [10:0] fft_cnt_h_1;
reg [10:0] fft_cnt_h_2;
reg [10:0] fft_cnt_h_3;
reg [10:0] fft_cnt_h_4;
wire [10:0] fft_cnt_h_5;
assign fft_cnt_h_5=fft_cnt_h_2;
reg [10:0] fft_cnt_v;
reg [10:0] fft_cnt_v_1;
reg [10:0] fft_cnt_v_2;
reg [10:0] fft_cnt_v_3;
reg [10:0] fft_cnt_v_4;
reg [10:0] fft_cnt_v_5;

always@(posedge sys_clk or negedge rest)
begin
    if(!rest||fft_cnt_h == 'd1920-'d1||(fft_cnt_v=='d1080-'d1&&fft_cnt_h == 'd1920-'d1))
        fft_cnt_h <= 'd0;
    else if(1'b1)//finsh
        fft_cnt_h <= fft_cnt_h + 1;
    else 
        fft_cnt_h <= 'd0;
end

always@(posedge sys_clk or negedge rest)
begin
    if(!rest||(fft_cnt_v=='d1080-'d1&&fft_cnt_h == 'd1920-'d1))begin
        fft_cnt_v <= 'd0;
    end
    else if(fft_cnt_h == 'd1920-'d1)begin
        if(1'b1)
            fft_cnt_v <= fft_cnt_v + 1;
        else
            fft_cnt_v <= 'd0;
    end
    else
        fft_cnt_v <= fft_cnt_v;
end
//
//
assign ddr_rst=ddr_rst_3;
assign o_fft_Real=fft_data[31:0];
assign fft_addr=('d300<fft_cnt_h&&fft_cnt_h<='d1326)?(fft_cnt_h-'d300)/4:'d0;
assign vudio_addr=('d300<fft_cnt_h&&fft_cnt_h<='d1326)?fft_cnt_h-'d300:'d0;
assign o_fft_Real_z=(fft_data[31]=='d0)?o_fft_Real:((~o_fft_Real+1));
assign o_vudio_Real_z=(vudio_data[31]=='d0)?vudio_data:((~vudio_data+1));
//assign o_fft_Real_1=(fft_addr=='d0)?o_fft_Real_z:o_fft_Real_1;
always@(posedge sys_clk or negedge rest)
begin
    if(!rest) begin
        o_fft_Real_1 <= 'd0;
    end
    else if((o_fft_Real_1>=o_fft_Real_z))begin
            o_fft_Real_1<=o_fft_Real_1;
    end
    else begin
        o_fft_Real_1 <= o_fft_Real_z;
    end
end
//ÔËËã 

always@(posedge sys_clk or negedge rest)
begin
    if(!rest) begin
        fft_z <= 'd0;
        vudio_z <= 'd0;
        o_fft_Real_1_1 <= 'd0;
        o_vudio_Real_1_1 <= 'd0;
        ddr_fft_en_1<='d0;
    end
    else if(1'b1)begin
            fft_z<=o_fft_Real_z>>10;//>>10
            vudio_z<=o_vudio_Real_z>>4;//>>10
            o_fft_Real_1_1<=o_fft_Real[31];
            o_vudio_Real_1_1 <= vudio_data[31];
            ddr_fft_en_1<='d1;
    end
    else begin
        fft_z <= 'd0;
        vudio_z <= 'd0;
        o_fft_Real_1_1 <= 'd0;
        o_vudio_Real_1_1 <= 'd0;
        ddr_fft_en_1<='d0;
    end
end

always@(posedge sys_clk or negedge rest)
begin
    if(!rest) begin
        fft_z_1 <= 'd0;
        vudio_z_1 <= 'd0;
        o_fft_Real_1_2 <= 'd0;
        o_vudio_Real_1_2 <= 'd0;
        ddr_fft_en_2<='d0;
        fft_cnt_v_1 <='d0;
    end
    else begin
            fft_z_1<=fft_z+o_fft_Real_z>>11;//>>11
            vudio_z_1<=vudio_z+o_vudio_Real_z>>5;//>>11
            o_fft_Real_1_2<=o_fft_Real_1_1;
            o_vudio_Real_1_2 <= o_vudio_Real_1_1;
            ddr_fft_en_2<=ddr_fft_en_1;
            fft_cnt_v_1<=fft_cnt_v;
    end
end
always@(posedge sys_clk or negedge rest)
begin
    if(!rest) begin
        fft_z_2 <= 'd0;
        vudio_z_2 <= 'd0;
        o_fft_Real_1_3 <= 'd0;
        o_vudio_Real_1_3 <= 'd0;
        ddr_fft_en_3<='d0;
        fft_cnt_v_2 <='d0;
    end
    else begin
            fft_z_2<=fft_z_1;
            vudio_z_2 <= vudio_z_1;
            o_fft_Real_1_3<=o_fft_Real_1_2;
            o_vudio_Real_1_3<=o_vudio_Real_1_2;
            ddr_fft_en_3<=ddr_fft_en_2;
            fft_cnt_v_2<=fft_cnt_v_1;
    end
end

always@(posedge sys_clk or negedge rest)
begin
    if(!rest) begin
        fft_z_3 <= 'd0;
        vudio_z_3 <= 'd0;
        o_fft_Real_1_4 <= 'd0;
        o_vudio_Real_1_4 <= 'd0;
        ddr_fft_en_4<='d0;
        fft_cnt_v_3 <='d0;
    end
    else begin
            fft_z_3<=fft_z_2;
            vudio_z_3 <= vudio_z_2;
            o_fft_Real_1_4<=o_fft_Real_1_3;
            o_vudio_Real_1_4<=o_vudio_Real_1_3;
            ddr_fft_en_4<=ddr_fft_en_3;
            fft_cnt_v_3<=fft_cnt_v_2;
    end
end


always@(posedge sys_clk or negedge rest)
begin
    if(!rest) begin
        fft_location<='d0;
        ddr_fft_en_5<='d0;
        fft_cnt_v_4 <='d0;
    end
    else begin
        ddr_fft_en_5<=ddr_fft_en_4;
        fft_cnt_v_4<=fft_cnt_v_3;
        if (!o_fft_Real_1_4)begin
            fft_location<='d900-fft_z_3;
        end
        else begin
            fft_location<=fft_z_3+'d900;
        end

        if (!o_vudio_Real_1_4)begin
            vudio_location<='d450-vudio_z_3;
        end
        else begin
            vudio_location<=vudio_z_3+'d450;
        end
    end
end

always@(posedge sys_clk or negedge rest)
begin
    if(!rest) begin
        fft_ddr_data <= 'd0;
        ddr_fft_en<='d0;
        fft_cnt_v_5 <='d0;
    end
    else begin
        ddr_fft_en<=ddr_fft_en_5;
        fft_cnt_v_5<=fft_cnt_v_4;
//        if (!o_fft_Real_1_4)begin
            if('d300<fft_cnt_h_4&&fft_cnt_h_4<='d1326&&ddr_fft_en&&(((fft_location==fft_cnt_v_4||vudio_location==fft_cnt_v_4))||
                ((fft_location==fft_cnt_v_4-'d1||vudio_location==fft_cnt_v_4-'d1))||((fft_location==fft_cnt_v_4-'d2||vudio_location==fft_cnt_v_4-'d2))
                ||((fft_location==fft_cnt_v_4-'d3||vudio_location==fft_cnt_v_4-'d3))||((fft_location==fft_cnt_v_4-'d4||vudio_location==fft_cnt_v_4-'d4))
                ||((fft_location==fft_cnt_v_4-'d5||vudio_location==fft_cnt_v_4-'d5))||((fft_location==fft_cnt_v_4-'d6||vudio_location==fft_cnt_v_4-'d6))))begin
                fft_ddr_data<=24'hff0000;
            end
            else begin
                fft_ddr_data<={8'h00,8'hff,8'hff};
            end
//        end
//        else begin
//            if(ddr_fft_en&&(((fft_location==fft_cnt_v_4||vudio_location==fft_cnt_v_4)&&fft_cnt_h_4<='d1024)||
//                (fft_location==fft_cnt_v_4-'d1&&fft_cnt_h_4<='d1024)||(fft_location==fft_cnt_v_4-'d2&&fft_cnt_h_4<='d1024)
//                ||(fft_location==fft_cnt_v_4-'d3&&fft_cnt_h_4<='d1024)||(fft_location==fft_cnt_v_4-'d4&&fft_cnt_h_4<='d1024)
//                ||(fft_location==fft_cnt_v_4-'d5&&fft_cnt_h_4<='d1024)||(fft_location==fft_cnt_v_4-'d6&&fft_cnt_h_4<='d1024)))begin
//                fft_ddr_data<=24'hff0000;
//            end
//            else begin
//                fft_ddr_data<={8'h00,8'hff,8'hff};
//            end
//        end
    end
end
always@(posedge sys_clk or negedge rest)
begin
    if(!rest) begin
        ddr_rst_1 <= 'd1;

    end
    else if((fft_cnt_v=='d1080-'d1&&fft_cnt_h == 'd1920-'d1)) begin
        ddr_rst_1 <= 'd0;

    end
    else
        ddr_rst_1 <= 'd1;
end
always@(posedge sys_clk or negedge rest)
begin
    if(!rest) begin
        ddr_rst_2 <= 'd1;
        fft_cnt_h_1 <= 'd0;
    end
    else begin
        ddr_rst_2 <= ddr_rst_1;
        fft_cnt_h_1 <= fft_cnt_h;
    end
end
always@(posedge sys_clk or negedge rest)
begin
    if(!rest) begin
        ddr_rst_3 <= 'd1;
        fft_cnt_h_2 <= 'd0;
    end
    else begin
        ddr_rst_3 <= ddr_rst_2;
        fft_cnt_h_2 <= fft_cnt_h_1;
    end
end
always@(posedge sys_clk or negedge rest)
begin
    if(!rest) begin
        ddr_rst_4 <= 'd1;
        fft_cnt_h_3 <= 'd0;
    end
    else begin
        ddr_rst_4 <= ddr_rst_3;
        fft_cnt_h_3 <= fft_cnt_h_2;
    end
end

always@(posedge sys_clk or negedge rest)
begin
    if(!rest) begin
        ddr_rst_5 <= 'd1;
        fft_cnt_h_4 <= 'd0;
    end
    else begin
        ddr_rst_5 <= ddr_rst_4;
        fft_cnt_h_4 <= fft_cnt_h_3;
    end
end

////test
//    localparam H_ACT_ARRAY_0 = 'd1920/8;
//    localparam H_ACT_ARRAY_1 = 2* ('d1920/8);
//    localparam H_ACT_ARRAY_2 = 3* ('d1920/8);
//    localparam H_ACT_ARRAY_3 = 4* ('d1920/8);
//    localparam H_ACT_ARRAY_4 = 5* ('d1920/8);
//    localparam H_ACT_ARRAY_5 = 6* ('d1920/8);
//    localparam H_ACT_ARRAY_6 = 7* ('d1920/8);
//    localparam H_ACT_ARRAY_7 = 8* ('d1920/8);
//
//    always @(posedge sys_clk)
//    begin
//        ddr_fft_en<='d1;
//        if (ddr_fft_en)
//        begin
//            if(fft_cnt_h < H_ACT_ARRAY_0)
//            begin
//                fft_ddr_data <= {8'hff, 8'hff, 8'hff};
//            end
//            else if(fft_cnt_h < H_ACT_ARRAY_1)
//            begin
//                fft_ddr_data <= {8'hff, 8'hff, 8'h00};
//            end
//            else if(fft_cnt_h < H_ACT_ARRAY_2)
//            begin
//                fft_ddr_data <= {8'h00, 8'hff, 8'hff};
//            end
//            else if(fft_cnt_h < H_ACT_ARRAY_3)
//            begin
//
//                fft_ddr_data <= {8'h00, 8'hff, 8'h00};
//            end
//            else if(fft_cnt_h < H_ACT_ARRAY_4)
//            begin
//
//                fft_ddr_data <= {8'hff, 8'h00, 8'hff};
//            end
//            else if(fft_cnt_h < H_ACT_ARRAY_5&&fft_cnt_v<'d540)
//            begin
//
//                fft_ddr_data <= {8'hff, 8'h00, 8'h00};
//            end
//            else if(fft_cnt_h < H_ACT_ARRAY_6)
//            begin
//
//                fft_ddr_data <= {8'h00, 8'h00, 8'hff};
//            end
//            else
//            begin
//
//                fft_ddr_data <= {8'h00, 8'h00, 8'h00};
//            end
//        end
//        else
//        begin
//
//                fft_ddr_data <= {8'h00, 8'h00, 8'h00};
//        end
//    end

endmodule