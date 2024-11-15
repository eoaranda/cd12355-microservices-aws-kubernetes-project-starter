FROM python:3.10-slim-buster

# Install Postgres and configure a username + password
USER root

ARG DB_USERNAME=$DB_USERNAME
ARG DB_PASSWORD=$DB_PASSWORD
ARG DB_HOST=$DB_HOST   
ARG DB_PORT=$DB_PORT    
ARG DB_NAME=$DB_NAME

# Install any required Python dependencies (adjust this according to your needs)
WORKDIR /src

# Update and install the PostgreSQL client
RUN apt-get update && apt-get install -y postgresql-client build-essential libpq-dev curl

COPY ./analytics/requirements.txt requirements.txt

RUN pip install -r requirements.txt

COPY ./analytics .

# Expose the port your app will be running on (ensure it's the same as the one used in your app)
EXPOSE 5153

# Start the database and Flask application
CMD python app.py
