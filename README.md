# File Pod
Esta aplicacion está diseñada para permitir a los usuarios transferir archivos de manera rápida y sencilla utilizando Flutter. El proceso de transferencia de archivos se realiza de la siguiente manera:

1 - El usuario carga un archivo desde su dispositivo utilizando la interfaz de usuario proporcionada.  
2 - El archivo seleccionado se envía al servidor a través de una conexión socket.  
3 - Una vez que el servidor recibe el archivo, devuelve un UID único que identifica ese archivo en particular.  
4 - Utilizando este UID, se genera un enlace de descarga y un código QR correspondiente.  
5 - El usuario puede compartir el enlace de descarga o el código QR con otros para permitirles iniciar la descarga del archivo.  

## Frontend

![](https://github.com/user-attachments/assets/50f38f18-b7bd-43dd-b358-618c4bd0d9af)

## Backend
![](https://github.com/user-attachments/assets/80784576-6362-4dbb-ae5e-3a6560792cc8)

El componente backend de FilePod se puede encontrar en el siguiente repositorio: [FilePod Backend](https://github.com/elialm7/filepod-backend-node).
