library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity convolution_Int is
    generic (
        KERNEL_SIZE : integer := 2;  -- Tamanho do kernel
        MATRIX_SIZE : integer := 3; -- Tamanho da matriz de entrada
        DATA_WIDTH  : integer := 8;   -- Largura dos dados
        STRIDE: integer := 1         -- Passo/Stride
    );
    port (
        clk           : in  std_logic;
        reset         : in  std_logic;
        input_matrix  : in  std_logic_vector(MATRIX_SIZE*MATRIX_SIZE*DATA_WIDTH-1 downto 0);  -- Dados matriz de entrada
        kernel        : in  std_logic_vector(KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1 downto 0);  -- Dados kernel
        output_matrix : out std_logic_vector(((MATRIX_SIZE - KERNEL_SIZE) / STRIDE + 1) * ((MATRIX_SIZE - KERNEL_SIZE) / STRIDE + 1) * DATA_WIDTH - 1 downto 0));
end convolution_Int;

--Cálculo do tamanho da matriz de saída é:
--Saida = ((entrada - kernel) / passo + 1) * ((entrada - kernel) / passo + 1)
--Entrada 28x28, Kernel 3x3, Stride 1 a saída será 26*26.

architecture Behavioral of convolution_Int is

    -- Implementação de multiplicação de dois números inteiros TRATAR OVERFLOW??
    function multiply(a, b : std_logic_vector(DATA_WIDTH-1 downto 0)) return std_logic_vector is
        variable result_int : integer;  
        variable a_int, b_int : integer; 
    begin
        a_int := to_integer(signed(a)); 
        b_int := to_integer(signed(b));  
        result_int := a_int * b_int;     
        return std_logic_vector(to_signed(result_int, DATA_WIDTH)); 
    end function;

-- Implementação de soma considerando inteiros com sinal
    function add(a, b : std_logic_vector(DATA_WIDTH-1 downto 0)) return std_logic_vector is
       variable result : std_logic_vector(DATA_WIDTH-1 downto 0);
    begin
        result := std_logic_vector(signed(a) + signed(b)); 
        return result;  
    end function;

    type matrix_type is array (0 to (((MATRIX_SIZE - KERNEL_SIZE) / STRIDE + 1) * ((MATRIX_SIZE - KERNEL_SIZE) / STRIDE + 1))) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal matrix_out : matrix_type;  -- Matriz temporária para armazenar os resultados da convolução
begin

    process(clk, reset)
    variable result : std_logic_vector(DATA_WIDTH-1 downto 0);  -- Resultado da multiplicação
    variable accumulator : std_logic_vector(DATA_WIDTH - 1 downto 0); -- Para suportar a soma sem overflow
variable index: integer;
begin
    if reset = '1' then
        accumulator := (others => '0');
        output_matrix <= (others => '0');
    elsif rising_edge(clk) then
        for i in 0 to (MATRIX_SIZE - KERNEL_SIZE) / STRIDE loop
            for j in 0 to (MATRIX_SIZE - KERNEL_SIZE) / STRIDE loop
                accumulator := (others => '0'); -- Resetar o acumulador para cada nova posição do kernel
                
                for ki in 0 to KERNEL_SIZE-1 loop
                    for kj in 0 to KERNEL_SIZE-1 loop
                        if (i*STRIDE + ki < MATRIX_SIZE) and (j*STRIDE + kj < MATRIX_SIZE) then
		--É calculado de baixo para cima (bits menos significativos)
                            result := multiply(input_matrix((i*STRIDE + ki)*MATRIX_SIZE*DATA_WIDTH + (j*STRIDE + kj)*DATA_WIDTH + DATA_WIDTH-1 downto (i*STRIDE + ki)*MATRIX_SIZE*DATA_WIDTH + (j*STRIDE + kj)*DATA_WIDTH),
                                               kernel((ki*KERNEL_SIZE + kj)*DATA_WIDTH + DATA_WIDTH-1 downto (ki*KERNEL_SIZE + kj)*DATA_WIDTH));
                            
                            accumulator := add(accumulator, result);
                        end if;
                    end loop;
                end loop;
                
                index := i * ((MATRIX_SIZE - KERNEL_SIZE) / STRIDE + 1) + j;
                    matrix_out(index) <= accumulator;
		end loop;
        end loop;
            for idx in 0 to index loop
                output_matrix((idx + 1) * DATA_WIDTH - 1 downto idx * DATA_WIDTH) <= matrix_out(idx);
            end loop;
    end if;
end process;

end Behavioral;