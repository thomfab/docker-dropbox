dropbox
=======

Docker container to run dropbox

## Basic usage

Launch the container via docker:
```
docker run -d --name dropbox thomfab/docker-dropbox
```

Check the logs of the container to get URL to associate with your Dropbox account.
```
docker logs dropbox
```
Output :
```
This computer isn\'t linked to any Dropbox account...
Please visit https://www.dropbox.com/cli_link_nonce?nonce=471f78ui8626087uhg66t5yu42f93b63f to link this device.
```
Copy and paste the URL in a browser and login to your Dropbox account to associate.
Run another :
```
docker logs dropbox
```
and you should see :
```
This computer is now linked to Dropbox. Welcome xxxx
```

## Check Dropbox progress
Run the following to get the status of dropbox sync:
```
docker exec -t dropbox bash -c "HOME=/dropbox && /dropbox/dropbox.py status"
```

## Advanced

Some variables can be customized :

### VOLUME
Two volumes are exposed:
* the dropbox folder (/dropbox/Dropbox): you can map it to a local folder to easily access Dropbox data
* the dropbox configuration folder (/dropbox/.dropbox): you can map it to reuse configuration (and authorization token)

Example :
```
docker run -d --name dropbox \
              -v /path/to/dropbox/data:/dropbox/Dropbox \
              -v /path/to/dropbox/conf:/dropbox/.dropbox \
              thomfab/docker-dropbox
```

### USER
By default the user "dropbox" (with id 1000) is used. You can customize and pass a user (and its id) of the docker host (so that file perms are correct).
Example, if your docker host has a user "myuser" with id 1005 you can use :
```
docker run -d --name dropbox \
              -v /path/to/dropbox/data:/dropbox/Dropbox \
              -v /path/to/dropbox/conf:/dropbox/.dropbox \
              -e DROPBOX_USER=myuser -e DROPBOX_USERID=1005 \
              thomfab/docker-dropbox
```
Files created in the /dropbox/Dropbox volume will belong to the user ubuntu (and group users, see below).

### GROUP
By default the group "users" (with id 100) is used. You can also customize and pass a group (and its id) of the docker host.
Example, if your docker host has a group "mygroup" with id 1005 you can use :
```
docker run -d --name dropbox \
              -v /path/to/dropbox/data:/dropbox/Dropbox \
              -v /path/to/dropbox/conf:/dropbox/.dropbox \
              -e DROPBOX_USER=myuser -e DROPBOX_USERID=1005 \
              -e DROPBOX_GROUP=mygroup -e DROPBOX_GROUPID=1005 \
              thomfab/docker-dropbox
```
Files created in the /dropbox/Dropbox volume will belong to the group mygroup.
