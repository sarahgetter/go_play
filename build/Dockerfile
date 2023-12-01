# ================================================================================================
# === Stage 1: Setup the Data Science Environment with JupyterHub ===============================
# ================================================================================================
FROM python:3.8-slim as python-build

# Set a working directory
WORKDIR /usr/src/app

# Install necessary libraries
RUN pip install --no-cache-dir numpy pandas matplotlib scikit-learn tensorflow keras jupyter jupyterhub

# ================================================================================================
# === Stage 2: Additional Setup (if needed) ======================================================
# ================================================================================================
# Use a base image like alpine if you need to run additional light-weight services or configurations
# FROM alpine:latest as final-setup
# WORKDIR /app

# COPY --from=python-build /usr/src/app /app

# ================================================================================================
# === Final Stage: Bundle everything in the runtime image =========================================
# ================================================================================================
FROM python:3.8-slim
WORKDIR /usr/src/app

# Copy everything from the first stage
COPY --from=python-build /usr/src/app .

# Expose the port Jupyter Notebook will run on
EXPOSE 8888

# Run Jupyter Notebook
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--allow-root", "--port=8888", "--no-browser"]
