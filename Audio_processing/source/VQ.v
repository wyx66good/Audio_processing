

/*************
Author:wyx
Times :2024.8.9
VQ 欧式距离和选择MIN
**************/


module VQ(

    input     wire              clk  ,
    input     wire              rst_n,//开始时清空

    input   wire                VQ_start,//开始
    output   wire               VQ_finsh,//结束

    input     wire [12:0]       DCT_ADDR,
    input     wire  [8:0]       Frams_Number,
    input     wire  [2:0]       CNT_FOR,

    output    wire   [7:0]      MFCCS13_13_ADDR_1,
    output    wire              MFCCS13_en,
    output    wire   [12:0]     MFCCS13_ADDR/*synthesis PAP_MARK_DEBUG="1"*/,
    input     wire [13:0]       MFCCS13_DATA/*synthesis PAP_MARK_DEBUG="1"*/,

    input     wire [13:0]       LBG_rd_data_1/*synthesis PAP_MARK_DEBUG="1"*/,
    output    wire [7:0]        LBG_rd_addr_1/*synthesis PAP_MARK_DEBUG="1"*/,

    output    wire [31:0]       MIN    ,
    output    wire [4:0]        MIN_i  /*synthesis PAP_MARK_DEBUG="1"*/,
    output    wire              MIN_EN /*synthesis PAP_MARK_DEBUG="1"*/,

    output    reg  [40:0]       D        ,
    output    reg               D_en


   );
