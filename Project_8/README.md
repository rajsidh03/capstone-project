# Project 8: Build and Run a Docker App Locally

A small Flask web app packaged in a Docker image and run in a container.

## Build and run
    docker build -t p8-flask-app .
    docker run -d --name p8-app -p 8080:5000 p8-flask-app
    # open http://localhost:8080

## Stop and clean up
    docker stop p8-app && docker rm p8-app
    docker rmi p8-flask-app
