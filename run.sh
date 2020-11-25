reset
ROOT="~"
while true; do
  cd $ROOT || exit
  echo -n "
  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  ┃                  Aoi Bot Updater                 ┃
  ┠──────────────────────────────────────────────────┨
  ┃ 1 - Install requirements                         ┃
  ┃ 2 - Run Aoi with auto restart                    ┃
  ┃ 3 - Run Aoi with auto restart and update         ┃
  ┃ 4 - Run Aoi without auto restart                 ┃
  ┃ 5 - Update Aoi                                   ┃
  ┃ 6 - Set up credentials file                      ┃
  ┃ 7 - Quit                                         ┃
  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
  > "
  read -r CHOICE
  if [[ $CHOICE -eq '1' ]]; then
    # install git
    if command -v which git > /dev/null 2>&1; then
      echo "  git found at $(which git)"
    else
      echo "  git not found, attempting to install"
      if command -v apt > /dev/null 2>&1; then
        echo "  apt distribution found - attempting to install git"
        echo "  This may ask for your password"
        sudo apt install git
      elif command -v yum > /dev/null 2>&1; then
        echo "  yum distribution found - attempting to install git"
        echo "  This may ask for your password"
        sudo yum install git
      elif command -v dnf > /dev/null 2>&1; then
        echo "  dnf distribution found - attempting to install git"
        echo "  This may ask for your password"
        sudo dnf install git
      else
        echo "  No supported package manage found, install git via your package manager"
        echo "  Exiting Aoi Updater"
        exit
      fi
      if command -v which git > /dev/null 2>&1; then
        echo "  git found at $(which git)"
      else
        echo "  Installing git seemed to be unsuccessful, install git via your package manager"
        echo "  Exiting Aoi Updater"
        exit
      fi
    fi
    # check python version
    if command -v which python3 > /dev/null 2>&1; then
      echo "  python3 found at $(which python3)"
    else
      echo "  python3 not found, attempting to install"
      if command -v apt > /dev/null 2>&1; then
        echo "  apt distribution found - attempting to install python3"
        echo "  This may ask for your password"
        sudo apt install python3
      elif command -v yum > /dev/null 2>&1; then
        echo "  yum distribution found - attempting to install python3"
        echo "  This may ask for your password"
        sudo yum install python3
      elif command -v dnf > /dev/null 2>&1; then
        echo "  dnf distribution found - attempting to install python3"
        echo "  This may ask for your password"
        sudo dnf install python3
      else
        echo "  No supported package manage found, install python via your package manager"
        echo "  Exiting Aoi Updater"
        exit
      fi
      if command -v which python3 > /dev/null 2>&1; then
        echo "  python3 found at $(which python3)"
      else
        echo "  Installing python3 seemed to be unsuccessful, install python via your package manager"
        echo "  Exiting Aoi Updater"
        exit
      fi
    fi
    if command -v which apt > /dev/null 2>&1; then
      sudo apt install python3-venv
    fi
    cd $ROOT || exit
    git clone https://github.com/aoi-bot/Aoi.git
    cd Aoi || exit
    git checkout develop
    python3 -m pip install --user virtualenv
    echo "  Creating virtualenv"
    python3 -m venv venv > /dev/null 2>&1;
    source venv/bin/activate
    echo "  Installing requirements.txt"
    python3 -m pip install -Ur requirements.txt
    FOLDER=`mcookie`
    pushd /tmp/$FOLDER
    git clone https://github.com/aoi-bot/discord.py
    cd discord.py
    python3 setup.py install
    popd
    if command -v which notify-send /dev/null 2>&1; then
        notify-send "Aoi prerequisites installed" /dev/null 2>&1
    fi
    cd $ROOT || exit
  elif [[ $CHOICE -eq '2' ]]; then
    cd $ROOT/Aoi || exit
    mkdir assets -p
    mkdir assets/frames -p
    source venv/bin/activate
    while :; do
      python3 main.py
      if [[ $? != 0 ]]; then
        break
      fi
    done
  elif [[ $CHOICE -eq '3' ]]; then
    cd $ROOT/Aoi || exit
    mkdir assets -p
    mkdir assets/frames -p
    git pull
    source venv/bin/activate
    while :; do
      python3 main.py
      if [[ $? != 0 ]]; then
        break
      fi
    done
  elif [[ $CHOICE -eq '4' ]]; then
    cd $ROOT/Aoi || exit
    mkdir assets -p
    mkdir assets/frames -p
    source venv/bin/activate
    python3 main.py
    if [[ $? != 0 ]]; then
      continue
    fi
  elif [[ $CHOICE -eq '5' ]]; then
    cd $ROOT/Aoi || exit
    git pull
  elif [[ $CHOICE -eq '6' ]]; then
    cd $ROOT/Aoi || exit
    echo "Input discord token"
    read -r TOKEN
    echo "Input gelbooru user"
    read -r GELB_USER
    echo "Input gelbooru api key"
    read -r GELB_API
    WEATHER="`cat /etc/hostname` - aoibot"
    echo "Weather.gov key set to $WEATHER"
    echo "Input google api key"
    read -r GOOGLE
    echo "Input nasa api key"
    read -r NASA_API
    echo "Input accuweather api key"
    read -r ACCU
    echo "Input imgur user"
    read -r IMGUR
    echo "Input imgur secret"
    read -r IMGUR_SECRET
    echo "Input banned tags (EX: tag1,tag2)"
    read -r BANNED
    BANNED=$BANNED,loli,lolicon,shota,shotacon,cub,minor
    echo "Banned tags set to $BANNED"
    echo "Input KSoft key"
    read -r KSOFT
    cat << EOF > .env
TOKEN=$TOKEN
GELBOORU_USER=$GELB_USER
GELBOORU_API_KEY=$GELB_API
WEATHER_GOV_API=$WEATHER
GOOGLE_API_KEY=$GOOGLE
NASA=$NASA_API
ACCUWEATHER=$ACCU
IMGUR=$IMGUR
IMGUR_SECRET=$IMGUR_SECRET
BANNED_TAGS=$BANNED
KSOFT=$KSOFT
EOF
    cat .env
  elif [[ $CHOICE -eq '7' ]]; then
    echo
    echo "  Exiting Aoi Updater"
    exit
  fi
done