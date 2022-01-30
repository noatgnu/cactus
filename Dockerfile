FROM python:3.10-bullseye

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
WORKDIR /app


RUN apt-get -y update
RUN apt-get -y upgrade


RUN apt-get -y install git
RUN apt-get -y install nginx

RUN git clone https://github.com/noatgnu/cactus.git temp

RUN cp -R /app/temp /app/cactus

WORKDIR /app/cactus

RUN mkdir /app/nginx
RUN touch /app/nginx/error.log
RUN touch /app/nginx/access.log
RUN cp nginx.docker.conf /etc/nginx/nginx.conf


RUN pip3 install -r requirements.txt

RUN alembic downgrade base
RUN alembic upgrade head

RUN apt-get -y install supervisor
RUN service supervisor stop

EXPOSE 8000
EXPOSE 8001
EXPOSE 80
#RUN supervisord -n -c /app/cactus/super.docker.conf
RUN cp /app/cactus/super.docker.conf /etc/supervisor/supervisord.conf
RUN service supervisor restart
RUN service nginx restart
#CMD ["service", "nginx", "restart"]
CMD ["bash"]


