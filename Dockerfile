# Use a lightweight Python base image
FROM python:3.9-slim

# Prevent Python from writing .pyc files
ENV PYTHONDONTWRITEBYTECODE=1
# Force Python stdout and stderr to be unbuffered
ENV PYTHONUNBUFFERED=1
# Flag
ENV FLAG=Kaal{Ins3cur3_R3duc1ng}

# Create a non-root user and group called 'ctf'
RUN groupadd -r ctf && useradd -r -g ctf ctf

# Set the working directory
WORKDIR /app

# Install Flask AND Gunicorn
RUN pip install --no-cache-dir flask gunicorn

# Copy the challenge files
COPY app.py flag.txt ./

# Set strict permissions
# root owns the files, the ctf group can read them, and nobody can modify them.
RUN chown -R root:ctf /app && \
    chmod -R 750 /app && \
    chmod 440 /app/flag.txt /app/app.py

# Switch to the non-root user
USER ctf
# Expose the port
EXPOSE 5000

# Run the application using Gunicorn
# -w 4: 4 worker processes (adjust based on your server specs)
# -b 0.0.0.0:5000: Bind to all interfaces on port 5000
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "app:app"]


