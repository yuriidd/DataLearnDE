#creating new container from 
#docker build -t pg-contoso:1.0 .


FROM postgres:16.1

#   New passwork for root-uwer 'postgres'
ENV POSTGRES_PASSWORD=pass123

#   Copy init script and sql files
COPY ./bash-scripts /docker-entrypoint-initdb.d

#   Bind Mount source with CSV files - In Fact > copies all CSV to image, not good
#   Absolute path doesn't works
#   Solution - bind mount when running image first time with "-v /path:/path/on/image"
#RUN --mount=type=bind,source=/mnt/d/sql,target=/sql

#   Container will listen that port for incoming connections
EXPOSE 5432

#
CMD ["postgres"]