wire [4:0] distance_CNT;
wire [7:0] distance_CNT_1;
assign distance_CNT_1={3'd0,distance_CNT};
/************************************************************************************/
wire MFCC_start;
wire MFCC_finsh;
reg [12:0]  Frams_Number_CNT/*synthesis PAP_MARK_DEBUG="1"*/;
wire        Frams_Number_whlie;
wire [7:0]  MFCCS13_rd_13_ADDR;
wire [13:0] MFCCS13_rd_13_DATA/*synthesis PAP_MARK_DEBUG="1"*/;
wire [7:0]  MFCCS13_13_ADDR;
assign MFCCS13_13_ADDR_1=MFCCS13_13_ADDR;
MFCC_frame_13 MFCC_frame_13( 
.clk              (clk            ),
.rst_n            (rst_n          ),
.MFCC_start       (MFCC_start     ),
.MFCC_finsh       (MFCC_finsh     ),
.DCT_ADDR         (DCT_ADDR       ),
.Frams_Number     (Frams_Number   ),
.MFCCS13_en       (MFCCS13_en     ),
.MFCCS13_ADDR     (MFCCS13_13_ADDR   ),
.MFCCS13_DATA     (MFCCS13_DATA   ),
.MFCCS13_rd_ADDR  (distance_CNT_1),
.MFCCS13_rd_DATA  (MFCCS13_rd_13_DATA)
   );

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        Frams_Number_CNT <= 'd0;
    end
    else if(MFCC_finsh) begin
        Frams_Number_CNT <= Frams_Number_CNT+'d13;
    end
    else begin
        Frams_Number_CNT <= Frams_Number_CNT;
    end
end
assign MFCC_start=VQ_start||Frams_Number_whlie;
assign MFCCS13_ADDR=MFCCS13_13_ADDR+Frams_Number_CNT;

reg MFCC_frame_13_genxing_finsh/*synthesis PAP_MARK_DEBUG="1"*/;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        MFCC_frame_13_genxing_finsh <= 'd0;
    end
    else if(MFCC_start) begin
        MFCC_frame_13_genxing_finsh <= 'd0;
    end
    else if(MFCC_finsh) begin
        MFCC_frame_13_genxing_finsh <= 'd1;
    end
    else begin
        MFCC_frame_13_genxing_finsh <= MFCC_frame_13_genxing_finsh;
    end
end
/************************************************************************************/
wire LBG_start;
wire LBG_finsh;
wire [13:0]       rd_vblg_1 /*synthesis PAP_MARK_DEBUG="1"*/;
wire [13:0]       rd_vblg_2 /*synthesis PAP_MARK_DEBUG="1"*/;
wire [13:0]       rd_vblg_3 ;
wire [13:0]       rd_vblg_4 ;
wire [13:0]       rd_vblg_5 ;
wire [13:0]       rd_vblg_6 ;
wire [13:0]       rd_vblg_7 ;
wire [13:0]       rd_vblg_8 ;
wire [13:0]       rd_vblg_9 ;
wire [13:0]       rd_vblg_10;
wire [13:0]       rd_vblg_11;
wire [13:0]       rd_vblg_12;
wire [13:0]       rd_vblg_13;
wire [13:0]       rd_vblg_14;
wire [13:0]       rd_vblg_15;
wire [13:0]       rd_vblg_16;

assign LBG_start=VQ_start;

LBG_frame_13 LBG_frame_13(
.clk        (clk      ),           
.rst_n      (rst_n    ),        
.LBG_start  (LBG_start),
.LBG_finsh  (LBG_finsh),            
.LBG_ADDR   (LBG_rd_addr_1 ),    
.LBG_DATA   (LBG_rd_data_1 ),  

.rd_addr_1 (distance_CNT_1),
.rd_addr_2 (distance_CNT_1),
.rd_addr_3 (distance_CNT_1),
.rd_addr_4 (distance_CNT_1),
.rd_addr_5 (distance_CNT_1),
.rd_addr_6 (distance_CNT_1),
.rd_addr_7 (distance_CNT_1),
.rd_addr_8 (distance_CNT_1),
.rd_addr_9 (distance_CNT_1),
.rd_addr_10(distance_CNT_1),
.rd_addr_11(distance_CNT_1),
.rd_addr_12(distance_CNT_1),
.rd_addr_13(distance_CNT_1),
.rd_addr_14(distance_CNT_1),
.rd_addr_15(distance_CNT_1),
.rd_addr_16(distance_CNT_1),
            
.rd_vblg_1 (rd_vblg_1 ),
.rd_vblg_2 (rd_vblg_2 ),
.rd_vblg_3 (rd_vblg_3 ),
.rd_vblg_4 (rd_vblg_4 ),
.rd_vblg_5 (rd_vblg_5 ),
.rd_vblg_6 (rd_vblg_6 ),
.rd_vblg_7 (rd_vblg_7 ),
.rd_vblg_8 (rd_vblg_8 ),
.rd_vblg_9 (rd_vblg_9 ),
.rd_vblg_10(rd_vblg_10),
.rd_vblg_11(rd_vblg_11),
.rd_vblg_12(rd_vblg_12),
.rd_vblg_13(rd_vblg_13),
.rd_vblg_14(rd_vblg_14),
.rd_vblg_15(rd_vblg_15),
.rd_vblg_16(rd_vblg_16)   

);
reg LBG_frame_13_genxing_finsh;

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        LBG_frame_13_genxing_finsh <= 'd0;
    end
    else if(LBG_start) begin
        LBG_frame_13_genxing_finsh <= 'd0;
    end
    else if(LBG_finsh) begin
        LBG_frame_13_genxing_finsh <= 'd1;
    end
    else begin
        LBG_frame_13_genxing_finsh <= LBG_frame_13_genxing_finsh;
    end
end
/************************************************************************************/

wire distance_start/*synthesis PAP_MARK_DEBUG="1"*/;
wire distance_start_1;
reg distance_start_2;

wire distance_finsh;

assign distance_start_1=(MFCC_frame_13_genxing_finsh&&LBG_frame_13_genxing_finsh)?'d1:'d0;

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        distance_start_2 <= 'd0;
    end
    else begin
        distance_start_2 <= distance_start_1;
    end
end

assign distance_start=(distance_start_1&&!distance_start_2)?'d1:'d0;


wire [31:0]  distance_DATA_1   ;
wire [31:0]  distance_DATA_2  ;
wire [31:0]  distance_DATA_3  ;
wire [31:0]  distance_DATA_4  ;
wire [31:0]  distance_DATA_5  ;
wire [31:0]  distance_DATA_6  ;
wire [31:0]  distance_DATA_7  ;
wire [31:0]  distance_DATA_8  ;
wire [31:0]  distance_DATA_9  ;
wire [31:0]  distance_DATA_10 ;
wire [31:0]  distance_DATA_11 ;
wire [31:0]  distance_DATA_12 ;
wire [31:0]  distance_DATA_13 ;
wire [31:0]  distance_DATA_14 ;
wire [31:0]  distance_DATA_15 ;
wire [31:0]  distance_DATA_16 ;

wire           distance_EN_1 ;
wire           distance_EN_2 ;
wire           distance_EN_3 ;
wire           distance_EN_4 ;
wire           distance_EN_5 ;
wire           distance_EN_6 ;
wire           distance_EN_7 ;
wire           distance_EN_8 ;
wire           distance_EN_9 ;
wire           distance_EN_10;
wire           distance_EN_11;
wire           distance_EN_12;
wire           distance_EN_13;
wire           distance_EN_14;
wire           distance_EN_15;
wire           distance_EN_16;

wire [31:0]   distance_DATA_1_1 /*synthesis PAP_MARK_DEBUG="1"*/  ;
wire [31:0]   distance_DATA_2_1 /*synthesis PAP_MARK_DEBUG="1"*/ ;
wire [31:0]   distance_DATA_3_1  ;
wire [31:0]   distance_DATA_4_1  ;
wire [31:0]   distance_DATA_5_1  ;
wire [31:0]   distance_DATA_6_1  ;
wire [31:0]   distance_DATA_7_1  ;
wire [31:0]   distance_DATA_8_1  ;
wire [31:0]   distance_DATA_9_1  ;
wire [31:0]  distance_DATA_10_1 ;
wire [31:0]  distance_DATA_11_1 ;
wire [31:0]  distance_DATA_12_1 ;
wire [31:0]  distance_DATA_13_1 ;
wire [31:0]  distance_DATA_14_1 ;
wire [31:0]  distance_DATA_15_1 ;
wire [31:0]  distance_DATA_16_1 ;

assign  distance_DATA_1_1=distance_DATA_1;
assign  distance_DATA_2_1=distance_DATA_2;
assign  distance_DATA_3_1=((CNT_FOR=='d1))?32'hffffffff:distance_DATA_3;
assign  distance_DATA_4_1=((CNT_FOR=='d1))?32'hffffffff:distance_DATA_4;
assign  distance_DATA_5_1=((CNT_FOR=='d1)||(CNT_FOR=='d2))?32'hffffffff:distance_DATA_5 ;
assign  distance_DATA_6_1=((CNT_FOR=='d1)||(CNT_FOR=='d2))?32'hffffffff:distance_DATA_6 ;
assign  distance_DATA_7_1=((CNT_FOR=='d1)||(CNT_FOR=='d2))?32'hffffffff:distance_DATA_7 ;
assign  distance_DATA_8_1=((CNT_FOR=='d1)||(CNT_FOR=='d2))?32'hffffffff:distance_DATA_8 ;
assign  distance_DATA_9_1=((CNT_FOR=='d1)||(CNT_FOR=='d2)||(CNT_FOR=='d3))?32'hffffffff:distance_DATA_9 ;
assign distance_DATA_10_1=((CNT_FOR=='d1)||(CNT_FOR=='d2)||(CNT_FOR=='d3))?32'hffffffff:distance_DATA_10;
assign distance_DATA_11_1=((CNT_FOR=='d1)||(CNT_FOR=='d2)||(CNT_FOR=='d3))?32'hffffffff:distance_DATA_11;
assign distance_DATA_12_1=((CNT_FOR=='d1)||(CNT_FOR=='d2)||(CNT_FOR=='d3))?32'hffffffff:distance_DATA_12;
assign distance_DATA_13_1=((CNT_FOR=='d1)||(CNT_FOR=='d2)||(CNT_FOR=='d3))?32'hffffffff:distance_DATA_13;
assign distance_DATA_14_1=((CNT_FOR=='d1)||(CNT_FOR=='d2)||(CNT_FOR=='d3))?32'hffffffff:distance_DATA_14;
assign distance_DATA_15_1=((CNT_FOR=='d1)||(CNT_FOR=='d2)||(CNT_FOR=='d3))?32'hffffffff:distance_DATA_15;
assign distance_DATA_16_1=((CNT_FOR=='d1)||(CNT_FOR=='d2)||(CNT_FOR=='d3))?32'hffffffff:distance_DATA_16;


distance_16 distance_16(
.clk               (clk      ),           
.rst_n             (rst_n    ),    
.distance_start    (distance_start),
.distance_finsh    (distance_finsh),
.distance_CNT      (distance_CNT),
.MFCCS13           (MFCCS13_rd_13_DATA),
.vblg1             (rd_vblg_1 ),
.vblg2             (rd_vblg_2 ),
.vblg3             (rd_vblg_3 ),
.vblg4             (rd_vblg_4 ),
.vblg5             (rd_vblg_5 ),
.vblg6             (rd_vblg_6 ),
.vblg7             (rd_vblg_7 ),
.vblg8             (rd_vblg_8 ),
.vblg9             (rd_vblg_9 ),
.vblg10            (rd_vblg_10),
.vblg11            (rd_vblg_11),
.vblg12            (rd_vblg_12),
.vblg13            (rd_vblg_13),
.vblg14            (rd_vblg_14),
.vblg15            (rd_vblg_15),
.vblg16            (rd_vblg_16),
.distance_DATA_1   ( distance_DATA_1 ),
.distance_DATA_2   ( distance_DATA_2 ),
.distance_DATA_3   ( distance_DATA_3 ),
.distance_DATA_4   ( distance_DATA_4 ),
.distance_DATA_5   ( distance_DATA_5 ),
.distance_DATA_6   ( distance_DATA_6 ),
.distance_DATA_7   ( distance_DATA_7 ),
.distance_DATA_8   ( distance_DATA_8 ),
.distance_DATA_9   ( distance_DATA_9 ),
.distance_DATA_10  (distance_DATA_10),
.distance_DATA_11  (distance_DATA_11),
.distance_DATA_12  (distance_DATA_12),
.distance_DATA_13  (distance_DATA_13),
.distance_DATA_14  (distance_DATA_14),
.distance_DATA_15  (distance_DATA_15),
.distance_DATA_16  (distance_DATA_16),
.distance_EN_1     ( distance_EN_1 ),
.distance_EN_2     ( distance_EN_2 ),
.distance_EN_3     ( distance_EN_3 ),
.distance_EN_4     ( distance_EN_4 ),
.distance_EN_5     ( distance_EN_5 ),
.distance_EN_6     ( distance_EN_6 ),
.distance_EN_7     ( distance_EN_7 ),
.distance_EN_8     ( distance_EN_8 ),
.distance_EN_9     ( distance_EN_9 ),
.distance_EN_10    ( distance_EN_10),
.distance_EN_11    ( distance_EN_11),
.distance_EN_12    ( distance_EN_12),
.distance_EN_13    ( distance_EN_13),
.distance_EN_14    ( distance_EN_14),
.distance_EN_15    ( distance_EN_15),
.distance_EN_16    ( distance_EN_16)
);




MIN #(
   .DATA_WIDTH (32)
)MIN1
(
.clk               (clk               ),         
.rst_n             (rst_n             ),
.CNT_FOR           (           ),

.distance_DATA1    ( distance_DATA_1_1   ),  
.distance_DATA_2   ( distance_DATA_2_1 ),                       
.distance_DATA_3   ( distance_DATA_3_1 ),                      
.distance_DATA_4   ( distance_DATA_4_1 ),                     
.distance_DATA_5   ( distance_DATA_5_1 ),  
.distance_DATA_6   ( distance_DATA_6_1 ),
.distance_DATA_7   ( distance_DATA_7_1 ),  
.distance_DATA_8   ( distance_DATA_8_1 ),  
.distance_DATA_9   ( distance_DATA_9_1 ),  
.distance_DATA_10  (distance_DATA_10_1 ), 
.distance_DATA_11  (distance_DATA_11_1 ),   
.distance_DATA_12  (distance_DATA_12_1 ),   
.distance_DATA_13  (distance_DATA_13_1 ),  
.distance_DATA_14  (distance_DATA_14_1 ),  
.distance_DATA_15  (distance_DATA_15_1 ), 
.distance_DATA_16  (distance_DATA_16_1 ),  
 
.distance_EN_1     ( distance_EN_1    ),                      
.distance_EN_2     ( distance_EN_2    ), 
.distance_EN_3     ( distance_EN_3    ),    
.distance_EN_4     ( distance_EN_4    ), 
.distance_EN_5     ( distance_EN_5    ),    
.distance_EN_6     ( distance_EN_6    ),  
.distance_EN_7     ( distance_EN_7    ),   
.distance_EN_8     ( distance_EN_8    ),  
.distance_EN_9     ( distance_EN_9    ),  
.distance_EN_10    ( distance_EN_10   ),  
.distance_EN_11    ( distance_EN_11   ), 
.distance_EN_12    ( distance_EN_12   ),  
.distance_EN_13    ( distance_EN_13   ), 
.distance_EN_14    ( distance_EN_14   ),  
.distance_EN_15    ( distance_EN_15   ),  
.distance_EN_16    ( distance_EN_16   ),
.MIN_1_1           (  MIN                ),
.MIN_1_1_i         (  MIN_i             ),
.MIN_1_1_en        (  MIN_EN            )
   );

assign Frams_Number_whlie=(MIN_EN&&Frams_Number_CNT<DCT_ADDR)?'d1:'d0;
assign VQ_finsh=(MIN_EN&&Frams_Number_CNT==DCT_ADDR)?'d1:'d0;


always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||VQ_start)begin
        D <= 'd0;
    end
    else if(MIN_EN) begin
        D <= D+MIN;
    end
    else begin
        D <= D;
    end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        D_en <= 'd0;
    end
    else begin
        D_en <= MIN_EN;
    end
end
endmodule