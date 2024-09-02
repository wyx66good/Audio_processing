// -----------------------------------------------------------------------------
// Author : 3056710696@qq.com
// File   : FIR.v
// Create : 2024-03-08 16:32:09
// Revise : 2024-04-01 20:20:50
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
module FIR(
  input   wire        clk,  //输入的系统时钟
//  input   wire        clk_sig,//移位时钟
  input   wire        rst_n, //低电平有效
  input   wire signed [15:0] FIR_in, //待滤波的数据
  output  reg  signed [15:0] FIR_out, //滤波后数据
  output  reg          valid_flag
  );



//中间变量，用来存储滤波器卷积的中间值
reg signed [15:0]    delay_pipeline1;
reg signed [15:0]    delay_pipeline2;
reg signed [15:0]    delay_pipeline3;
reg signed [15:0]    delay_pipeline4;
reg signed [15:0]    delay_pipeline5;
reg signed [15:0]    delay_pipeline6;
reg signed [15:0]    delay_pipeline7;
reg signed [15:0]    delay_pipeline8;
reg signed [15:0]    delay_pipeline9;
reg signed [15:0]    delay_pipeline10;
reg signed [15:0]    delay_pipeline11;
reg signed [15:0]    delay_pipeline12;
reg signed [15:0]    delay_pipeline13;
reg signed [15:0]    delay_pipeline14;
reg signed [15:0]    delay_pipeline15;
reg signed [15:0]    delay_pipeline16;
reg signed [15:0]    delay_pipeline17;
reg signed [15:0]    delay_pipeline18;
reg signed [15:0]    delay_pipeline19;
reg signed [15:0]    delay_pipeline20;
reg signed [15:0]    delay_pipeline21;
reg signed [15:0]    delay_pipeline22;
reg signed [15:0]    delay_pipeline23;
reg signed [15:0]    delay_pipeline24;
reg signed [15:0]    delay_pipeline25;
reg signed [15:0]    delay_pipeline26;
reg signed [15:0]    delay_pipeline27;
reg signed [15:0]    delay_pipeline28;
reg signed [15:0]    delay_pipeline29;
reg signed [15:0]    delay_pipeline30;
reg signed [15:0]    delay_pipeline31;
reg signed [15:0]    delay_pipeline32;
reg signed [15:0]    delay_pipeline33;
reg signed [15:0]    delay_pipeline34;
reg signed [15:0]    delay_pipeline35;
reg signed [15:0]    delay_pipeline36;
reg signed [15:0]    delay_pipeline37;
reg signed [15:0]    delay_pipeline38;
reg signed [15:0]    delay_pipeline39;
reg signed [15:0]    delay_pipeline40;
reg signed [15:0]    delay_pipeline41;
reg signed [15:0]    delay_pipeline42;
reg signed [15:0]    delay_pipeline43;
reg signed [15:0]    delay_pipeline44;
reg signed [15:0]    delay_pipeline45;
reg signed [15:0]    delay_pipeline46;
reg signed [15:0]    delay_pipeline47;
reg signed [15:0]    delay_pipeline48;
reg signed [15:0]    delay_pipeline49;
reg signed [15:0]    delay_pipeline50;
reg signed [15:0]    delay_pipeline51;
reg signed [15:0]    delay_pipeline52;
reg signed [15:0]    delay_pipeline53;
reg signed [15:0]    delay_pipeline54;
reg signed [15:0]    delay_pipeline55;
reg signed [15:0]    delay_pipeline56;
reg signed [15:0]    delay_pipeline57;
reg signed [15:0]    delay_pipeline58;
reg signed [15:0]    delay_pipeline59;
reg signed [15:0]    delay_pipeline60;
reg signed [15:0]    delay_pipeline61;
reg signed [15:0]    delay_pipeline62;
reg signed [15:0]    delay_pipeline63;
reg signed [15:0]    delay_pipeline64;
reg signed [15:0]    delay_pipeline65;
reg signed [15:0]    delay_pipeline66;
reg signed [15:0]    delay_pipeline67;
reg signed [15:0]    delay_pipeline68;
reg signed [15:0]    delay_pipeline69;
reg signed [15:0]    delay_pipeline70;
reg signed [15:0]    delay_pipeline71;
reg signed [15:0]    delay_pipeline72;
reg signed [15:0]    delay_pipeline73;
reg signed [15:0]    delay_pipeline74;
reg signed [15:0]    delay_pipeline75;
reg signed [15:0]    delay_pipeline76;
reg signed [15:0]    delay_pipeline77;
reg signed [15:0]    delay_pipeline78;
reg signed [15:0]    delay_pipeline79;
reg signed [15:0]    delay_pipeline80;
reg signed [15:0]    delay_pipeline81;
reg signed [15:0]    delay_pipeline82;
reg signed [15:0]    delay_pipeline83;
reg signed [15:0]    delay_pipeline84;
reg signed [15:0]    delay_pipeline85;
reg signed [15:0]    delay_pipeline86;
reg signed [15:0]    delay_pipeline87;
reg signed [15:0]    delay_pipeline88;
reg signed [15:0]    delay_pipeline89;
reg signed [15:0]    delay_pipeline90;
reg signed [15:0]    delay_pipeline91;
reg signed [15:0]    delay_pipeline92;
reg signed [15:0]    delay_pipeline93;
reg signed [15:0]    delay_pipeline94;
reg signed [15:0]    delay_pipeline95;
reg signed [15:0]    delay_pipeline96;
reg signed [15:0]    delay_pipeline97;
reg signed [15:0]    delay_pipeline98;
reg signed [15:0]    delay_pipeline99;
reg signed [15:0]    delay_pipeline100;
reg signed [15:0]    delay_pipeline101;
reg signed [15:0]    delay_pipeline102;
reg signed [15:0]    delay_pipeline103;
reg signed [15:0]    delay_pipeline104;
reg signed [15:0]    delay_pipeline105;
reg signed [15:0]    delay_pipeline106;
reg signed [15:0]    delay_pipeline107;
reg signed [15:0]    delay_pipeline108;
reg signed [15:0]    delay_pipeline109;
reg signed [15:0]    delay_pipeline110;
reg signed [15:0]    delay_pipeline111;
reg signed [15:0]    delay_pipeline112;
reg signed [15:0]    delay_pipeline113;
reg signed [15:0]    delay_pipeline114;
reg signed [15:0]    delay_pipeline115;
reg signed [15:0]    delay_pipeline116;
reg signed [15:0]    delay_pipeline117;
reg signed [15:0]    delay_pipeline118;
reg signed [15:0]    delay_pipeline119;
reg signed [15:0]    delay_pipeline120;
reg signed [15:0]    delay_pipeline121;
reg signed [15:0]    delay_pipeline122;
reg signed [15:0]    delay_pipeline123;
reg signed [15:0]    delay_pipeline124;
reg signed [15:0]    delay_pipeline125;
reg signed [15:0]    delay_pipeline126;
reg signed [15:0]    delay_pipeline127;
reg signed [15:0]    delay_pipeline128;
reg signed [15:0]    delay_pipeline129;
reg signed [15:0]    delay_pipeline130;
reg signed [15:0]    delay_pipeline131;
reg signed [15:0]    delay_pipeline132;
reg signed [15:0]    delay_pipeline133;
reg signed [15:0]    delay_pipeline134;
reg signed [15:0]    delay_pipeline135;
reg signed [15:0]    delay_pipeline136;
reg signed [15:0]    delay_pipeline137;
reg signed [15:0]    delay_pipeline138;
reg signed [15:0]    delay_pipeline139;
reg signed [15:0]    delay_pipeline140;
reg signed [15:0]    delay_pipeline141;
reg signed [15:0]    delay_pipeline142;
reg signed [15:0]    delay_pipeline143;
reg signed [15:0]    delay_pipeline144;
reg signed [15:0]    delay_pipeline145;
reg signed [15:0]    delay_pipeline146;
reg signed [15:0]    delay_pipeline147;
reg signed [15:0]    delay_pipeline148;
reg signed [15:0]    delay_pipeline149;
reg signed [15:0]    delay_pipeline150;
reg signed [15:0]    delay_pipeline151;
reg signed [15:0]    delay_pipeline152;
reg signed [15:0]    delay_pipeline153;
reg signed [15:0]    delay_pipeline154;
reg signed [15:0]    delay_pipeline155;
reg signed [15:0]    delay_pipeline156;
reg signed [15:0]    delay_pipeline157;
reg signed [15:0]    delay_pipeline158;
reg signed [15:0]    delay_pipeline159;
reg signed [15:0]    delay_pipeline160;
reg signed [15:0]    delay_pipeline161;
reg signed [15:0]    delay_pipeline162;
reg signed [15:0]    delay_pipeline163;
reg signed [15:0]    delay_pipeline164;
reg signed [15:0]    delay_pipeline165;
reg signed [15:0]    delay_pipeline166;
reg signed [15:0]    delay_pipeline167;
reg signed [15:0]    delay_pipeline168;
reg signed [15:0]    delay_pipeline169;
reg signed [15:0]    delay_pipeline170;
reg signed [15:0]    delay_pipeline171;
reg signed [15:0]    delay_pipeline172;
reg signed [15:0]    delay_pipeline173;
reg signed [15:0]    delay_pipeline174;
reg signed [15:0]    delay_pipeline175;
reg signed [15:0]    delay_pipeline176;
reg signed [15:0]    delay_pipeline177;
reg signed [15:0]    delay_pipeline178;
reg signed [15:0]    delay_pipeline179;
reg signed [15:0]    delay_pipeline180;
reg signed [15:0]    delay_pipeline181;
reg signed [15:0]    delay_pipeline182;
reg signed [15:0]    delay_pipeline183;
reg signed [15:0]    delay_pipeline184;
reg signed [15:0]    delay_pipeline185;
reg signed [15:0]    delay_pipeline186;
reg signed [15:0]    delay_pipeline187;
reg signed [15:0]    delay_pipeline188;
reg signed [15:0]    delay_pipeline189;
reg signed [15:0]    delay_pipeline190;
reg signed [15:0]    delay_pipeline191;
reg signed [15:0]    delay_pipeline192;
reg signed [15:0]    delay_pipeline193;
reg signed [15:0]    delay_pipeline194;
reg signed [15:0]    delay_pipeline195;
reg signed [15:0]    delay_pipeline196;
reg signed [15:0]    delay_pipeline197;
reg signed [15:0]    delay_pipeline198;
reg signed [15:0]    delay_pipeline199;



 //滤波器系数,十六位量化后的结果,n阶滤波器有n个系数
