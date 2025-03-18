library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.float_pkg.all;
use work.fixed_pkg.ALL;

entity convolution is
    generic (
        KERNEL_SIZE : integer := 2;
        MATRIX_SIZE : integer := 3;
        DATA_WIDTH  : integer := 8;
        STRIDE      : integer := 1;
        USE_FLOAT   : boolean := false  -- Define se o cálculo é em ponto flutuante ou inteiro
    );
    port (
        clk           : in  std_logic;
        reset         : in  std_logic;
        input_matrix  : in  std_logic_vector(MATRIX_SIZE*MATRIX_SIZE*DATA_WIDTH-1 downto 0);
        kernel        : in  std_logic_vector(KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1 downto 0);
        output_matrix : out std_logic_vector(((MATRIX_SIZE - KERNEL_SIZE) / STRIDE + 1) * ((MATRIX_SIZE - KERNEL_SIZE) / STRIDE + 1) * DATA_WIDTH - 1 downto 0)
    );
end convolution;

architecture Behavioral of convolution is

    function multiply_int(a, b : std_logic_vector(DATA_WIDTH-1 downto 0)) return std_logic_vector is
        variable result : integer;
    begin
        result := to_integer(signed(a)) * to_integer(signed(b));
        return std_logic_vector(to_signed(result, DATA_WIDTH));
    end function;

    function add_int(a, b : std_logic_vector(DATA_WIDTH-1 downto 0)) return std_logic_vector is
    begin
        return std_logic_vector(signed(a) + signed(b));
    end function;

    function multiply_float(a, b : std_logic_vector(DATA_WIDTH-1 downto 0)) return std_logic_vector is
        variable fa, fb, result : float32;
    begin
        fa := to_float(signed(a));
        fb := to_float(signed(b));
        result := fa * fb;
        return to_slv(to_sfixed(result, 31, 0));
    end function;

    function add_float(a, b : std_logic_vector(DATA_WIDTH-1 downto 0)) return std_logic_vector is
        variable fa, fb, result : float32;
    begin
        fa := to_float(signed(a));
        fb := to_float(signed(b));
        result := fa + fb;
        return to_slv(to_sfixed(result, 31, 0));
    end function;

    type matrix_type is array (0 to (((MATRIX_SIZE - KERNEL_SIZE) / STRIDE + 1) * ((MATRIX_SIZE - KERNEL_SIZE) / STRIDE + 1)) - 1) of std_logic_vector(DATA_WIDTH-1 downto 0);

    signal matrix_out : matrix_type;

begin

    process(clk, reset)
    variable result, accumulator : std_logic_vector(DATA_WIDTH-1 downto 0);
    variable index: integer;
    begin
        if reset = '1' then
            accumulator := (others => '0');
            output_matrix <= (others => '0');
        elsif rising_edge(clk) then
            for i in 0 to (MATRIX_SIZE - KERNEL_SIZE) / STRIDE loop
                for j in 0 to (MATRIX_SIZE - KERNEL_SIZE) / STRIDE loop
                    accumulator := (others => '0');
                    for ki in 0 to KERNEL_SIZE-1 loop
                        for kj in 0 to KERNEL_SIZE-1 loop
                            if (i*STRIDE + ki < MATRIX_SIZE) and (j*STRIDE + kj < MATRIX_SIZE) then
				if not USE_FLOAT then --Usa as funções de calculo em integer
                                result := multiply_int(
                                    input_matrix((i*STRIDE + ki)*MATRIX_SIZE*DATA_WIDTH + (j*STRIDE + kj)*DATA_WIDTH + DATA_WIDTH-1 downto (i*STRIDE + ki)*MATRIX_SIZE*DATA_WIDTH + (j*STRIDE + kj)*DATA_WIDTH),
                                    kernel((ki*KERNEL_SIZE + kj)*DATA_WIDTH + DATA_WIDTH-1 downto (ki*KERNEL_SIZE + kj)*DATA_WIDTH)
                                );
                                accumulator := add_int(accumulator, result);
                            else  --Usa as funções de calculo em float

                                result := multiply_float(
                                    input_matrix((i*STRIDE + ki)*MATRIX_SIZE*DATA_WIDTH + (j*STRIDE + kj)*DATA_WIDTH + DATA_WIDTH-1 downto (i*STRIDE + ki)*MATRIX_SIZE*DATA_WIDTH + (j*STRIDE + kj)*DATA_WIDTH),
                                    kernel((ki*KERNEL_SIZE + kj)*DATA_WIDTH + DATA_WIDTH-1 downto (ki*KERNEL_SIZE + kj)*DATA_WIDTH)
                                );
	--	report "----------: " &  " Value: " & integer'image(to_integer(signed(result)));
                                accumulator := add_float(accumulator, result);
                                end if;
                            end if;
                        end loop;
                    end loop;
                    
                    index := i * ((MATRIX_SIZE - KERNEL_SIZE) / STRIDE + 1) + j;
                    matrix_out(index) <= accumulator;
--report "Index: " & integer'image(index) & " Value: " & integer'image(to_integer(signed(matrix_out(index))));

                end loop;
            end loop;
            
            for idx in 0 to ((((MATRIX_SIZE - KERNEL_SIZE) / STRIDE + 1) * ((MATRIX_SIZE - KERNEL_SIZE) / STRIDE + 1)) - 1) loop
                output_matrix((idx + 1) * DATA_WIDTH - 1 downto idx * DATA_WIDTH) <= matrix_out(idx);
            end loop;
        end if;
    end process;

end Behavioral;
