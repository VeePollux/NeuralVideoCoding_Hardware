library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Convolution_Testbench is
end Convolution_Testbench;

architecture TB of Convolution_Testbench is

    -- Parâmetros da matriz e do kernel
    constant MATRIX_SIZE : integer := 3;  -- Matriz 3x3
    constant KERNEL_SIZE : integer := 2;  -- Kernel 2x2
    constant STRIDE      : integer := 1;
    constant DATA_WIDTH  : integer := 8;

    signal clk : std_logic := '0';
    signal reset : std_logic := '1';


    signal input_matrix : std_logic_vector(MATRIX_SIZE*MATRIX_SIZE*DATA_WIDTH-1 downto 0) := (
        "000000000000000000000001000000000000000000000010000000010000001000000000");


    signal kernel : std_logic_vector(KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1 downto 0) := (
        "00000001000000000000000000000001"
    );

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
            MATRIX_SIZE => 3,
            KERNEL_SIZE => 2,
            STRIDE      => 1,
            DATA_WIDTH  => 8
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

    -- Estímulos de entrada
    process
    begin
        wait for 10 ns;
        reset <= '0';  -- Libera o reset

        -- Aguarda o processamento da convolução
        wait for 50 ns;

        -- Exibe a saída no console (convertendo std_logic_vector para integer)
        report "Saída da convolução: " & integer'image(to_integer(unsigned(output_val)));

        -- Finaliza o testbench
        assert false report "Testbench finalizado!" severity note;
        wait;
    end process;

end TB;