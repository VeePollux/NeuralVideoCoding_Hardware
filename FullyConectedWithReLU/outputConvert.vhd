library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.float_pkg.all;
use work.fixed_pkg.all;

entity outputConvert is
	port (
		in_float32 		: in float32;
		out_std_logic_vector	  : out std_logic_vector(31 downto 0)
	);
end entity outputConvert;

architecture arch_outputConvert of outputConvert is

begin

	out_std_logic_vector 		<= to_slv(to_sfixed(in_float32, 31, 0));
	
end architecture arch_outputConvert;
