#Use this image as base
FROM node:10-alpine

#Run command inside container
RUN mkdir -p /usr/src/app 
WORKDIR /usr/src/app

#Set environment variables
ENV NODE_ENV production

#Copy file into container
COPY package.json /usr/src/app
RUN npm install
COPY . /usr/src/app

#Listen to port 80
EXPOSE 80

#Do this when container-image is executed
CMD [ "npm", "start" ]
