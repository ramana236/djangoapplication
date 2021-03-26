FROM ubuntu:18.04

# Install dependencies
RUN apt-get update && apt-get install -y python3-pip && pip3 install Django
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
RUN mkdir /code
WORKDIR /code
COPY app/cf-example-python-django/requirements.txt /code/
RUN pip3 install -r requirements.txt
COPY app/cf-example-python-django/ /code/
EXPOSE 8000
CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]
