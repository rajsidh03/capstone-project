# Project 8: Build and Run a Docker App Locally

A small Flask web app packaged in a Docker image and run in a container.

## Build and run
    docker build -t p8-flask-app .
    docker run -d --name p8-app -p 8080:5000 p8-flask-app
    # open http://localhost:8080

## Stop and clean up
    docker stop p8-app && docker rm p8-app
    docker rmi p8-flask-app

<img width="1919" height="992" alt="Screenshot 2026-11-25 135448" src="https://github.com/user-attachments/assets/eec5a476-e72a-4256-9505-8b7b07745589" />
<img width="1918" height="987" alt="Screenshot 2026-11-25 135724" src="https://github.com/user-attachments/assets/8b068255-e09b-4594-9a9c-cc1fd0d0561c" />


