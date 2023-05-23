FROM busybox

# Set an environment variable
ENV APP /work_memo

# Create the directory
RUN mkdir $APP
WORKDIR $APP

# We copy the rest of the codebase into the image
COPY . .

#ENTRYPOINT ["/bin/docker-entrypoint.sh"]
CMD ["echo", "work_memo"]
