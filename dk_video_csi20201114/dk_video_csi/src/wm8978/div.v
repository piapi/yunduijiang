module div #(parameter out_freq=1)
(
    input clk_120m,
    input s_rst_n,
    output reg clk_out
);

//分频到1HZ
parameter N=30;
parameter in_freq=120000000;

reg [N-1:0] count_div;
always @(posedge clk_120m or negedge s_rst_n) begin
       if(s_rst_n == 1'b0)
           begin
               count_div<=0;
               clk_out<= 1'b0;
           end
       else if (count_div<(in_freq/(2*out_freq)-1))
           begin
               count_div<=count_div+1'b1;
           end
       else 
           begin
               count_div<=0;
               clk_out<=~clk_out;
           end
     end


endmodule