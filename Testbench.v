`timescale 1ps/1ps


module toplevel ();
//------BEGIN SETUP------//
	//--GIVEN INPUTS AND OUTPUTS (for now they are not perfectly right)--//
	reg clk = 2'b1;
	reg nrst = 1'b0;
	reg swiptONHeartbeat = 1'b1;
	wire [11:0] ADC_in;

	wire SWIPT_OUT0;
	wire SWIPT_OUT1;
	wire SWIPT_OUT2;
	wire SWIPT_OUT3;
	//--GIVEN INPUTS AND OUTPUTS (for now they are not perfectly right)--//

	//--DEFINITION OF CLK, NRST AND SWIPTONHEARTBEAT--//
	always #5000 clk = ~clk;
	always #900000 swiptONHeartbeat <= ~swiptONHeartbeat;

	// Reset
	initial #1000000000 nrst = 1'b1;
	//--DEFINITION OF CLK, NRST AND SWIPTONHEARTBEAT--//

//------END SETUP------//

//------BEGIN PARAM & VAR------//
	///Parameters for algorithms given by TA's///
	wire swiptAlive;
	
	///ADC_in
	wire ADC0;
	wire ADC1;
	wire ADC2;
	wire ADC3;
	wire ADC4;
	wire ADC5;
	wire ADC6;
	wire ADC7;
	wire ADC8;
	wire ADC9;
	wire ADC10;
	wire ADC11;

	///Frequency Default
	reg [31:0] freq = 32'h9C40; //Default freq is 40kHz
	wire [31:0] f;
	reg load_freq = 1'b1;
	reg [31:0] freq_step = 32'h1F4;
	reg [4:0] lgcoefficient = 5'b00111;
	wire [1:0] error;
	wire [31:0] phase;
	///Duty Default
 	reg [11:0] l = 12'h0FA;
	///ADC
	wire ADC_comp;
	reg pll_in = 0;

	always @(posedge swiptAlive) begin
		load_freq <= 1'b0;
	end
	always @(posedge clk) begin
		if(nrst && swiptAlive && ~load_freq)begin
			pll_in <= error[0];
		end
		else begin
			pll_in <= ADC_comp;
		end
	end

//------END PARAM & VAR------//	
	
//------BEGIN MODULES------//
	//set swipt alive
	Heartbeat inst_heartbeat (
			.clk (clk),
			.nrst (nrst),
			.swiptONHeartbeat (swiptONHeartbeat),
			.swipt (swiptAlive)
			);

	ANALOG_NETWORK inst_ANALOG_NETWORK (
			.SWIPT_OUT0	(SWIPT_OUT0),
			.SWIPT_OUT1	(SWIPT_OUT1),
			.SWIPT_OUT2 (SWIPT_OUT2),
			.SWIPT_OUT3 (SWIPT_OUT3),
			.ACOUT0 (ADC11),
			.ACOUT1 (ADC10),
			.ACOUT2 (ADC9),
			.ACOUT3 (ADC8),
			.ACOUT4 (ADC7),
			.ACOUT5 (ADC6),
			.ACOUT6 (ADC5),
			.ACOUT7 (ADC4),
			.ACOUT8 (ADC3),
			.ACOUT9 (ADC2),
			.ACOUT10 (ADC1),
			.ACOUT11 (ADC0)
			);

	SwiptOut inst_swiptout (
			.clk (clk),
			.nrst (nrst),
			.swiptAlive (swiptAlive),
			.freq (freq),
			.l (l),
			.SWIPT_OUT0 (SWIPT_OUT0),
			.SWIPT_OUT1 (SWIPT_OUT1),
			.SWIPT_OUT2 (SWIPT_OUT2),
			.SWIPT_OUT3 (SWIPT_OUT3)
			);

	ADC_Comp inst_adcComp (
			.clk (clk),
			.nrst (nrst),
			.swiptAlive (swiptAlive),
			.ADC (ADC_in),
			.ADC_comp (ADC_comp)
			);

	// PLL inst_pll (
	// 		.clk (clk),
	// 		.nrst (nrst),
	// 		.swiptAlive (swiptAlive),
	// 		.pll_in (pll_in),
	// 		.load_freq (load_freq),
	// 		.freq (freq_step),
	// 		.lgcoefficient (lgcoefficient),
	// 		.phase (phase),
	// 		.error (error)
	// 		);

	PLL2 inst_pll2 (
			.clk (clk),
			.nrst (nrst),
			.swiptAlive (swiptAlive),
			.link (ADC_comp),
			.f (f)
	);
//------END MODULES------//

//------BEGIN ASSIGNMENT------//

	assign ADC_in[11] = ADC11;
	assign ADC_in[10] = ADC10;
	assign ADC_in[9] = ADC9;
	assign ADC_in[8] = ADC8;
	assign ADC_in[7] = ADC7;
	assign ADC_in[6] = ADC6;
	assign ADC_in[5] = ADC5;
	assign ADC_in[4] = ADC4;
	assign ADC_in[3] = ADC3;
	assign ADC_in[2] = ADC2;
	assign ADC_in[1] = ADC1;
	assign ADC_in[0] = ADC0;

//------END ASSIGNMENT------//
endmodule
