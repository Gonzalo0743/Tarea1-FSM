module tb_mantenimiento_fsm;

    logic clk;
    logic reset;
    logic iniciar;
    logic detener;
    logic [7:0] estado;
    logic [7:0] num_mantenimientos;
    logic terminado;

    // Instancia del módulo FSM
    mantenimiento_fsm uut (
        .clk(clk),
        .reset(reset),
        .iniciar(iniciar),
        .detener(detener),
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
        iniciar = 0;
        detener = 0;

        #10 reset = 0;  // Salir de reset

        #10 iniciar = 1;  // Iniciar la FSM
        #10 iniciar = 0;

        #50 detener = 1;  // Detener la FSM
        #10 detener = 0;

        #50 $finish;  // Finalizar la simulación
    end

endmodule
