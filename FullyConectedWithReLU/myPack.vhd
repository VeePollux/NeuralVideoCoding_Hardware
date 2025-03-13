library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.float_pkg.all;

Package myPack is 

component inputConvert is
	port (
		a_std_logic_vector: in  std_logic_vector(32 downto 0);
		b_std_logic_vector: in  std_logic_vector(32 downto 0);
		a_float32		  : out float32;
		b_float32		  : out float32
	);
end component;

component outputConvert is
	port (
		in_float32 		: in float32;
		out_std_logic_vector	  : out std_logic_vector(31 downto 0)
	);
end component;

component multiplier is
    port (
        a  : in  float32;
        b  : in  float32;
        p  : out float32
    );
end component;

component neuralLayer
        generic (
            INPUT_SIZE  : positive;
            OUTPUT_SIZE : positive
        );
        port (
            clk      : in  std_logic;
            reset    : in  std_logic;
            inputs   : in  std_logic_vector(INPUT_SIZE*32-1 downto 0);
            weights  : in  std_logic_vector(INPUT_SIZE*OUTPUT_SIZE*32-1 downto 0);
            outputs  : out std_logic_vector(OUTPUT_SIZE*32-1 downto 0)
        );
end component;

component neuralNetwork is
    generic (
        INPUT_SIZE   : positive := 2;   
        LAYER_SIZES  : positive := 2;   
        NEURONS_PER_LAYER : positive := 2  
    );
    port (
        clk      : in  std_logic;
        reset    : in  std_logic;
        inputs   : in  std_logic_vector(INPUT_SIZE*32-1 downto 0);  
        weights  : in  std_logic_vector(LAYER_SIZES*NEURONS_PER_LAYER*INPUT_SIZE*32-1 downto 0);
        outputs  : out std_logic_vector(NEURONS_PER_LAYER*32-1 downto 0)  
    );
end component;



end myPack;