module PWM_Control #(
    parameter CLK_FREQ = 25_000_000,
    parameter PWM_FREQ = 1_250
) (
    input  wire clk,
    input  wire rst_n,
    output wire [7:0] leds
);

    localparam integer PWM_CLK_PERIOD = CLK_FREQ / PWM_FREQ;
    localparam [15:0] DUTY_MIN = PWM_CLK_PERIOD / 40000;  // ~0.0025%
    localparam [15:0] DUTY_MAX = (PWM_CLK_PERIOD * 70) / 100; // 70%

    reg [15:0] duty_cycle;
    reg [15:0] delay_counter;
    reg        up;

    wire pwm_out;

    PWM pwm_inst (
        .clk(clk),
        .rst_n(rst_n),
        .duty_cycle(duty_cycle),
        .period(PWM_CLK_PERIOD),
        .pwm_out(pwm_out)
    );

    assign leds = {8{pwm_out}};

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            duty_cycle    <= DUTY_MIN;
            delay_counter <= 0;
            up            <= 1;
        end else begin
            delay_counter <= delay_counter + 1;
            if (delay_counter >= CLK_FREQ / 200) begin  // ajusta fade: ~5ms
                delay_counter <= 0;

                if (up) begin
                    if (duty_cycle < DUTY_MAX)
                        duty_cycle <= duty_cycle + 1;
                    else
                        up <= 0;
                end else begin
                    if (duty_cycle > DUTY_MIN)
                        duty_cycle <= duty_cycle - 1;
                    else
                        up <= 1;
                end
            end
        end
    end

endmodule
