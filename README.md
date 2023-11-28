# Data Science and Machine Learning 

## Overview  

Welcome to my GitHub repository, where I showcase my work in data engineering, data science, and machine learning. This repository serves as my ledger for my skills, knowledge, and passion for transforming data into actionable insights and innovative AI solutions.  Arm yourself with information!

## Projects  

Each project in this repository is contained in its own directory.  

## Scripts and Notebooks  

In the scripts and notebooks directories, you'll find various Python scripts and Jupyter notebooks that I've written to perform data analysis, machine learning model training, and other data science tasks.  

## How to Use  

To use the scripts and notebooks in this repository:  

1. **Clone the repository:**  
   `git clone https://github.com/sarahgetter/go_play.git`  

2. **Navigate** to the desired project or script directory.  

3. **Follow the individual READMEs** in each project or script directory for specific instructions on how to run and use them.  

## Technologies Used  

This repository includes work done with the following technologies:  

- Python  
- SQL  
- TensorFlow  
- PyTorch  
- Pandas  
- NumPy  
- Scikit-learn  
- Airflow  
- DBT  
- Terraform  
- Kubernetes

## About Me  

I am a data science and machine learning enthusiast with a passion for turning complex datasets into meaningful stories.

## Contributing  

While this is a personal portfolio, I am open to collaborations and contributions that can enhance the projects. Feel free to fork the repository and submit pull requests.

## Building and Running the Docker Image

Build the Docker Image

Navigate to the directory containing the Dockerfile.

## Run the following command to build the Docker image. You can replace data-science-env with your preferred image name:

`docker build -t data-science-env .`

## Run a Container

Once the image is built, you can start a container using the following command:

`docker run -p 8888:8888 data-science-env`

This command maps the container's port 8888 to port 8888 on your host machine, allowing you to access Jupyter Notebook through your browser.

## Access Jupyter Notebook

Open your web browser and navigate to: http://localhost:8888.

You might need a token to log in, which can be found in the terminal output where you started the Docker container.

## Additional Steps

Customization: You may want to customize the environment further by adding more packages or configuring Jupyter Notebook settings.

Data Persistence: Consider adding a volume to your Docker run command if you want to persist notebooks or data files outside the container. 

## Example:

`docker run -p 8888:8888 -v $(pwd):/usr/src/app data-science-env`

Docker Hub: You could also push the built image to a container registry like Docker Hub for easy access and sharing.

This setup provides a basic yet powerful data science environment, suitable for a variety of tasks in machine learning and data analysis.
