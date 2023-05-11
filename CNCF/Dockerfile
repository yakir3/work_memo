FROM busybox

# Set an environment variable
ENV APP /cncf

# Create the directory
RUN mkdir $APP
WORKDIR $APP

# We copy the rest of the codebase into the image
COPY . .

#ENTRYPOINT ["/bin/docker-entrypoint.sh"]
CMD ["echo", "cncf-record"]
