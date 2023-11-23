FROM python:3.8-slim

# Set a working directory
WORKDIR /usr/src/app

# Install necessary libraries
RUN pip install --no-cache-dir numpy pandas matplotlib scikit-learn tensorflow keras jupyter

# Expose the port Jupyter Notebook will run on
EXPOSE 8888

# Run Jupyter Notebook
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--allow-root", "--port=8888", "--no-browser"]
