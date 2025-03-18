library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.float_pkg.all;
use work.fixed_pkg.ALL;

entity tb_convolution_int is
end tb_convolution_int;

architecture TB of tb_convolution_int is

    -- Parâmetros da matriz e do kernel
    constant MATRIX_SIZE : integer := 4;  -- Matriz 3x3
    constant KERNEL_SIZE : integer := 2;  -- Kernel 2x2
    constant STRIDE      : integer := 1;
    constant DATA_WIDTH  : integer := 8;

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
            STRIDE      : integer
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
            DATA_WIDTH  => DATA_WIDTH
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
           type integer_array is array (natural range <>) of integer;
    variable output_values : integer_array(0 to OUTPUT_SIZE-1);
    begin
        wait for 10 ns;
        reset <= '0';  -- Libera o reset

        -- Aguarda o processamento da convolução
        wait for 50 ns;
input_matrix  <= std_logic_vector(to_signed( 0, DATA_WIDTH)) & 
           std_logic_vector(to_signed( 0, DATA_WIDTH)) & 
           std_logic_vector(to_signed( 0, DATA_WIDTH)) & 
           std_logic_vector(to_signed( 0, DATA_WIDTH)) & 
           std_logic_vector(to_signed( 0, DATA_WIDTH)) & 
           std_logic_vector(to_signed( 1, DATA_WIDTH)) & 
           std_logic_vector(to_signed( 0, DATA_WIDTH)) & 
           std_logic_vector(to_signed( 0, DATA_WIDTH)) & 
           std_logic_vector(to_signed( 0, DATA_WIDTH)) &
           std_logic_vector(to_signed( 2, DATA_WIDTH)) &
           std_logic_vector(to_signed( 1, DATA_WIDTH)) &
           std_logic_vector(to_signed( 1, DATA_WIDTH)) &
           std_logic_vector(to_signed( 0, DATA_WIDTH)) &
           std_logic_vector(to_signed( 4, DATA_WIDTH)) &
           std_logic_vector(to_signed( 1, DATA_WIDTH)) &
           std_logic_vector(to_signed( 2, DATA_WIDTH));

kernel  <= std_logic_vector(to_signed( 0, DATA_WIDTH)) & 
           std_logic_vector(to_signed( 0, DATA_WIDTH)) & 
	   std_logic_vector(to_signed( -1, DATA_WIDTH)) & 
           std_logic_vector(to_signed( 0, DATA_WIDTH));
  wait for 50 ns;
        -- Extrai cada valor da saída
        for i in 0 to OUTPUT_SIZE-1 loop
            output_values(i) := to_integer(signed(output_val((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH)));
        end loop;

        -- Exibe os resultados
        report "Resultados da convolução:";
        for i in 0 to (OUTPUT_SIZE-1) loop
            report "output[" & integer'image(i) & "] = " & integer'image(output_values(i));
        end loop;

        -- Finaliza o testbench
        assert false report "Testbench finalizado!" severity note;
        wait;
    end process;

end TB;
