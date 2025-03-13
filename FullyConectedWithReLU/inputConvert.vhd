library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.float_pkg.all;

entity inputConvert is
	port (
		a_std_logic_vector: in  std_logic_vector(31 downto 0);
		b_std_logic_vector: in  std_logic_vector(31 downto 0);
		a_float32		  : out float32;
		b_float32		  : out float32
	);
end inputConvert;

architecture inputConvert_arc of inputConvert is

begin

	a_float32 <= to_float(signed(a_std_logic_vector));
	b_float32 <= to_float(signed(b_std_logic_vector));

end inputConvert_arc;

