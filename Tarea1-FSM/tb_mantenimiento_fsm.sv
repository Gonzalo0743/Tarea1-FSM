module tb_mantenimiento_fsm;

    // Señales de prueba
    logic clk;
    logic reset;
    logic mantenimiento;  // Señal para activar/desactivar mantenimiento
    logic [7:0] estado;   // Estado de la FSM
    logic [7:0] num_mantenimientos;  // Contador de mantenimientos
    logic terminado;  // Señal que indica si el mantenimiento ha terminado

    // Instancia del módulo FSM
    mantenimiento_fsm uut (
        .clk(clk),
        .reset(reset),
        .mantenimiento(mantenimiento),
        .estado(estado),
        .num_mantenimientos(num_mantenimientos),
        .terminado(terminado)
    );

    // Generador de reloj con un periodo de 10 unidades de tiempo
    always #5 clk = ~clk;

    // Monitor para visualizar los cambios en las señales importantes
    initial begin
        $monitor("Time=%0t | clk=%b | reset=%b | mantenimiento=%b | estado=%b | num_mantenimientos=%b | terminado=%b", 
                 $time, clk, reset, mantenimiento, estado, num_mantenimientos, terminado);
    end

    // Bloque inicial para definir las pruebas
    initial begin
        // Inicializar señales
        clk = 0;
        reset = 1;
        mantenimiento = 0;

        // Aplicar reset
        #10 reset = 0;  // Salir de reset
        $display("Reset desactivado");

        // Primera prueba: Iniciar un ciclo de mantenimiento normal
        #10 mantenimiento = 1;
        $display("Iniciando primer ciclo de mantenimiento");
        #100 mantenimiento = 0;  // Después de 100 unidades de tiempo, salir de mantenimiento
        $display("Mantenimiento terminado");

        // Esperar un tiempo para observar el comportamiento después del mantenimiento
        #50;

        // Segunda prueba: Iniciar otro ciclo de mantenimiento
        #10 mantenimiento = 1;
        $display("Iniciando segundo ciclo de mantenimiento");
        #100 mantenimiento = 0;  // Terminar el segundo ciclo de mantenimiento
        $display("Segundo mantenimiento terminado");

        // Esperar para observar la salida
        #50;

        // Tercera prueba: Forzar estado de error al exceder los ciclos de mantenimiento permitidos
        #10 mantenimiento = 1;
        $display("Forzando error al exceder los ciclos de mantenimiento");
        #500 mantenimiento = 0;  // Mantener el mantenimiento activado por más de 200 ciclos
        $display("Error forzado, estado de ERROR alcanzado");

        // Esperar un tiempo para observar la transición al estado de ERROR
        #100 $finish;  // Finalizar la simulación
    end

endmodule
