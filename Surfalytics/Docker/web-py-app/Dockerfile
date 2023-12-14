# Use and official Python runtime as a parent iamge

FROM python:3.11

# Set the working directory in the containers
WORKDIR /app

#Cope the current directory contents into the container at /app
COPY . /app

# Install ant needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Make port 80 available to the world outside this container
EXPOSE 80

#Define environment variable
ENV NAME World

# Run app.py then the container launches
CMD ["python", "app.py"]


#creating new container from 
#docker build -t my-python-app:1.0 .