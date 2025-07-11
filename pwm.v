module PWM (
    input  wire clk,
    input  wire rst_n,
    input  wire [15:0] duty_cycle,
    input  wire [15:0] period,
    output reg pwm_out
);

    reg [15:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter  <= 0;
            pwm_out <= 0;
        end else begin
            if (counter >= period - 1)
                counter <= 0;
            else
                counter <= counter + 1;

            if (counter < duty_cycle)
                pwm_out <= 1;
            else
                pwm_out <= 0;
        end
    end

endmodule
