# File Pod
Esta aplicacion está diseñada para permitir a los usuarios transferir archivos de manera rápida y sencilla utilizando Flutter. El proceso de transferencia de archivos se realiza de la siguiente manera:

1 - El usuario carga un archivo desde su dispositivo utilizando la interfaz de usuario proporcionada.
2 - El archivo seleccionado se envía al servidor a través de una conexión socket.
3 - Una vez que el servidor recibe el archivo, devuelve un UID único que identifica ese archivo en particular.
4 - Utilizando este UID, se genera un enlace de descarga y un código QR correspondiente.
5 - El usuario puede compartir el enlace de descarga o el código QR con otros para permitirles iniciar la descarga del archivo.
