module sqrt
    #(                                                              //8,4,5
    parameter                           d_width                   = 32     ,
    parameter                           q_width                   = d_width/2,
    parameter                           r_width                   = q_width + 1	)
    (
    input  wire                         clk                        ,
    input  wire                         rst_n                      ,
    input  wire                         i_vaild                    ,
    input  wire        [d_width-1: 0]   data_i                     ,//输入
	
	
    output reg                          o_vaild                    ,
    output reg         [q_width-1: 0]   data_o                     ,//输出
    output reg         [r_width-1: 0]   data_r                      //余数
	
    );
//--------------------------------------------------------------------------------
//  注意这里使用了流水线操作，输出数据的位宽决定了流水线的级数，级数=q_width
    reg                [d_width-1: 0]   D                   [q_width:1]  ;//保存依次输入进来的被开方数据
    reg                [q_width-1: 0]   Q_z                 [q_width:1]  ;//保存每一级流水线的实验值
    reg                [q_width-1: 0]   Q_q                 [q_width:1]  ;//由实验值与真实值的比较结果确定的最终值
    reg                                 valid_flag          [q_width:1]  ;//表示此时寄存器D中对应位置的数据是否有效
//--------------------------------------------------------------------------------
    always@(posedge    clk or negedge    rst_n)
        begin
            if(!rst_n)
                begin
                    D[q_width] <= 0;
                    Q_z[q_width] <= 0;
                    Q_q[q_width] <= 0;
                    valid_flag[q_width] <= 0;
                end
            else if(i_vaild)
                begin
                    D[q_width] <= data_i;                           //被开方数据
                    Q_z[q_width] <= {1'b1,{(q_width-1){1'b0}}};     //实验值设置，先将最高位设为1
                    Q_q[q_width] <= 0;                              //实际计算结果
                    valid_flag[q_width] <= 1;
                end
            else
                begin
                    D[q_width] <= 0;
                    Q_z[q_width] <= 0;
                    Q_q[q_width] <= 0;
                    valid_flag[q_width] <= 0;
                end
        end
//-------------------------------------------------------------------------------
//		迭代计算过程，流水线操作
//-------------------------------------------------------------------------------
        generate
            genvar i;
                //i=3,2,1
                for(i=q_width-1;i>=1;i=i-1)
                    begin:U
                        always@(posedge clk or negedge    rst_n)
                            begin
                                if(!rst_n)
                                    begin
                                        D[i] <= 0;
                                        Q_z[i] <= 0;
                                        Q_q[i] <= 0;
                                        valid_flag[i] <= 0;
                                    end
                                //在上一时钟周期将数据读入并设置数据有效，下一个周期开始比较数据
                                else    if(valid_flag[i+1])
                                    begin
                                        //根据根的实验值最高位置为1后的平方值与真实值的大小比较结果，
                                        //确定最高位是否应该为1以及将次高位的赋值为1，准备开始下一次比较！！！
                                        //注意，这里最后是给Q_z[i]和Q_q[i]赋值，相当于把上一周期的数据处理后
                                        //移到了寄存器的下一个位置，而Q_z[i+1]和Q_q[i+1]则负责接收新的数据
                                        if(Q_z[i+1]*Q_z[i+1] > D[i+1])
                                            begin
                                                //如果实验值的平方过大，那么就将最高位置为0，次高位置1，
                                                //并将数据从位置i+1移至下一个位置i，而i+1的位置用于接收下一个输入的数据
                                                Q_z[i] <= {Q_q[i+1][q_width-1:i],1'b1,{{i-1}{1'b0}}};
                                                Q_q[i] <= Q_q[i+1];
                                            end
                                        else
                                            begin
                                                Q_z[i] <= {Q_z[i+1][q_width-1:i],1'b1,{{i-1}{1'b0}}};
                                                Q_q[i] <= Q_z[i+1];
                                            end
                                        D[i] <= D[i+1];
                                        valid_flag[i] <= 1;
                                    end
                                else
                                    begin
                                        valid_flag[i] <= 0;
                                        D[i] <= 0;
                                        Q_q[i] <= 0;
                                        Q_z[i] <= 0;
                                    end
                            end
                    end
        endgenerate
