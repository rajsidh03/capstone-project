# Project 8: Build and Run a Docker App Locally

A small Flask web app packaged in a Docker image and run in a container.

## Build and run
    docker build -t p8-flask-app .
    docker run -d --name p8-app -p 8080:5000 p8-flask-app
    # open http://localhost:8080

## Stop and clean up
    docker stop p8-app && docker rm p8-app
    docker rmi p8-flask-app

<img width="1910" height="819" alt="Screenshot 2026-11-24 121730" src="https://github.com/user-attachments/assets/91c1c40d-17e1-42fa-ac2a-8af5683e8fda" />
<img width="1910" height="803" alt="Screenshot 2026-11-24 121707" src="https://github.com/user-attachments/assets/65a8454a-9d05-40ea-83a8-ce108f5b0836" />