wire signed [15:0] coeff0 = 16'h0542; 
wire signed [15:0] coeff1 = 16'h0521;
wire signed [15:0] coeff2 = 16'h0504;
wire signed [15:0] coeff3 = 16'h04e7;
wire signed [15:0] coeff4 = 16'h04cc;
wire signed [15:0] coeff5 = 16'h04b0;
wire signed [15:0] coeff6 = 16'h0494;
wire signed [15:0] coeff7 = 16'h0474;
wire signed [15:0] coeff8 = 16'h0452;
wire signed [15:0] coeff9 = 16'h042a;
wire signed [15:0] coeff10 =  16'h03fc; 
wire signed [15:0] coeff11 =  16'h03c6;
wire signed [15:0] coeff12 =  16'h0387;
wire signed [15:0] coeff13 =  16'h033d;
wire signed [15:0] coeff14 =  16'h02e7;
wire signed [15:0] coeff15 =  16'h0284;
wire signed [15:0] coeff16 =  16'h0212;
wire signed [15:0] coeff17 =  16'h0190;
wire signed [15:0] coeff18 =  16'h00fe;
wire signed [15:0] coeff19 =  16'h0059;
wire signed [15:0] coeff20 =  16'hffa2; 
wire signed [15:0] coeff21 =  16'hfed7;
wire signed [15:0] coeff22 =  16'hfdf9;
wire signed [15:0] coeff23 =  16'hfd06;
wire signed [15:0] coeff24 =  16'hfbfe;
wire signed [15:0] coeff25 =  16'hfae3;
wire signed [15:0] coeff26 =  16'hf9b4;
wire signed [15:0] coeff27 =  16'hf871;
wire signed [15:0] coeff28 =  16'hf71b;
wire signed [15:0] coeff29 =  16'hf5b4;
wire signed [15:0] coeff30 =  16'hf43d; 
wire signed [15:0] coeff31 =  16'hf2b7;
wire signed [15:0] coeff32 =  16'hf123;
wire signed [15:0] coeff33 =  16'hef85;
wire signed [15:0] coeff34 =  16'heddd;
wire signed [15:0] coeff35 =  16'hec2e;
wire signed [15:0] coeff36 =  16'hea7c;
wire signed [15:0] coeff37 =  16'he8c7;
wire signed [15:0] coeff38 =  16'he715;
wire signed [15:0] coeff39 =  16'he566;
wire signed [15:0] coeff40 =  16'he3bf; 
wire signed [15:0] coeff41 =  16'he223;
wire signed [15:0] coeff42 =  16'he095;
wire signed [15:0] coeff43 =  16'hdf19;
wire signed [15:0] coeff44 =  16'hddb1;
wire signed [15:0] coeff45 =  16'hdc62;
wire signed [15:0] coeff46 =  16'hdb2e;
wire signed [15:0] coeff47 =  16'hda1a;
wire signed [15:0] coeff48 =  16'hd927;
wire signed [15:0] coeff49 =  16'hd85b;
wire signed [15:0] coeff50 =  16'hd7b6; 
wire signed [15:0] coeff51 =  16'hd73d;
wire signed [15:0] coeff52 =  16'hd6f1;
wire signed [15:0] coeff53 =  16'hd6d6;
wire signed [15:0] coeff54 =  16'hd6ee;
wire signed [15:0] coeff55 =  16'hd73a;
wire signed [15:0] coeff56 =  16'hd7bc;
wire signed [15:0] coeff57 =  16'hd876;
wire signed [15:0] coeff58 =  16'hd968;
wire signed [15:0] coeff59 =  16'hda94;
wire signed [15:0] coeff60 =  16'hdbf9; 
wire signed [15:0] coeff61 =  16'hdd98;
wire signed [15:0] coeff62 =  16'hdf70;
wire signed [15:0] coeff63 =  16'he180;
wire signed [15:0] coeff64 =  16'he3c8;
wire signed [15:0] coeff65 =  16'he646;
wire signed [15:0] coeff66 =  16'he8f8;
wire signed [15:0] coeff67 =  16'hebdc;
wire signed [15:0] coeff68 =  16'heef0;
wire signed [15:0] coeff69 =  16'hf22f;
wire signed [15:0] coeff70 =  16'hf598; 
wire signed [15:0] coeff71 =  16'hf926;
wire signed [15:0] coeff72 =  16'hfcd7;
wire signed [15:0] coeff73 =  16'h00a4;
wire signed [15:0] coeff74 =  16'h048b;
wire signed [15:0] coeff75 =  16'h0886;
wire signed [15:0] coeff76 =  16'h0c91;
wire signed [15:0] coeff77 =  16'h10a7;
wire signed [15:0] coeff78 =  16'h14c2;
wire signed [15:0] coeff79 =  16'h18dd;
wire signed [15:0] coeff80 =  16'h1cf3; 
wire signed [15:0] coeff81 =  16'h20ff;
wire signed [15:0] coeff82 =  16'h24fb;
wire signed [15:0] coeff83 =  16'h28e2;
wire signed [15:0] coeff84 =  16'h2cae;
wire signed [15:0] coeff85 =  16'h305b;
wire signed [15:0] coeff86 =  16'h33e2;
wire signed [15:0] coeff87 =  16'h3740;
wire signed [15:0] coeff88 =  16'h3a70;
wire signed [15:0] coeff89 =  16'h3d6d;
wire signed [15:0] coeff90 =  16'h4032; 
wire signed [15:0] coeff91 =  16'h42bc;
wire signed [15:0] coeff92 =  16'h4508;
wire signed [15:0] coeff93 =  16'h4712;
wire signed [15:0] coeff94 =  16'h48d7;
wire signed [15:0] coeff95 =  16'h4a54;
wire signed [15:0] coeff96 =  16'h4b88;
wire signed [15:0] coeff97 =  16'h4c70;
wire signed [15:0] coeff98 =  16'h4d0c;
wire signed [15:0] coeff99 =  16'h4d5a;
wire signed [15:0] coeff100 = 16'h4d5a; 
wire signed [15:0] coeff101 = 16'h4d0c;
wire signed [15:0] coeff102 = 16'h4c70;
wire signed [15:0] coeff103 = 16'h4b88;
wire signed [15:0] coeff104 = 16'h4a54;
wire signed [15:0] coeff105 = 16'h48d7;
wire signed [15:0] coeff106 = 16'h4712;
wire signed [15:0] coeff107 = 16'h4508;
wire signed [15:0] coeff108 = 16'h42bc;
wire signed [15:0] coeff109 = 16'h4032;
wire signed [15:0] coeff110 = 16'h3d6d; 
wire signed [15:0] coeff111 = 16'h3a70;
wire signed [15:0] coeff112 = 16'h3740;
wire signed [15:0] coeff113 = 16'h33e2;
wire signed [15:0] coeff114 = 16'h305b;
wire signed [15:0] coeff115 = 16'h2cae;
wire signed [15:0] coeff116 = 16'h28e2;
wire signed [15:0] coeff117 = 16'h24fb;
wire signed [15:0] coeff118 = 16'h20ff;
wire signed [15:0] coeff119 = 16'h1cf3;
wire signed [15:0] coeff120 = 16'h18dd; 
wire signed [15:0] coeff121 = 16'h14c2;
wire signed [15:0] coeff122 = 16'h10a7;
wire signed [15:0] coeff123 = 16'h0c91;
wire signed [15:0] coeff124 = 16'h0886;
wire signed [15:0] coeff125 = 16'h048b;
wire signed [15:0] coeff126 = 16'h00a4;
wire signed [15:0] coeff127 = 16'hfcd7;
wire signed [15:0] coeff128 = 16'hf926;
wire signed [15:0] coeff129 = 16'hf598;
wire signed [15:0] coeff130 = 16'hf22f; 
wire signed [15:0] coeff131 = 16'heef0;
wire signed [15:0] coeff132 = 16'hebdc;
wire signed [15:0] coeff133 = 16'he8f8;
wire signed [15:0] coeff134 = 16'he646;
wire signed [15:0] coeff135 = 16'he3c8;
wire signed [15:0] coeff136 = 16'he180;
wire signed [15:0] coeff137 = 16'hdf70;
wire signed [15:0] coeff138 = 16'hdd98;
wire signed [15:0] coeff139 = 16'hdbf9;
wire signed [15:0] coeff140 = 16'hda94; 
wire signed [15:0] coeff141 = 16'hd968;
wire signed [15:0] coeff142 = 16'hd876;
wire signed [15:0] coeff143 = 16'hd7bc;
wire signed [15:0] coeff144 = 16'hd73a;
wire signed [15:0] coeff145 = 16'hd6ee;
wire signed [15:0] coeff146 = 16'hd6d6;
wire signed [15:0] coeff147 = 16'hd6f1;
wire signed [15:0] coeff148 = 16'hd73d;
wire signed [15:0] coeff149 = 16'hd7b6;
wire signed [15:0] coeff150 = 16'hd85b; 
wire signed [15:0] coeff151 = 16'hd927;
wire signed [15:0] coeff152 = 16'hda1a;
wire signed [15:0] coeff153 = 16'hdb2e;
wire signed [15:0] coeff154 = 16'hdc62;
wire signed [15:0] coeff155 = 16'hddb1;
wire signed [15:0] coeff156 = 16'hdf19;
wire signed [15:0] coeff157 = 16'he095;
wire signed [15:0] coeff158 = 16'he223;
wire signed [15:0] coeff159 = 16'he3bf;
wire signed [15:0] coeff160 = 16'he566; 
wire signed [15:0] coeff161 = 16'he715;
wire signed [15:0] coeff162 = 16'he8c7;
wire signed [15:0] coeff163 = 16'hea7c;
wire signed [15:0] coeff164 = 16'hec2e;
wire signed [15:0] coeff165 = 16'heddd;
wire signed [15:0] coeff166 = 16'hef85;
wire signed [15:0] coeff167 = 16'hf123;
wire signed [15:0] coeff168 = 16'hf2b7;
wire signed [15:0] coeff169 = 16'hf43d;
wire signed [15:0] coeff170 = 16'hf5b4; 
wire signed [15:0] coeff171 = 16'hf71b;
wire signed [15:0] coeff172 = 16'hf871;
wire signed [15:0] coeff173 = 16'hf9b4;
wire signed [15:0] coeff174 = 16'hfae3;
wire signed [15:0] coeff175 = 16'hfbfe;
wire signed [15:0] coeff176 = 16'hfd06;
wire signed [15:0] coeff177 = 16'hfdf9;
wire signed [15:0] coeff178 = 16'hfed7;
wire signed [15:0] coeff179 = 16'hffa2;
wire signed [15:0] coeff180 = 16'h0059; 
wire signed [15:0] coeff181 = 16'h00fe;
wire signed [15:0] coeff182 = 16'h0190;
wire signed [15:0] coeff183 = 16'h0212;
wire signed [15:0] coeff184 = 16'h0284;
wire signed [15:0] coeff185 = 16'h02e7;
wire signed [15:0] coeff186 = 16'h033d;
wire signed [15:0] coeff187 = 16'h0387;
wire signed [15:0] coeff188 = 16'h03c6;
wire signed [15:0] coeff189 = 16'h03fc;
wire signed [15:0] coeff190 = 16'h042a; 
wire signed [15:0] coeff191 = 16'h0452;
wire signed [15:0] coeff192 = 16'h0474;
wire signed [15:0] coeff193 = 16'h0494;
wire signed [15:0] coeff194 = 16'h04b0;
wire signed [15:0] coeff195 = 16'h04cc;
wire signed [15:0] coeff196 = 16'h04e7;
wire signed [15:0] coeff197 = 16'h0504;
wire signed [15:0] coeff198 = 16'h0521;
wire signed [15:0] coeff199 = 16'h0542;


