module mantenimiento_fsm (
    input logic clk,           // Reloj
    input logic reset,         // Señal de reset
    input logic mantenimiento, // Botón de mantenimiento
    output logic [7:0] estado, // Estado actual de la FSM
    output logic [7:0] num_mantenimientos, // Contador de mantenimientos
    output logic terminado     // Señal de fin
);

    // Definir los estados
    typedef enum logic [1:0] {
        ESPERA        = 2'b00,
        MANTENIMIENTO = 2'b01,
        ERROR         = 2'b10
    } estados_t;

    estados_t estado_actual, estado_siguiente;
    logic [7:0] contador; // Contador de ciclos
    logic [7:0] contador_mantenimiento;

    // Lógica secuencial: Cambio de estado y contador de ciclos en el flanco del reloj
    always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        estado_actual <= ESPERA;  // Corrección: Inicializa el estado
        contador <= 8'd0;
        contador_mantenimiento <= 8'd0;
        num_mantenimientos <= 8'd0;
    end else begin
        estado_actual <= estado_siguiente;  // Asegura que el estado se actualiza siempre
        // Contador de ciclos
        if (estado_actual == MANTENIMIENTO) begin
            contador <= contador + 1;
        end else begin
            contador <= 8'd0;  // Reinicia el contador fuera del mantenimiento
        end

        // Actualización del contador de mantenimientos
        if (estado_actual == MANTENIMIENTO && mantenimiento) begin
            contador_mantenimiento <= contador_mantenimiento + 1;
            num_mantenimientos <= contador_mantenimiento;
        end else if (estado_actual != MANTENIMIENTO) begin
            contador_mantenimiento <= contador_mantenimiento;
        end

        // Estado de error
        if (estado_actual == ERROR) begin
            num_mantenimientos <= 8'hFF;
        end
    end
end


    // Lógica combinacional: Definir los estados siguientes
    always_comb begin
        estado_siguiente = estado_actual;  // Valor por defecto
        terminado = 1'b0;  // Señal de terminado por defecto

        case (estado_actual)
            ESPERA: begin
                if (mantenimiento) begin
                    estado_siguiente = MANTENIMIENTO;
                end
            end

            MANTENIMIENTO: begin
                if (contador >= 8'd200) begin
                    estado_siguiente = ERROR; // Si excede 200 ciclos, ir a ERROR
                end else if (!mantenimiento) begin  // Cambio: esperar que `mantenimiento` sea 0 para salir
                    estado_siguiente = ESPERA; // Volver a ESPERA después del mantenimiento
                end
            end

            ERROR: begin
                terminado = 1'b1; // Estado de error, señal de terminado
            end

            default: estado_siguiente = ESPERA; // Estado por defecto
        endcase
    end

endmodule
