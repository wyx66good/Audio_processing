/*****************************************************************/
//
// Create Date: 2024/04/25
// Design Name: WenYiXing
//
/*****************************************************************/

module arbiter(
    input   wire    [3:0]   request     , // [HDMI, CAMERA]
    
    output  reg     [3:0]   grant       ,

    input   wire    [3:0]   request_rd  , // [HDMI, CAMERA]
    
    output  reg     [3:0]   grant_rd       
);
/**************************process***************************/
// 高位优先级更高
always@(*)
begin
    case(1'b1)
        request[3]:
            grant = 4'b1000;
        request[2]:
            grant = 4'b0100;
        request[1]:
            grant = 4'b0010;
        request[0]:
            grant = 4'b0001;
        default:
            grant = 4'b0000;
    endcase
end

// 高位优先级更高
always@(*)
begin
    case(1'b1)
        request_rd[3]:begin
            grant_rd = 4'b1000;end
        request_rd[2]:begin
            grant_rd = 4'b0100;end
        request_rd[1]:begin
            grant_rd = 4'b0010;end
        request_rd[0]:begin
            grant_rd = 4'b0001;end
        default:begin
            grant_rd = 4'b0000;end
    endcase
end

endmodule