/*计数值控制当前时刻乘法,10阶定义4位*/
reg  [7:0] count;

/*乘数与被乘数，根据计数值来指定*/
reg  signed [15:0] mul_a;
reg  signed [15:0] mul_b;
wire  signed [31:0] mul_p;

reg signed [37:0] out_temp/*synthesis PAP_MARK_DEBUG="1"*/; 


/*根据时钟信号进行切换寄存器移位，依次进行卷积。*/
always @(posedge clk or negedge rst_n) begin
  if (rst_n == 1'b0) begin
    // reset
    delay_pipeline1   <= 'd0;
    delay_pipeline2   <= 'd0;
    delay_pipeline3   <= 'd0;
    delay_pipeline4   <= 'd0;
    delay_pipeline5   <= 'd0;
    delay_pipeline6   <= 'd0;
    delay_pipeline7   <= 'd0;
    delay_pipeline8   <= 'd0;
    delay_pipeline9   <= 'd0;
    delay_pipeline10  <= 'd0;
    delay_pipeline11  <= 'd0;
    delay_pipeline12  <= 'd0;
    delay_pipeline13  <= 'd0;
    delay_pipeline14  <= 'd0;
    delay_pipeline15  <= 'd0;
    delay_pipeline16  <= 'd0;
    delay_pipeline17  <= 'd0;
    delay_pipeline18  <= 'd0;
    delay_pipeline19  <= 'd0;
    delay_pipeline20  <= 'd0;
    delay_pipeline21  <= 'd0;
    delay_pipeline22  <= 'd0;
    delay_pipeline23  <= 'd0;
    delay_pipeline24  <= 'd0;
    delay_pipeline25  <= 'd0;
    delay_pipeline26  <= 'd0;
    delay_pipeline27  <= 'd0;
    delay_pipeline28  <= 'd0;
    delay_pipeline29  <= 'd0;
    delay_pipeline30  <= 'd0;
    delay_pipeline31  <= 'd0;
    delay_pipeline32  <= 'd0;
    delay_pipeline33  <= 'd0;
    delay_pipeline34  <= 'd0;
    delay_pipeline35  <= 'd0;
    delay_pipeline36  <= 'd0;
    delay_pipeline37  <= 'd0;
    delay_pipeline38  <= 'd0;
    delay_pipeline39  <= 'd0;
    delay_pipeline40  <= 'd0;
    delay_pipeline41  <= 'd0;
    delay_pipeline42  <= 'd0;
    delay_pipeline43  <= 'd0;
    delay_pipeline44  <= 'd0;
    delay_pipeline45  <= 'd0;
    delay_pipeline46  <= 'd0;
    delay_pipeline47  <= 'd0;
    delay_pipeline48  <= 'd0;
    delay_pipeline49  <= 'd0;
    delay_pipeline50  <= 'd0;
    delay_pipeline51  <= 'd0;
    delay_pipeline52  <= 'd0;
    delay_pipeline53  <= 'd0;
    delay_pipeline54  <= 'd0;
    delay_pipeline55  <= 'd0;
    delay_pipeline56  <= 'd0;
    delay_pipeline57  <= 'd0;
    delay_pipeline58  <= 'd0;
    delay_pipeline59  <= 'd0;
    delay_pipeline60  <= 'd0;
    delay_pipeline61  <= 'd0;
    delay_pipeline62  <= 'd0;
    delay_pipeline63  <= 'd0;
    delay_pipeline64  <= 'd0;
    delay_pipeline65  <= 'd0;
    delay_pipeline66  <= 'd0;
    delay_pipeline67  <= 'd0;
    delay_pipeline68  <= 'd0;
    delay_pipeline69  <= 'd0;
    delay_pipeline70  <= 'd0;
    delay_pipeline71  <= 'd0;
    delay_pipeline72  <= 'd0;
    delay_pipeline73  <= 'd0;
    delay_pipeline74  <= 'd0;
    delay_pipeline75  <= 'd0;
    delay_pipeline76  <= 'd0;
    delay_pipeline77  <= 'd0;
    delay_pipeline78  <= 'd0;
    delay_pipeline79  <= 'd0;
    delay_pipeline80  <= 'd0;
    delay_pipeline81  <= 'd0;
    delay_pipeline82  <= 'd0;
    delay_pipeline83  <= 'd0;
    delay_pipeline84  <= 'd0;
    delay_pipeline85  <= 'd0;
    delay_pipeline86  <= 'd0;
    delay_pipeline87  <= 'd0;
    delay_pipeline88  <= 'd0;
    delay_pipeline89  <= 'd0;
    delay_pipeline90  <= 'd0;
    delay_pipeline91  <= 'd0;
    delay_pipeline92  <= 'd0;
    delay_pipeline93  <= 'd0;
    delay_pipeline94  <= 'd0;
    delay_pipeline95  <= 'd0;
    delay_pipeline96  <= 'd0;
    delay_pipeline97  <= 'd0;
    delay_pipeline98  <= 'd0;
    delay_pipeline99  <= 'd0;
    delay_pipeline100 <= 'd0;
    delay_pipeline101 <= 'd0;
    delay_pipeline102 <= 'd0;
    delay_pipeline103 <= 'd0;
    delay_pipeline104 <= 'd0;
    delay_pipeline105 <= 'd0;
    delay_pipeline106 <= 'd0;
    delay_pipeline107 <= 'd0;
    delay_pipeline108 <= 'd0;
    delay_pipeline109 <= 'd0;
    delay_pipeline110 <= 'd0;
    delay_pipeline111 <= 'd0;
    delay_pipeline112 <= 'd0;
    delay_pipeline113 <= 'd0;
    delay_pipeline114 <= 'd0;
    delay_pipeline115 <= 'd0;
    delay_pipeline116 <= 'd0;
    delay_pipeline117 <= 'd0;
    delay_pipeline118 <= 'd0;
    delay_pipeline119 <= 'd0;
    delay_pipeline120 <= 'd0;
    delay_pipeline121 <= 'd0;
    delay_pipeline122 <= 'd0;
    delay_pipeline123 <= 'd0;
    delay_pipeline124 <= 'd0;
    delay_pipeline125 <= 'd0;
    delay_pipeline126 <= 'd0;
    delay_pipeline127 <= 'd0;
    delay_pipeline128 <= 'd0;
    delay_pipeline129 <= 'd0;
    delay_pipeline130 <= 'd0;
    delay_pipeline131 <= 'd0;
    delay_pipeline132 <= 'd0;
    delay_pipeline133 <= 'd0;
    delay_pipeline134 <= 'd0;
    delay_pipeline135 <= 'd0;
    delay_pipeline136 <= 'd0;
    delay_pipeline137 <= 'd0;
    delay_pipeline138 <= 'd0;
    delay_pipeline139 <= 'd0;
    delay_pipeline140 <= 'd0;
    delay_pipeline141 <= 'd0;
    delay_pipeline142 <= 'd0;
    delay_pipeline143 <= 'd0;
    delay_pipeline144 <= 'd0;
    delay_pipeline145 <= 'd0;
    delay_pipeline146 <= 'd0;
    delay_pipeline147 <= 'd0;
    delay_pipeline148 <= 'd0;
    delay_pipeline149 <= 'd0;
    delay_pipeline150 <= 'd0;
    delay_pipeline151 <= 'd0;
    delay_pipeline152 <= 'd0;
    delay_pipeline153 <= 'd0;
    delay_pipeline154 <= 'd0;
    delay_pipeline155 <= 'd0;
    delay_pipeline156 <= 'd0;
    delay_pipeline157 <= 'd0;
    delay_pipeline158 <= 'd0;
    delay_pipeline159 <= 'd0;
    delay_pipeline160 <= 'd0;
    delay_pipeline161 <= 'd0;
    delay_pipeline162 <= 'd0;
    delay_pipeline163 <= 'd0;
    delay_pipeline164 <= 'd0;
    delay_pipeline165 <= 'd0;
    delay_pipeline166 <= 'd0;
    delay_pipeline167 <= 'd0;
    delay_pipeline168 <= 'd0;
    delay_pipeline169 <= 'd0;
    delay_pipeline170 <= 'd0;
    delay_pipeline171 <= 'd0;
    delay_pipeline172 <= 'd0;
    delay_pipeline173 <= 'd0;
    delay_pipeline174 <= 'd0;
    delay_pipeline175 <= 'd0;
    delay_pipeline176 <= 'd0;
    delay_pipeline177 <= 'd0;
    delay_pipeline178 <= 'd0;
    delay_pipeline179 <= 'd0;
    delay_pipeline180 <= 'd0;
    delay_pipeline181 <= 'd0;
    delay_pipeline182 <= 'd0;
    delay_pipeline183 <= 'd0;
    delay_pipeline184 <= 'd0;
    delay_pipeline185 <= 'd0;
    delay_pipeline186 <= 'd0;
    delay_pipeline187 <= 'd0;
    delay_pipeline188 <= 'd0;
    delay_pipeline189 <= 'd0;
    delay_pipeline190 <= 'd0;
    delay_pipeline191 <= 'd0;
    delay_pipeline192 <= 'd0;
    delay_pipeline193 <= 'd0;
    delay_pipeline194 <= 'd0;
    delay_pipeline195 <= 'd0;
    delay_pipeline196 <= 'd0;
    delay_pipeline197 <= 'd0;
    delay_pipeline198 <= 'd0;
    delay_pipeline199 <= 'd0;
   
  end
  else if (count == 8'b11000111) begin
    delay_pipeline1  <= FIR_in;
    delay_pipeline2  <= delay_pipeline1;
    delay_pipeline3  <= delay_pipeline2;
    delay_pipeline4  <= delay_pipeline3;
    delay_pipeline5  <= delay_pipeline4;
    delay_pipeline6  <= delay_pipeline5;
    delay_pipeline7  <= delay_pipeline6;
    delay_pipeline8  <= delay_pipeline7;
    delay_pipeline9  <= delay_pipeline8;
    delay_pipeline10 <= delay_pipeline9 ;
    delay_pipeline11 <= delay_pipeline10;
    delay_pipeline12 <= delay_pipeline11;
    delay_pipeline13 <= delay_pipeline12;
    delay_pipeline14 <= delay_pipeline13;
    delay_pipeline15 <= delay_pipeline14;
    delay_pipeline16 <= delay_pipeline15;
    delay_pipeline17 <= delay_pipeline16;
    delay_pipeline18 <= delay_pipeline17;
    delay_pipeline19 <= delay_pipeline18;
    delay_pipeline20 <= delay_pipeline19;
    delay_pipeline21 <= delay_pipeline20;
    delay_pipeline22 <= delay_pipeline21;
    delay_pipeline23 <= delay_pipeline22;
    delay_pipeline24 <= delay_pipeline23;
    delay_pipeline25 <= delay_pipeline24;
    delay_pipeline26 <= delay_pipeline25;
    delay_pipeline27 <= delay_pipeline26;
    delay_pipeline28 <= delay_pipeline27;
    delay_pipeline29 <= delay_pipeline28;
    delay_pipeline30 <= delay_pipeline29;
    delay_pipeline31 <= delay_pipeline30;
    delay_pipeline32 <= delay_pipeline31;
    delay_pipeline33 <= delay_pipeline32;
    delay_pipeline34 <= delay_pipeline33;
    delay_pipeline35 <= delay_pipeline34;
    delay_pipeline36 <= delay_pipeline35;
    delay_pipeline37 <= delay_pipeline36;
    delay_pipeline38 <= delay_pipeline37;
    delay_pipeline39 <= delay_pipeline38;
    delay_pipeline40 <= delay_pipeline39;
    delay_pipeline41 <= delay_pipeline40;
    delay_pipeline42 <= delay_pipeline41;
    delay_pipeline43 <= delay_pipeline42;
    delay_pipeline44 <= delay_pipeline43;
    delay_pipeline45 <= delay_pipeline44;
    delay_pipeline46 <= delay_pipeline45;
    delay_pipeline47 <= delay_pipeline46;
    delay_pipeline48 <= delay_pipeline47;
    delay_pipeline49 <= delay_pipeline48;
    delay_pipeline50 <= delay_pipeline49;
    delay_pipeline51 <= delay_pipeline50;
    delay_pipeline52 <= delay_pipeline51;
    delay_pipeline53 <= delay_pipeline52;
    delay_pipeline54 <= delay_pipeline53;
    delay_pipeline55 <= delay_pipeline54;
    delay_pipeline56 <= delay_pipeline55;
    delay_pipeline57 <= delay_pipeline56;
    delay_pipeline58 <= delay_pipeline57;
    delay_pipeline59 <= delay_pipeline58;
    delay_pipeline60 <= delay_pipeline59;
    delay_pipeline61 <= delay_pipeline60;
    delay_pipeline62 <= delay_pipeline61;
    delay_pipeline63 <= delay_pipeline62;
    delay_pipeline64 <= delay_pipeline63;
    delay_pipeline65 <= delay_pipeline64;
    delay_pipeline66 <= delay_pipeline65;
    delay_pipeline67 <= delay_pipeline66;
    delay_pipeline68 <= delay_pipeline67;
    delay_pipeline69 <= delay_pipeline68;
    delay_pipeline70 <= delay_pipeline69;
    delay_pipeline71 <= delay_pipeline70;
    delay_pipeline72 <= delay_pipeline71;
    delay_pipeline73 <= delay_pipeline72;
    delay_pipeline74 <= delay_pipeline73;
    delay_pipeline75 <= delay_pipeline74;
    delay_pipeline76 <= delay_pipeline75;
    delay_pipeline77 <= delay_pipeline76;
    delay_pipeline78 <= delay_pipeline77;
    delay_pipeline79 <= delay_pipeline78;
    delay_pipeline80 <= delay_pipeline79;
    delay_pipeline81 <= delay_pipeline80;
    delay_pipeline82 <= delay_pipeline81;
    delay_pipeline83 <= delay_pipeline82;
    delay_pipeline84 <= delay_pipeline83;
    delay_pipeline85 <= delay_pipeline84;
    delay_pipeline86 <= delay_pipeline85;
    delay_pipeline87 <= delay_pipeline86;
    delay_pipeline88 <= delay_pipeline87;
    delay_pipeline89 <= delay_pipeline88;
    delay_pipeline90 <= delay_pipeline89;
    delay_pipeline91 <= delay_pipeline90;
    delay_pipeline92 <= delay_pipeline91;
    delay_pipeline93 <= delay_pipeline92;
    delay_pipeline94 <= delay_pipeline93;
    delay_pipeline95 <= delay_pipeline94;
    delay_pipeline96 <= delay_pipeline95;
    delay_pipeline97 <= delay_pipeline96;
    delay_pipeline98 <= delay_pipeline97;
    delay_pipeline99 <= delay_pipeline98;
    delay_pipeline100<=delay_pipeline99 ;
    delay_pipeline101<=delay_pipeline100;
    delay_pipeline102<=delay_pipeline101;
    delay_pipeline103<=delay_pipeline102;
    delay_pipeline104<=delay_pipeline103;
    delay_pipeline105<=delay_pipeline104;
    delay_pipeline106<=delay_pipeline105;
    delay_pipeline107<=delay_pipeline106;
    delay_pipeline108<=delay_pipeline107;
    delay_pipeline109<=delay_pipeline108;
    delay_pipeline110<=delay_pipeline109;
    delay_pipeline111<=delay_pipeline110;
    delay_pipeline112<=delay_pipeline111;
    delay_pipeline113<=delay_pipeline112;
    delay_pipeline114<=delay_pipeline113;
    delay_pipeline115<=delay_pipeline114;
    delay_pipeline116<=delay_pipeline115;
    delay_pipeline117<=delay_pipeline116;
    delay_pipeline118<=delay_pipeline117;
    delay_pipeline119<=delay_pipeline118;
    delay_pipeline120<=delay_pipeline119;
    delay_pipeline121<=delay_pipeline120;
    delay_pipeline122<=delay_pipeline121;
    delay_pipeline123<=delay_pipeline122;
    delay_pipeline124<=delay_pipeline123;
    delay_pipeline125<=delay_pipeline124;
    delay_pipeline126<=delay_pipeline125;
    delay_pipeline127<=delay_pipeline126;
    delay_pipeline128<=delay_pipeline127;
    delay_pipeline129<=delay_pipeline128;
    delay_pipeline130<=delay_pipeline129;
    delay_pipeline131<=delay_pipeline130;
    delay_pipeline132<=delay_pipeline131;
    delay_pipeline133<=delay_pipeline132;
    delay_pipeline134<=delay_pipeline133;
    delay_pipeline135<=delay_pipeline134;
    delay_pipeline136<=delay_pipeline135;
    delay_pipeline137<=delay_pipeline136;
    delay_pipeline138<=delay_pipeline137;
    delay_pipeline139<=delay_pipeline138;
    delay_pipeline140<=delay_pipeline139;
    delay_pipeline141<=delay_pipeline140;
    delay_pipeline142<=delay_pipeline141;
    delay_pipeline143<=delay_pipeline142;
    delay_pipeline144<=delay_pipeline143;
    delay_pipeline145<=delay_pipeline144;
    delay_pipeline146<=delay_pipeline145;
    delay_pipeline147<=delay_pipeline146;
    delay_pipeline148<=delay_pipeline147;
    delay_pipeline149<=delay_pipeline148;
    delay_pipeline150<=delay_pipeline149;
    delay_pipeline151<=delay_pipeline150;
    delay_pipeline152<=delay_pipeline151;
    delay_pipeline153<=delay_pipeline152;
    delay_pipeline154<=delay_pipeline153;
    delay_pipeline155<=delay_pipeline154;
    delay_pipeline156<=delay_pipeline155;
    delay_pipeline157<=delay_pipeline156;
    delay_pipeline158<=delay_pipeline157;
    delay_pipeline159<=delay_pipeline158;
    delay_pipeline160<=delay_pipeline159;
    delay_pipeline161<=delay_pipeline160;
    delay_pipeline162<=delay_pipeline161;
    delay_pipeline163<=delay_pipeline162;
    delay_pipeline164<=delay_pipeline163;
    delay_pipeline165<=delay_pipeline164;
    delay_pipeline166<=delay_pipeline165;
    delay_pipeline167<=delay_pipeline166;
    delay_pipeline168<=delay_pipeline167;
    delay_pipeline169<=delay_pipeline168;
    delay_pipeline170<=delay_pipeline169;
    delay_pipeline171<=delay_pipeline170;
    delay_pipeline172<=delay_pipeline171;
    delay_pipeline173<=delay_pipeline172;
    delay_pipeline174<=delay_pipeline173;
    delay_pipeline175<=delay_pipeline174;
    delay_pipeline176<=delay_pipeline175;
    delay_pipeline177<=delay_pipeline176;
    delay_pipeline178<=delay_pipeline177;
    delay_pipeline179<=delay_pipeline178;
    delay_pipeline180<=delay_pipeline179;
    delay_pipeline181<=delay_pipeline180;
    delay_pipeline182<=delay_pipeline181;
    delay_pipeline183<=delay_pipeline182;
    delay_pipeline184<=delay_pipeline183;
    delay_pipeline185<=delay_pipeline184;
    delay_pipeline186<=delay_pipeline185;
    delay_pipeline187<=delay_pipeline186;
    delay_pipeline188<=delay_pipeline187;
    delay_pipeline189<=delay_pipeline188;
    delay_pipeline190<=delay_pipeline189;
    delay_pipeline191<=delay_pipeline190;
    delay_pipeline192<=delay_pipeline191;
    delay_pipeline193<=delay_pipeline192;
    delay_pipeline194<=delay_pipeline193;
    delay_pipeline195<=delay_pipeline194;
    delay_pipeline196<=delay_pipeline195;
    delay_pipeline197<=delay_pipeline196;
    delay_pipeline198<=delay_pipeline197;
    delay_pipeline199<=delay_pipeline198;
  end
end

//根据计数值控制该时刻的乘积对象
always @(posedge clk or negedge rst_n) begin
  if (rst_n == 1'b0) begin
    // reset
    count <= 8'b0;
  end
  else if (count == 8'b11000111) begin
    count <= 'd0;
  end
  else begin
    count <= count + 1'b1;
  end
end



//乘法器复用
assign mul_p = mul_a * mul_b;

always @(posedge clk or negedge rst_n) begin
  if (rst_n == 1'b0) begin
    // reset
    mul_a <= 'd0;
    mul_b <= 'd0;
  end
  else  begin
    case(count)
        8'b00000000 : begin
          mul_a <= coeff0;
          mul_b <= FIR_in; 
        end
        8'b00000001 : begin
          mul_a <= coeff1;
          mul_b <= delay_pipeline1;
        end
        8'b00000010 : begin
          mul_a <= coeff2;
          mul_b <= delay_pipeline2;
        end
        8'b00000011 : begin
          mul_a <= coeff3;
          mul_b <= delay_pipeline3;
        end
        8'b00000100 : begin
          mul_a <= coeff4;
          mul_b <= delay_pipeline4;
        end
        8'b00000101 : begin
          mul_a <= coeff5;
          mul_b <= delay_pipeline5;
        end
        8'b00000110 : begin
          mul_a <= coeff6;
          mul_b <= delay_pipeline6;
        end
        8'b00000111 : begin
          mul_a <= coeff7;
          mul_b <= delay_pipeline7;
        end
        8'b00001000 : begin
          mul_a <= coeff8;
          mul_b <= delay_pipeline8;
        end
        8'b00001001 : begin
          mul_a <= coeff9;
          mul_b <= delay_pipeline9;
        end
        8'b00001010 : begin
          mul_a <= coeff10;
          mul_b <= delay_pipeline10;
        end
        8'b00001011 : begin
          mul_a <= coeff11;
          mul_b <= delay_pipeline11;
        end
        8'b00001100 : begin
          mul_a <= coeff12;
          mul_b <= delay_pipeline12;
        end
        8'b00001101 : begin
          mul_a <= coeff13;
          mul_b <= delay_pipeline13;
        end
        8'b00001110 : begin
            mul_a <= coeff14;
            mul_b <= delay_pipeline14;
        end
        8'b00001111 : begin
            mul_a <= coeff15;
            mul_b <= delay_pipeline15;
        end
        8'b00010000 : begin
            mul_a <= coeff16;
            mul_b <= delay_pipeline16;
        end
        8'b00010001 : begin
            mul_a <= coeff17;
            mul_b <= delay_pipeline17;
        end
        8'b00010010 : begin
            mul_a <= coeff18;
            mul_b <= delay_pipeline18;
        end
        8'b00010011 : begin
            mul_a <= coeff19;
            mul_b <= delay_pipeline19;
        end
        8'b00010100 : begin
            mul_a <= coeff20;
            mul_b <= delay_pipeline20;
        end
        8'b00010101 : begin
            mul_a <= coeff21;
            mul_b <= delay_pipeline21;
        end
        8'b00010110 : begin
            mul_a <= coeff22;
            mul_b <= delay_pipeline22;
        end
        8'b00010111 : begin
            mul_a <= coeff23;
            mul_b <= delay_pipeline23;
        end
        8'b00011000 : begin
            mul_a <= coeff24;
            mul_b <= delay_pipeline24;
        end
        8'b00011001 : begin
            mul_a <= coeff25;
            mul_b <= delay_pipeline25;
        end
        8'b00011010 : begin
            mul_a <= coeff26;
            mul_b <= delay_pipeline26;
        end
        8'b00011011 : begin
            mul_a <= coeff27;
            mul_b <= delay_pipeline27;
        end
        8'b00011100 : begin
            mul_a <= coeff28;
            mul_b <= delay_pipeline28;
        end
        8'b00011101 : begin
            mul_a <= coeff29;
            mul_b <= delay_pipeline29;
        end
        8'b00011110 : begin
            mul_a <= coeff30;
            mul_b <= delay_pipeline30;
        end
        8'b00011111 : begin
            mul_a <= coeff31;
            mul_b <= delay_pipeline31;
        end
        8'b00100000 : begin
            mul_a <= coeff32;
            mul_b <= delay_pipeline32;
        end
        8'b00100001 : begin
            mul_a <= coeff33;
            mul_b <= delay_pipeline33;
        end
         8'b00100010 : begin
            mul_a <= coeff34;
            mul_b <= delay_pipeline34;
        end
        8'b00100011 : begin
            mul_a <= coeff35;
            mul_b <= delay_pipeline35;
        end
        8'b00100100 : begin
            mul_a <= coeff36;
            mul_b <= delay_pipeline36;
        end
        8'b00100101 : begin
            mul_a <= coeff37;
            mul_b <= delay_pipeline37;
        end
         8'b00100110 : begin
            mul_a <= coeff38;
            mul_b <= delay_pipeline38;
        end
        8'b00100111 : begin
            mul_a <= coeff39;
            mul_b <= delay_pipeline39;
        end
        8'b00101000 : begin
            mul_a <= coeff40;
            mul_b <= delay_pipeline40;
        end
        8'b00101001 : begin
            mul_a <= coeff41;
            mul_b <= delay_pipeline41;
        end
        8'b00101010 : begin
            mul_a <= coeff42;
            mul_b <= delay_pipeline42;
        end
        8'b00101011 : begin
            mul_a <= coeff43;
            mul_b <= delay_pipeline43;
        end
        8'b00101100 : begin
            mul_a <= coeff44;
            mul_b <= delay_pipeline44;
        end
        8'b00101101 : begin
            mul_a <= coeff45;
            mul_b <= delay_pipeline45;
        end
        8'b00101110 : begin
            mul_a <= coeff46;
            mul_b <= delay_pipeline46;
        end
        8'b00101111 : begin
            mul_a <= coeff47;
            mul_b <= delay_pipeline47;
        end
        8'b00110000 : begin
            mul_a <= coeff48;
            mul_b <= delay_pipeline48;
        end
        8'b00110001 : begin
            mul_a <= coeff49;
            mul_b <= delay_pipeline49;
        end
        8'b00110010 : begin
            mul_a <= coeff50;
            mul_b <= delay_pipeline50;
        end
        8'b00110011 : begin
            mul_a <= coeff51;
            mul_b <= delay_pipeline51;
        end
        8'b00110100 : begin
            mul_a <= coeff52;
            mul_b <= delay_pipeline52;
        end
        8'b00110101 : begin
            mul_a <= coeff53;
            mul_b <= delay_pipeline53;
        end
        8'b00110110 : begin
            mul_a <= coeff54;
            mul_b <= delay_pipeline54;
        end
         8'b00110111 : begin
            mul_a <= coeff55;
            mul_b <= delay_pipeline55;
        end
        8'b00111000 : begin
            mul_a <= coeff56;
            mul_b <= delay_pipeline56;
        end
        8'b00111001 : begin
            mul_a <= coeff57;
            mul_b <= delay_pipeline57;
        end
        8'b00111010 : begin
            mul_a <= coeff58;
            mul_b <= delay_pipeline58;
        end
        8'b00111011 : begin
            mul_a <= coeff59;
            mul_b <= delay_pipeline59;
        end
        8'b00111100 : begin
            mul_a <= coeff60;
            mul_b <= delay_pipeline60;
        end
        8'b00111101 : begin
            mul_a <= coeff61;
            mul_b <= delay_pipeline61;
        end
        8'b00111110 : begin
            mul_a <= coeff62;
            mul_b <= delay_pipeline62;
        end
        8'b00111111 : begin
            mul_a <= coeff63;
            mul_b <= delay_pipeline63;
        end
        8'b01000000 : begin
            mul_a <= coeff64;
            mul_b <= delay_pipeline64;
        end
        8'b01000001 : begin
            mul_a <= coeff65;
            mul_b <= delay_pipeline65;
        end
        8'b01000010 : begin
            mul_a <= coeff66;
            mul_b <= delay_pipeline66;
        end
        8'b01000011 : begin
            mul_a <= coeff67;
            mul_b <= delay_pipeline67;
        end
        8'b01000100 : begin
            mul_a <= coeff68;
            mul_b <= delay_pipeline68;
        end
        8'b01000101 : begin
            mul_a <= coeff69;
            mul_b <= delay_pipeline69;
        end
        8'b01000110 : begin
            mul_a <= coeff70;
            mul_b <= delay_pipeline70;
        end
        8'b01000111 : begin
            mul_a <= coeff71;
            mul_b <= delay_pipeline71;
        end
        8'b01001000 : begin
            mul_a <= coeff72;
            mul_b <= delay_pipeline72;
        end
        8'b01001001 : begin
            mul_a <= coeff73;
            mul_b <= delay_pipeline73;
        end
        8'b01001010 : begin
            mul_a <= coeff74;
            mul_b <= delay_pipeline74;
        end
        8'b01001011 : begin
            mul_a <= coeff75;
            mul_b <= delay_pipeline75;
        end
        8'b01001100 : begin
            mul_a <= coeff76;
            mul_b <= delay_pipeline76;
        end
        8'b01001101 : begin
            mul_a <= coeff77;
            mul_b <= delay_pipeline77;
        end
        8'b01001110 : begin
            mul_a <= coeff78;
            mul_b <= delay_pipeline78;
        end
        8'b01001111 : begin
            mul_a <= coeff79;
            mul_b <= delay_pipeline79;
        end
        8'b01010000 : begin
            mul_a <= coeff80;
            mul_b <= delay_pipeline80;
        end
        8'b01010001 : begin
            mul_a <= coeff81;
            mul_b <= delay_pipeline81;
        end
        8'b01010010 : begin
            mul_a <= coeff82;
            mul_b <= delay_pipeline82;
        end
        8'b01010011 : begin
            mul_a <= coeff83;
            mul_b <= delay_pipeline83;
        end
        8'b01010100 : begin
            mul_a <= coeff84;
            mul_b <= delay_pipeline84;
        end
        8'b01010101 : begin
            mul_a <= coeff85;
            mul_b <= delay_pipeline85;
        end
        8'b01010110 : begin
            mul_a <= coeff86;
            mul_b <= delay_pipeline86;
        end
        8'b01010111 : begin
            mul_a <= coeff87;
            mul_b <= delay_pipeline87;
        end
        8'b01011000 : begin
            mul_a <= coeff88;
            mul_b <= delay_pipeline88;
        end
        8'b01011001 : begin
            mul_a <= coeff89;
            mul_b <= delay_pipeline89;
        end
        8'b01011010 : begin
            mul_a <= coeff90;
            mul_b <= delay_pipeline90;
        end
        8'b01011011 : begin
            mul_a <= coeff91;
            mul_b <= delay_pipeline91;
        end
        8'b01011100 : begin
            mul_a <= coeff92;
            mul_b <= delay_pipeline92;
        end
        8'b01011101 : begin
            mul_a <= coeff93;
            mul_b <= delay_pipeline93;
        end
        8'b01011110 : begin
            mul_a <= coeff94;
            mul_b <= delay_pipeline94;
        end
        8'b01011111 : begin
            mul_a <= coeff95;
            mul_b <= delay_pipeline95;
        end
        8'b01100000 : begin
            mul_a <= coeff96;
            mul_b <= delay_pipeline96;
        end
        8'b01100001 : begin
            mul_a <= coeff97;
            mul_b <= delay_pipeline97;
        end
        8'b01100010 : begin
            mul_a <= coeff98;
            mul_b <= delay_pipeline98;
        end
        8'b01100011 : begin
            mul_a <= coeff99;
            mul_b <= delay_pipeline99;
        end
        8'b01100100 : begin
            mul_a <= coeff100;
            mul_b <= delay_pipeline100;
        end
        8'b01100101 : begin
            mul_a <= coeff101;
            mul_b <= delay_pipeline101;
        end
        8'b01100110 : begin
            mul_a <= coeff102;
            mul_b <= delay_pipeline102;
        end
        8'b01100111 : begin
            mul_a <= coeff103;
            mul_b <= delay_pipeline103;
        end
        8'b01101000 : begin
            mul_a <= coeff104;
            mul_b <= delay_pipeline104;
        end
        8'b01101001 : begin
            mul_a <= coeff105;
            mul_b <= delay_pipeline105;
        end
        8'b01101010 : begin
            mul_a <= coeff106;
            mul_b <= delay_pipeline106;
        end
        8'b01101011 : begin
            mul_a <= coeff107;
            mul_b <= delay_pipeline107;
        end
        8'b01101100 : begin
            mul_a <= coeff108;
            mul_b <= delay_pipeline108;
        end
        8'b01101101 : begin
            mul_a <= coeff109;
            mul_b <= delay_pipeline109;
        end
        8'b01101110 : begin
            mul_a <= coeff110;
            mul_b <= delay_pipeline110;
        end
        8'b01101111 : begin
            mul_a <= coeff111;
            mul_b <= delay_pipeline111;
        end
        8'b01110000 : begin
            mul_a <= coeff112;
            mul_b <= delay_pipeline112;
        end
        8'b01110001 : begin
            mul_a <= coeff113;
            mul_b <= delay_pipeline113;
        end
        8'b01110010 : begin
            mul_a <= coeff114;
            mul_b <= delay_pipeline114;
        end
        8'b01110011 : begin
            mul_a <= coeff115;
            mul_b <= delay_pipeline115;
        end
        8'b01110100 : begin
            mul_a <= coeff116;
            mul_b <= delay_pipeline116;
        end
        8'b01110101 : begin
            mul_a <= coeff117;
            mul_b <= delay_pipeline117;
        end
        8'b01110110 : begin
            mul_a <= coeff118;
            mul_b <= delay_pipeline118;
        end
        8'b01110111 : begin
            mul_a <= coeff119;
            mul_b <= delay_pipeline119;
        end
        8'b01111000 : begin
            mul_a <= coeff120;
            mul_b <= delay_pipeline120;
        end
        8'b01111001 : begin
            mul_a <= coeff121;
            mul_b <= delay_pipeline121;
        end
        8'b01111010 : begin
            mul_a <= coeff122;
            mul_b <= delay_pipeline122;
        end
        8'b01111011 : begin
            mul_a <= coeff123;
            mul_b <= delay_pipeline123;
        end
        8'b01111100 : begin
            mul_a <= coeff124;
            mul_b <= delay_pipeline124;
        end
        8'b01111101 : begin
            mul_a <= coeff125;
            mul_b <= delay_pipeline125;
        end
        8'b01111110 : begin
            mul_a <= coeff126;
            mul_b <= delay_pipeline126;
        end
        8'b01111111 : begin
            mul_a <= coeff127;
            mul_b <= delay_pipeline127;
        end
        8'b10000000 : begin
            mul_a <= coeff128;
            mul_b <= delay_pipeline128;
        end
        8'b10000001 : begin
            mul_a <= coeff129;
            mul_b <= delay_pipeline129;
        end
        8'b10000010 : begin
            mul_a <= coeff130;
            mul_b <= delay_pipeline130;
        end
        8'b10000011 : begin
            mul_a <= coeff131;
            mul_b <= delay_pipeline131;
        end
        8'b10000100 : begin
            mul_a <= coeff132;
            mul_b <= delay_pipeline132;
        end
        8'b10000101 : begin
            mul_a <= coeff133;
            mul_b <= delay_pipeline133;
        end
        8'b10000110 : begin
            mul_a <= coeff134;
            mul_b <= delay_pipeline134;
        end
         8'b10000111 : begin
            mul_a <= coeff135;
            mul_b <= delay_pipeline135;
        end
        8'b10001000 : begin
            mul_a <= coeff136;
            mul_b <= delay_pipeline136;
        end
        8'b10001001 : begin
            mul_a <= coeff137;
            mul_b <= delay_pipeline137;
        end
        8'b10001010 : begin
            mul_a <= coeff138;
            mul_b <= delay_pipeline138;
        end
        8'b10001011 : begin
            mul_a <= coeff139;
            mul_b <= delay_pipeline139;
        end
        8'b10001100 : begin
            mul_a <= coeff140;
            mul_b <= delay_pipeline140;
        end
        8'b10001101 : begin
            mul_a <= coeff141;
            mul_b <= delay_pipeline141;
        end
        8'b10001110 : begin
            mul_a <= coeff142;
            mul_b <= delay_pipeline142;
        end
        8'b10001111 : begin
            mul_a <= coeff143;
            mul_b <= delay_pipeline143;
        end
        8'b10010000 : begin
            mul_a <= coeff144;
            mul_b <= delay_pipeline144;
        end
         8'b10010001 : begin
            mul_a <= coeff145;
            mul_b <= delay_pipeline145;
        end
        8'b10010010 : begin
            mul_a <= coeff146;
            mul_b <= delay_pipeline146;
        end
        8'b10010011 : begin
            mul_a <= coeff147;
            mul_b <= delay_pipeline147;
        end
        8'b10010100 : begin
            mul_a <= coeff148;
            mul_b <= delay_pipeline148;
        end
        8'b10010101 : begin
            mul_a <= coeff149;
            mul_b <= delay_pipeline149;
        end
        8'b10010110 : begin
            mul_a <= coeff150;
            mul_b <= delay_pipeline150;
        end
        8'b10010111 : begin
            mul_a <= coeff151;
            mul_b <= delay_pipeline151;
        end
        8'b10011000 : begin
            mul_a <= coeff152;
            mul_b <= delay_pipeline152;
        end
        8'b10011001 : begin
            mul_a <= coeff153;
            mul_b <= delay_pipeline153;
        end
        8'b10011010 : begin
            mul_a <= coeff154;
            mul_b <= delay_pipeline154;
        end
        8'b10011011 : begin
            mul_a <= coeff155;
            mul_b <= delay_pipeline155;
        end
        8'b10011100 : begin
            mul_a <= coeff156;
            mul_b <= delay_pipeline156;
        end
        8'b10011101 : begin
            mul_a <= coeff157;
            mul_b <= delay_pipeline157;
        end
        8'b10011110 : begin
            mul_a <= coeff158;
            mul_b <= delay_pipeline158;
        end
        8'b10011111 : begin
            mul_a <= coeff159;
            mul_b <= delay_pipeline159;
        end
        8'b10100000 : begin
            mul_a <= coeff160;
            mul_b <= delay_pipeline160;
        end
        8'b10100001 : begin
            mul_a <= coeff161;
            mul_b <= delay_pipeline161;
        end
        8'b10100010 : begin
            mul_a <= coeff162;
            mul_b <= delay_pipeline162;
        end
        8'b10100011 : begin
            mul_a <= coeff163;
            mul_b <= delay_pipeline163;
        end
        8'b10100100 : begin
            mul_a <= coeff164;
            mul_b <= delay_pipeline164;
        end
        8'b10100101 : begin
            mul_a <= coeff165;
            mul_b <= delay_pipeline165;
        end
        8'b10100110 : begin
            mul_a <= coeff166;
            mul_b <= delay_pipeline166;
        end
        8'b10100111 : begin
            mul_a <= coeff167;
            mul_b <= delay_pipeline167;
        end
        8'b10101000 : begin
            mul_a <= coeff168;
            mul_b <= delay_pipeline168;
        end
        8'b10101001 : begin
            mul_a <= coeff169;
            mul_b <= delay_pipeline169;
        end
        8'b10101010 : begin
            mul_a <= coeff170;
            mul_b <= delay_pipeline170;
        end
        8'b10101011 : begin
            mul_a <= coeff171;
            mul_b <= delay_pipeline171;
        end
        8'b10101100 : begin
            mul_a <= coeff172;
            mul_b <= delay_pipeline172;
        end
        8'b10101101 : begin
            mul_a <= coeff173;
            mul_b <= delay_pipeline173;
        end
        8'b10101110 : begin
            mul_a <= coeff174;
            mul_b <= delay_pipeline174;
        end
        8'b10101111 : begin
            mul_a <= coeff175;
            mul_b <= delay_pipeline175;
        end
        8'b10110000 : begin
            mul_a <= coeff176;
            mul_b <= delay_pipeline176;
        end
        8'b10110001 : begin
            mul_a <= coeff177;
            mul_b <= delay_pipeline177;
        end
        8'b10110010 : begin
            mul_a <= coeff178;
            mul_b <= delay_pipeline178;
        end
        8'b10110011 : begin
            mul_a <= coeff179;
            mul_b <= delay_pipeline179;
        end
        8'b10110100 : begin
            mul_a <= coeff180;
            mul_b <= delay_pipeline180;
        end
        8'b10110101 : begin
            mul_a <= coeff181;
            mul_b <= delay_pipeline181;
        end
        8'b10110110 : begin
            mul_a <= coeff182;
            mul_b <= delay_pipeline182;
        end
        8'b10110111 : begin
            mul_a <= coeff183;
            mul_b <= delay_pipeline183;
        end
        8'b10111000 : begin
            mul_a <= coeff184;
            mul_b <= delay_pipeline184;
        end
        8'b10111001 : begin
            mul_a <= coeff185;
            mul_b <= delay_pipeline185;
        end
        8'b10111010 : begin
            mul_a <= coeff186;
            mul_b <= delay_pipeline186;
        end
        8'b10111011 : begin
            mul_a <= coeff187;
            mul_b <= delay_pipeline187;
        end
        8'b10111100 : begin
            mul_a <= coeff188;
            mul_b <= delay_pipeline188;
        end
        8'b10111101 : begin
            mul_a <= coeff189;
            mul_b <= delay_pipeline189;
        end
        8'b10111110 : begin
            mul_a <= coeff190;
            mul_b <= delay_pipeline190;
        end
        8'b10111111 : begin
            mul_a <= coeff191;
            mul_b <= delay_pipeline191;
        end
        8'b11000000 : begin
            mul_a <= coeff192;
            mul_b <= delay_pipeline192;
        end
        8'b11000001 : begin
            mul_a <= coeff193;
            mul_b <= delay_pipeline193;
        end
        8'b11000010 : begin
            mul_a <= coeff194;
            mul_b <= delay_pipeline194;
        end
        8'b11000011 : begin
            mul_a <= coeff195;
            mul_b <= delay_pipeline195;
        end
        8'b11000100 : begin
            mul_a <= coeff196;
            mul_b <= delay_pipeline196;
        end
        8'b11000101 : begin
            mul_a <= coeff197;
            mul_b <= delay_pipeline197;
        end
        8'b11000110 : begin
            mul_a <= coeff198;
            mul_b <= delay_pipeline198;
        end
        8'b11000111 : begin
            mul_a <= coeff199;
            mul_b <= delay_pipeline199;
        end
    endcase
  end
end

always @(posedge clk or negedge rst_n) begin
  if (rst_n == 1'b0) begin
    // reset
    out_temp <= 'd0;
    FIR_out <= 'd0;
  end
  else begin
    out_temp <= out_temp + mul_p;
    if(count == 8'b11000111) begin
      FIR_out <= out_temp[37:22];
      out_temp <= 'd0;
      valid_flag <= 'd1;
    end
    else begin
        valid_flag <= 'd0;
    end
  end
end


endmodule 