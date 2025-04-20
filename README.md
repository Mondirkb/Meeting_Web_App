# 🧠 Face Recognition Login & Meeting Web App

This is a web application built with **Flask**, **OpenCV**, and **face_recognition** for secure face-based login. It includes user registration, authentication, and a simple meeting interface.  

> 📌 Ideal for real-world multimedia service projects where image processing and face recognition are used under limited network conditions.

---

## 🚀 Features

- 📸 Face recognition login and registration.
- 🔐 User authentication via image (not password).
- 🧾 Flask-Login + SQLAlchemy-based session handling.
- 🧠 Uses OpenCV and face_recognition for encoding and matching.
- 💻 Dashboard and meeting room interface after login.

---

## 🧰 Tech Stack

- **Flask** + **WTForms** + **Jinja2**
- **OpenCV** + **face_recognition**
- **SQLite3** with **SQLAlchemy ORM**
- **HTML5 + JavaScript (Webcam + Blob capture)**
- Tested with **Ubuntu 22.04**, **Python 3.10+**

---

## 📸 Face Login Logic

- On registration, a face image is captured via webcam and encoded using `face_recognition`.
- On login, a fresh image is captured and compared against the stored encoding.
- Match → login success. No match → access denied.

---

## 🛠️ Installation

```bash
git clone https://github.com/Mondirkb/Meeting_Web_App.git
cd face-login-meeting-app
pip install -r requirements.txt
```
## 🐳 Docker Deployment

You can run this face recognition Flask app inside a Docker container easily. Here's how:

### 📁 Prerequisites

- [Docker](https://www.docker.com/products/docker-desktop) installed on your system.

### 📦 Build the Docker Image

```bash
docker build -t face-recognition-app .

▶ Run Docker Container
docker run -it --rm -p 5000:5000 face-recognition-app
```


