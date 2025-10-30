# 📁 File Pod

File Pod es una aplicación desarrollada en **Flutter** que permite transferir archivos de forma rápida, sencilla y segura entre dispositivos mediante un servidor con **sockets**.  

## 🚀 Características principales

- Carga de archivos desde el dispositivo.
- Envío de archivos al servidor mediante conexión **socket**.
- Generación automática de un **UID único** para cada archivo.
- Creación de **enlace de descarga** y **código QR** para compartir fácilmente.
- Descarga directa del archivo desde cualquier dispositivo.

---

## 🖼️ Vista general

### Frontend (Flutter)
<img src="https://github.com/user-attachments/assets/f4025b0a-a158-48c1-9789-05593a9ba216" width="700"/>

### Backend (Servidor con Socket)
<img src="https://github.com/user-attachments/assets/4115c33a-e0bb-41a4-b00c-b299127ab028" width="700"/>

---

## ⚙️ Flujo de funcionamiento

1️⃣ El usuario selecciona un archivo desde su dispositivo.  
2️⃣ El archivo se envía al servidor mediante socket.  
3️⃣ El servidor genera un **UID** y lo devuelve al cliente.  
4️⃣ Se crea un **link de descarga** y un **QR** asociados a ese UID.  
5️⃣ Otros usuarios pueden descargar el archivo escaneando el QR o usando el enlace.

---

## 🧩 Tecnologías utilizadas

- **Frontend:** Flutter  
- **Backend:** Node.js / Socket.IO  
- **Comunicación:** WebSockets  
- **QR:** Paquete `qr_flutter`

---

## 🏗️ Instalación y uso

### 1. Clonar el repositorio
```bash
git clone https://github.com/tuusuario/file_pod.git


