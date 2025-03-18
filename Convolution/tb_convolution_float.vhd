
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.float_pkg.all;
use work.fixed_pkg.ALL;

entity tb_convolution_float is
end tb_convolution_float;

architecture TB of tb_convolution_float is

    -- Parâmetros da matriz e do kernel
    constant MATRIX_SIZE : integer := 3;  -- Matriz 3x3
    constant KERNEL_SIZE : integer := 2;  -- Kernel 2x2
    constant STRIDE      : integer := 1;
    constant DATA_WIDTH  : integer := 32;
constant USE_FLOAT : boolean := True;

    signal input_matrix   : std_logic_vector(MATRIX_SIZE*MATRIX_SIZE*DATA_WIDTH-1 downto 0);
    signal kernel : std_logic_vector(KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1 downto 0);


    signal clk : std_logic := '0';
    signal reset : std_logic := '1';

    -- Saída do módulo de convolução
    constant OUTPUT_SIZE : integer := ((MATRIX_SIZE - KERNEL_SIZE) / STRIDE + 1) * ((MATRIX_SIZE - KERNEL_SIZE) / STRIDE + 1);
    signal output_val : std_logic_vector(OUTPUT_SIZE * DATA_WIDTH - 1 downto 0);

    -- Declaração do componente de convolução
    component convolution
        Generic (
            KERNEL_SIZE : integer;
            MATRIX_SIZE : integer;
            DATA_WIDTH  : integer;
            STRIDE      : integer;
	    USE_FLOAT : boolean

        );
        Port (
            clk       : in std_logic;
            reset     : in std_logic;
            input_matrix : in std_logic_vector(MATRIX_SIZE*MATRIX_SIZE*DATA_WIDTH-1 downto 0);
            kernel    : in std_logic_vector(KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1 downto 0);
            output_matrix : out std_logic_vector(OUTPUT_SIZE * DATA_WIDTH - 1 downto 0)
        );
    end component;

begin

    -- Instanciação do módulo de convolução
    UUT: convolution 
        generic map (
            MATRIX_SIZE => MATRIX_SIZE,
            KERNEL_SIZE => KERNEL_SIZE,
            STRIDE      => STRIDE,
            DATA_WIDTH  => DATA_WIDTH,
 	    USE_FLOAT   => USE_FLOAT
        )
        port map (
            clk       => clk,
            reset     => reset,
            input_matrix => input_matrix,
            kernel    => kernel,
            output_matrix => output_val
        );

    -- Processo de clock
    process
    begin
        while now < 100 ns loop
            clk <= not clk;
            wait for 5 ns;
        end loop;
        wait;
    end process;

    -- Estímulos de entrada e verificação da saída
    process
type float32_array is array (0 to OUTPUT_SIZE * DATA_WIDTH - 1) of float32;
    variable output_values: float32_array;

    type matrix_type is array (0 to (((MATRIX_SIZE - KERNEL_SIZE) / STRIDE + 1) * ((MATRIX_SIZE - KERNEL_SIZE) / STRIDE + 1)) - 1) of std_logic_vector(DATA_WIDTH-1 downto 0);

    variable matrix_out : matrix_type;

    begin
        wait for 10 ns;
        reset <= '0';  -- Libera o reset

        -- Aguarda o processamento da convolução
        wait for 50 ns;
input_matrix  <= to_slv(to_float(0)) & 
		to_slv(to_float(0)) &
		to_slv(to_float(0)) & 
		to_slv(to_float(0)) & 
		to_slv(to_float(1)) & 
		to_slv(to_float(0)) & 
		to_slv(to_float(0)) & 
		to_slv(to_float(1)) & 
		to_slv(to_float(0));

kernel  <= to_slv(to_float(1)) & 
	to_slv(to_float(1)) &
	to_slv(to_float(1)) & 
	to_slv(to_float(1));
  wait for 50 ns;
        -- Extrai cada valor da saída
for i in 0 to OUTPUT_SIZE-1 loop
output_values(i) := (to_float(signed(output_val((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH))));
matrix_out(i) := output_val((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH);


end loop;



        -- Exibe os resultados
        report "Resultados da convolução:";
        for i in 0 to (OUTPUT_SIZE-1) loop
report "output[" & integer'image(i) & "] = " & to_string(output_values(i));


        end loop;

        -- Finaliza o testbench
        assert false report "Testbench finalizado!" severity note;
        wait;
    end process;

end TB;
