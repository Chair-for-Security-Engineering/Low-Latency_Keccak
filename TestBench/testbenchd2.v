/*
* -----------------------------------------------------------------
* AUTHOR  : Sara Zarei (sarazareei.94@gmail.com), Aein Rezaei Shahmirzadi (aein.rezaeishahmirzadi@rub.de), Amir Moradi (amir.moradi@rub.de)
* DOCUMENT: "Low-Latency Keccak at any Arbitrary Order" (TCHES 2021, Issue 4)
* -----------------------------------------------------------------
*
* Copyright (c) 2021, Sara Zarei, Aein Rezaei Shahmirzadi, Amir Moradi
*
* All rights reserved.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
* ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTERS BE LIABLE FOR ANY
* DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
* ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*
* Please see LICENSE and README for license and further instructions.
*/


module testbenchd2;

	// Inputs
	reg Clock;
	reg Reset;
	reg [200*3-1:0] In;
	reg [200*3-1:0] FreshRand;

	// Outputs
	wire Ready;
	wire [200*3-1:0] Out;


	wire [199:0] Output;
	reg  [199:0] Input;
	reg  [199:0] InShares [3:1];
	
	// Instantiate the Unit Under Test (UUT)
	keccak_top #(.d(2)) uut (
		.Clock(Clock), 
		.Reset(Reset), 
		.InData(In), 
		.FreshRand(FreshRand), 
		.Ready(Ready), 
		.OutData(Out)
	);

	assign Output = Out[200*3-1:200*2] ^ Out[200*2-1:200*1] ^ Out[200*1-1:200*0];
	
	always @(*) begin 

	 In = {InShares[3],InShares[2],InShares[1]};

	end

	
		initial begin	
		Clock = 0;
		Reset = 1;
		#500
		
		Input = {128'hffffffffffffffffffffffffffffffff,72'h0123456789abcdef01};
		InShares[1] = {7{$random}};
		InShares[2] = {7{$random}};
		InShares[3] = Input ^ InShares[1] ^ InShares[2];
		#20
		Reset = 0;
		@(posedge Ready)
			#10
			if(Output == 200'he090c8c5e596d3421d2fcc695838626cbb365352811837480f) begin
					$write("------------------PASS---------------\n");
			end
			else begin
				$write("\------------------FAIL---------------\n");
				$write("%x\n", Output);
			end
			
		#400
		Reset = 1;
		InShares[1] = {7{$random}};
		InShares[2] = {7{$random}};
		InShares[3] = Input ^ InShares[1] ^ InShares[2];
		#20
		Reset = 0;
		@(posedge Ready)
			#10
			if(Output == 200'he090c8c5e596d3421d2fcc695838626cbb365352811837480f) begin
					$write("------------------PASS---------------\n");
			end
			else begin
				$write("\------------------FAIL---------------\n");
				$write("%x\n", Output);
			end
		
		#400
		Reset = 1;
		Input = {128'hffffffffffffffffffffffffffffffff,72'h000000000000000008};
		InShares[1] = {7{$random}};
		InShares[2] = {7{$random}};
		InShares[3] = Input ^ InShares[1] ^ InShares[2];
		#20
		Reset = 0;
		
		#400
		Reset = 1;
		Input = {128'hffffffffffffffffffffffffffffffff,72'h000000000000000006};
		InShares[1] = {7{$random}};
		InShares[2] = {7{$random}};
		InShares[3] = Input ^ InShares[1] ^ InShares[2];
		#20
		Reset = 0;

		#400
		Reset = 1;
		Input = {128'hffffffffffffffffffffffffffffffff,72'h0123456789abcdef01};
		InShares[1] = {7{$random}};
		InShares[2] = {7{$random}};
		InShares[3] = Input ^ InShares[1] ^ InShares[2];
		#20
		Reset = 0;
		@(posedge Ready)
			#10
			if(Output == 200'he090c8c5e596d3421d2fcc695838626cbb365352811837480f) begin
					$write("------------------PASS---------------\n");
			end
			else begin
				$write("\------------------FAIL---------------\n");
				$write("%x\n", Output);
			end
		
		#400
		Reset = 1;
		Input = {200{1'b0}};
		InShares[1] = {7{$random}};
		InShares[2] = {7{$random}};
		InShares[3] = Input ^ InShares[1] ^ InShares[2];
		#20
		Reset = 0;
		
	end
	
	   always #10 Clock = ~Clock;
		
		always #20 FreshRand  = {19{$random}};

      
endmodule