//--------------------------------------------------------------------------------
//	计算余数与最终平方根
//--------------------------------------------------------------------------------
        always@(posedge    clk or negedge    rst_n)
            begin
                if(!rst_n)
                    begin
                        data_o <= 0;
                        data_r <= 0;
                        o_vaild <= 0;
                    end
                else    if(valid_flag[1])
                    begin
                        if(Q_z[1]*Q_z[1] > D[1])
                            begin
                                data_o <= Q_q[1];
                                data_r <= D[1] - Q_q[1]*Q_q[1];
                                o_vaild <= 1;
                            end
                        else
                            begin
                                data_o <= {Q_q[1][q_width-1:1],Q_z[1][0]};
                                data_r <= D[1] - {Q_q[1][q_width-1:1],Q_z[1][0]}*{Q_q[1][q_width-1:1],Q_z[1][0]};
                                o_vaild <= 1;
                            end
                    end
                else
                    begin
                        data_o <= 0;
                        data_r <= 0;
                        o_vaild <= 0;
                    end
            end
endmodule
/*module sqrt (
    input  wire                         I_sys_clk                  ,/// 系统时钟
    input  wire                         I_data_en                  ,/// 数据有效标志,与数据对齐
    input  wire        [  31: 0]        I_data_in                  ,/// 输入数据
    output reg                          O_data_en                  ,/// 数据有效标志,与数据对齐
    output reg         [  15: 0]        O_data_out                 ,/// 开根号的结果
    output reg         [  18: 0]        O_data_rem                  /// 余数
);
    parameter                           C_DATA_WITH_IN            = 32    ;
    parameter                           C_DATA_WITH_OUT           = C_DATA_WITH_IN / 2;
    parameter                           C_DATA_WITH_REM           = C_DATA_WITH_OUT + 3;

    reg                [C_DATA_WITH_IN-5: 0]S_data_in              ;//输入数据
    reg                [C_DATA_WITH_REM-1: 0]S_data_rem            ;//余数
    reg                [C_DATA_WITH_OUT-1: 0]S_data_out            ;//缓存的开根号的结果
    wire               [C_DATA_WITH_REM-1: 0]S_data_rem_cut        ;
    reg                [C_DATA_WITH_OUT-1: 0]S_data_en             ;

  always @(posedge I_sys_clk) begin
    if (I_data_en)
      if (|I_data_in[C_DATA_WITH_IN-1:C_DATA_WITH_IN-2])            /// 高位是1，取高四位减b100，得到余数
          begin
        S_data_out <= {{(C_DATA_WITH_OUT - 1) {1'b0}}, 1'b1};
        S_data_rem <= {{(C_DATA_WITH_REM - 5) {1'b0}}, I_data_in[C_DATA_WITH_IN-1:C_DATA_WITH_IN-4]} - 3'b100;
      end else                                                      /// 高位是0，直接取高四位得到余数
      begin
        S_data_out <= {{(C_DATA_WITH_OUT - 1) {1'b0}}, 1'b0};
        S_data_rem <= {{(C_DATA_WITH_REM - 5) {1'b0}}, I_data_in[C_DATA_WITH_IN-1:C_DATA_WITH_IN-4]};
      end
    else if (S_data_rem_cut[C_DATA_WITH_REM-1])                     /// 判断是否大于 2*a+1
        begin
      S_data_out <= {S_data_out[C_DATA_WITH_OUT-2:0], 1'b0};
      S_data_rem <= {S_data_rem[C_DATA_WITH_REM-3:0], S_data_in[C_DATA_WITH_IN-5:C_DATA_WITH_IN-6]};
    end else begin
      S_data_out <= {S_data_out[C_DATA_WITH_OUT-2:0], 1'b1};
      S_data_rem <= {S_data_rem_cut[C_DATA_WITH_REM-3:0], S_data_in[C_DATA_WITH_IN-5:C_DATA_WITH_IN-6]};
    end
  end

    assign                              S_data_rem_cut            = S_data_rem - {1'b0, S_data_out[C_DATA_WITH_OUT-1:0], 2'b0} - 1'b1;

  //截取第四位以后的数据
  always @(posedge I_sys_clk) begin
    if (I_data_en) S_data_in <= I_data_in[C_DATA_WITH_IN-5:0];
    else S_data_in <= S_data_in << 2;
  end

  always @(posedge I_sys_clk) begin
    S_data_en <= {S_data_en[C_DATA_WITH_OUT-2:0], I_data_en};
  end
  always @(posedge I_sys_clk) begin
    O_data_en <= S_data_en[C_DATA_WITH_OUT-1];
  end
  always @(posedge I_sys_clk) begin
    if (S_data_en[C_DATA_WITH_OUT-1]) O_data_out <= S_data_out;
    else O_data_out <= O_data_out;
  end

  always @(posedge I_sys_clk) begin
    if (S_data_en[C_DATA_WITH_OUT-2])
      if (S_data_rem_cut[C_DATA_WITH_REM-1]) O_data_rem <= S_data_rem;
      else O_data_rem <= S_data_rem_cut;
    else O_data_rem <= O_data_rem;
  end

endmodule*/
