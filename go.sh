# Установка рабочей директории для Blender
mkdir -p /usr/local/blender
cd /usr/local/blender

# Задание переменных среды для версии Blender
BLENDER_VERSION=3.6
BLENDER_MINOR=3.6.2
BLENDER_URL=https://mirrors.iu13.net/blender/release/Blender3.6/blender-$BLENDER_MINOR-linux-x64.tar.xz

# Загрузка и распаковка Blender
wget "$BLENDER_URL" -O blender.tar.xz
tar -xf blender.tar.xz --strip-components=1

# Возврат к основной директории
cd /

# Установка рабочей директории для Flamenco
mkdir -p /app
cd /app

# Задание переменных среды для версии Flamenco
FLAMENCO_VERSION=3.2
FLAMENCO_URL=https://flamenco.blender.org/downloads/flamenco-$FLAMENCO_VERSION-linux-amd64.tar.gz

# Загрузка и распаковка Flamenco
wget "$FLAMENCO_URL" -O flamenco.tar.gz
tar -xf flamenco.tar.gz --strip-components=1

# Возврат к основной директории
cd /

apt-get update -y
apt-get upgrade -y
apt-get install -y  unzip git libgl1-mesa-dev libglu1-mesa libsm6 libxi6 libxext6 libxrender-dev libxkbcommon-x11-0 libxrender1 build-essential git subversion cmake libx11-dev libxxf86vm-dev libxcursor-dev libxi-dev libxrandr-dev libxinerama-dev libegl-dev libwayland-dev wayland-protocols libxkbcommon-dev libdbus-1-dev linux-libc-dev
apt-get -y autoremove


echo -e "manager_url: http://77.105.139.79:15000/\ntask_types: [blender, file-management, misc]\nrestart_exit_code: 47" > flamenco-worker.yaml


# Задание переменных среды для путей
export PATH=/usr/local/blender:$PATH
export PATH=/usr/local/ffmpeg:$PATH


# Установка рабочей директории
cd /app

mkdir ./temp_clone
git clone https://github.com/bugaenkoleonid/flamenco-worker.git ./temp_clone
mv ./temp_clone/* ./temp_clone/.git* ./

# Установка прав на исполнение скриптов
chmod +x /app/bootstrap.sh
chmod +x /app/device.py


# Запуск скрипта bootstrap.sh
./bootstrap.sh

