                                                                      acerta.sh                                                                                   
#!/bin/bash

# Configuración
BUCKET_NAME="acerta"  # Reemplaza con el nombre de tu bucket
DEST_DIR="/home/backups/acerta"  # Reemplaza con la ruta donde quieres guardar el backup temporalmente
ZIP_DIR="/home/backups/acerta"  # Reemplaza con la ruta donde quieres guardar el archivo zip
LOG_FILE="$DEST_DIR/log_backup.txt"  # Archivo de log para guardar los resultados del backup
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")  # Para agregar un timestamp al archivo zip
ZIP_FILE="$ZIP_DIR/backup_$TIMESTAMP.zip"  # Nombre del archivo zip final

# Mensaje de inicio
echo "Iniciando el backup de R2 Bucket: $BUCKET_NAME"

# Comando para hacer el backup del bucket R2 a una carpeta local
rclone sync "r2 acerta prod":$BUCKET_NAME $DEST_DIR --log-file=$LOG_FILE --log-level INFO

# Verificar si el backup fue exitoso
if [ $? -eq 0 ]; then
    echo "Backup completado exitosamente. Comenzando a comprimir..."

    # Comprimir el backup en un archivo zip
    zip -r $ZIP_FILE $DEST_DIR

    # Verificar si la compresión fue exitosa
    if [ $? -eq 0 ]; then
        echo "Backup comprimido exitosamente en $ZIP_FILE"
    else
        echo "Error al comprimir el backup"
        exit 1
    fi
else
    echo "Error en el proceso de backup. Revisa el log: $LOG_FILE"
    exit 1
fi

# Limpieza opcional: Eliminar el directorio temporal si deseas ahorrar espacio
# rm -rf $DEST_DIR

echo "Proceso de backup y compresión completado."





[r2 acerta prod]
type = s3
provider = Cloudflare
access_key_id = ffc25cebcc8c48ce2f6ef1fd5a01be78
secret_access_key = de90468f41031cdcb713dd9fcb83dba84eb9da083db17765d26f216710235171
region = auto
endpoint = https://b2e5858884199e9cbc1e6e99b3e0358d.r2.cloudflarestorage.com