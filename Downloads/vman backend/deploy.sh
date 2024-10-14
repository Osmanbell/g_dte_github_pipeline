#!/bin/bash

PORT=$1
PORT_REGEX='^[0-9]{2,6}$'
BASE_URL_REGEX='^REACT_APP_BASE_URL=http[s]*://(.+?)/$'
STAFF_PROFILE_URL_REGEX='REACT_APP_STAFF_PROFILE_UPDATE_URL=http[s]*://(.+?)'
ENV_PATH='frontend/.env'

if [ -n "$PORT" ] ; then
  if ! [[ "$PORT" =~ $PORT_REGEX ]] ; then
    echo -e "\nPlease provide a valid port to serve the application on."
    echo "Usage:"
    echo "--------------------------------"
    echo -e "$0 [<PORT_TO_SERVE_APP>]"
    echo "--------------------------------"
    exit 1
  fi
fi

echo "Pulling project from repository....."
git pull > /dev/null

if [ $? -ne 0 ] ; then
  echo "Error: Could not pull from the repository. Please check if there is a git repository."
  exit 1
fi
echo -e "Done pulling.\n"


# Check for frontend/.env file and environment variables
if ! [ -f $ENV_PATH ] ; then
  echo "frontend/.env file does not exist."
  exit 1
fi

if ! egrep "$BASE_URL_REGEX" $ENV_PATH > /dev/null ; then
  echo "Environment variable 'REACT_APP_BASE_URL' is not set in frontend/.env file."
  exit 1
fi

if ! egrep "$STAFF_PROFILE_URL_REGEX" $ENV_PATH > /dev/null ; then
  echo "Environment variable 'REACT_APP_STAFF_PROFILE_UPDATE_URL' is not set in frontend/.env file."
  exit 1
fi


# Application setup
echo "FRONTEND SETUP"
echo "==============="


echo "Installing frontend dependencies....."
cd frontend && npm install --force > /dev/null

if [ $? -ne 0 ] ; then
  echo "Error: Failed to install frontend dependencies."
  exit 1
fi
echo "Frontend dependencies installed."

echo "Building the frontend react code....."
npm run build > /dev/null

if [ $? -ne 0 ] ; then
  echo "Error: Failed to build the react frontend."
  exit 1
fi
echo "Done building frontend code."


echo "Moving the frontend build files to the backend resources and public directories....."
mv build/index.html ../api/resources/views/index.blade.php
cp -R build/* ../api/public/
rm -r build
cd ..

if [ $? -ne 0 ] ; then
  echo "Error: Copying failed."
  exit 1
fi
echo -e "Build files moved successfully.\n"

echo "BACKEND SETUP"
echo "==============="

echo "Installing backend dependencies....."
cd api && composer update > /dev/null

if [ $? -ne 0 ] ; then
  echo "Error: Failed to install backend dependencies."
  exit 1
fi

echo "Backend dependencies installed."
php artisan optimize:clear > /dev/null
echo "Backend cache cleared."

if [ -n "$PORT" ] ; then
  echo "Starting server....."
  php artisan serve --host 0.0.0.0 --port "$PORT"
fi
