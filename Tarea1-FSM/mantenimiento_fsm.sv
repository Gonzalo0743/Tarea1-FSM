module mantenimiento_fsm (
    input logic clk,           // Reloj
    input logic reset,         // Señal de reset
    input logic iniciar,       // Señal de inicio
    input logic detener,       // Señal de detener
    output logic [7:0] estado, // Estado actual de la FSM
    output logic [7:0] num_mantenimientos,  // Contador de mantenimientos
    output logic terminado     // Señal de fin
);

    // Definir los estados
    typedef enum logic [2:0] {
        ESPERA     = 3'b000,
        INICIAR    = 3'b001,
        MANTENIMIENTO = 3'b010,
        FINALIZAR  = 3'b011
    } estados_t;

    estados_t estado_siguiente, estado_actual;
    logic [7:0] contador;

    // Lógica secuencial: Cambio de estado en el flanco del reloj
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            estado_actual <= ESPERA;
            contador <= 8'd0;
            num_mantenimientos <= 8'd0;
        end
        else begin
            estado_actual <= estado_siguiente;
            if (estado_actual == MANTENIMIENTO) begin
                contador <= contador + 1;
            end
            if (estado_actual == FINALIZAR) begin
                num_mantenimientos <= contador;
            end
        end
    end

    // Lógica combinacional: Definición de los estados siguientes
    always_comb begin
        estado_siguiente = estado_actual;  // Valor por defecto
        terminado = 1'b0;  // Señal de terminado por defecto

        case (estado_actual)
            ESPERA: begin
                if (iniciar) begin
                    estado_siguiente = INICIAR;
                end
            end
            INICIAR: begin
                estado_siguiente = MANTENIMIENTO;
            end
            MANTENIMIENTO: begin
                if (detener) begin
                    estado_siguiente = FINALIZAR;
                end
            end
            FINALIZAR: begin
                terminado = 1'b1;  // Señal de fin de operación
                estado_siguiente = ESPERA;
            end
            default: estado_siguiente = ESPERA;
        endcase
    end

endmodule
