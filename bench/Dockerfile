FROM python:3.6
RUN pip install locustio
COPY locustfile.py .
ENTRYPOINT [ "locust" ]