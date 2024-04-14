#!/bin/bash

# Ruta al archivo registros.csv
archivo="/workspaces/proFinal/registros.csv"

# Eliminar el símbolo de dólar del campo de precio
sed -i 's/\$//' "$archivo"

# Función para obtener el TOP 10 de los productos más vendidos
obtener_top_10() {
    echo "TOP 10 de productos más vendidos:"
    awk -F',' '{print $4}' "$archivo" | sort | uniq -c | sort -nr | head -10
    echo "*****************************************************"
}

# Función para calcular el total de ingresos por categoría
total_por_categoria() {
    echo "Total de ingresos por categoría:"
    awk -F',' '{sum[$3]+=$5} END {for (i in sum) if (i != "" && i != "Categoria") printf "%s: $%.2f\n", i, sum[i]}' "$archivo"
    echo "*****************************************************"
}

# Función para calcular el total de ingresos por mes
total_por_mes() {
    echo "Total de ingresos por mes:"
    declare -A month_names=( [1]="Enero" [2]="Febrero" [3]="Marzo" [4]="Abril" [5]="Mayo" [6]="Junio" [7]="Julio" [8]="Agosto" [9]="Septiembre" [10]="Octubre" [11]="Noviembre" [12]="Diciembre" )
    awk -F',' '{split($1, date, "/"); month[date[2]]+=$5} END {for (i=1; i<=12; i++) if (month[i] != "") printf "%s: $%.2f\n", month_names[i], month[i]}' "$archivo"
    echo "*****************************************************"
}

# Función para calcular el total de ingresos por cliente
total_por_cliente() {
    echo "Ingresos por clientes:"
    awk -F',' '{sum[$6]+=$5} END {for (i in sum) if (i != "" && i != "Cliente") printf "%s: $%.2f\n", i, sum[i]}' "$archivo"
    echo "*****************************************************"
}

# Función para calcular el total de ingresos por departamento
total_por_departamento() {
    echo "Total de ingresos por departamento:"
    awk -F',' '{sum[$7]+=$5} END {for (i in sum) if (i != "" && i != "Departamento") printf "%s: $%.2f\n", i, sum[i]}' "$archivo"
    echo "*****************************************************"
}

# Ejecución de las funciones
{
    obtener_top_10
    total_por_categoria
    total_por_mes
    total_por_cliente
    total_por_departamento
} >> /workspaces/proFinal/reporte.txt 2>&1
