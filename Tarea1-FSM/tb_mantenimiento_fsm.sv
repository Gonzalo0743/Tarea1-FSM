module tb_mantenimiento_fsm;

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

    // Generador de reloj
    always #5 clk = ~clk;

    // Estímulos de prueba
    initial begin
        $dumpfile("mantenimiento_fsm.vcd");
        $dumpvars(0, tb_mantenimiento_fsm);

        // Inicializar señales
        clk = 0;
        reset = 1;
        mantenimiento = 0;

        // Ciclo inicial de reset
        #10 reset = 0;  // Salir de reset

        // Iniciar el primer ciclo de mantenimiento
        #10 mantenimiento = 1;
        #10 mantenimiento = 0;

        // Esperar un tiempo y observar el comportamiento
        #100;

        // Probar otro ciclo de mantenimiento
        #10 mantenimiento = 1;
        #10 mantenimiento = 0;

        // Dejar suficiente tiempo para observar las transiciones de estados
        #200;

        // Forzar el estado de error superando los 200 ciclos de mantenimiento
        #10 mantenimiento = 1;
        #500 mantenimiento = 0; // Esto debería llevar al estado de ERROR

        #100 $finish;  // Finalizar la simulación
    end

    // Monitoreo de las señales para seguimiento
    initial begin
        $monitor("Time=%0t | clk=%b | reset=%b | mantenimiento=%b | estado=%b | num_mantenimientos=%b | terminado=%b", 
                $time, clk, reset, mantenimiento, estado, num_mantenimientos, terminado);
    end

endmodule
