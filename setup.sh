#!/bin/bash

exists()
{
  command -v "$1" >/dev/null 2>&1
}
if exists curl; then
	echo ''
else
  sudo apt update && sudo apt install curl -y < "/dev/null"
fi
bash_profile=$HOME/.bash_profile
if [ -f "$bash_profile" ]; then
    . $HOME/.bash_profile
fi

sudo apt update && sudo apt install ocl-icd-opencl-dev libopencl-clang-dev libgomp1 -y
cd $HOME
wget -O pulsar https://github.com/subspace/pulsar/releases/download/v0.6.0-alpha/pulsar-ubuntu-x86_64-skylake-v0.6.0-alpha
sudo chmod +x pulsar
sudo mv pulsar /usr/local/bin/
sudo rm -rf $HOME/.config/pulsar
/usr/local/bin/pulsar init

source ~/.bash_profile
sleep 1

echo "[Unit]
Description=Subspace Node
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=/usr/local/bin/pulsar farm --verbose
Restart=on-failure
LimitNOFILE=1024000

[Install]
WantedBy=multi-user.target" > $HOME/subspaced.service

sudo mv $HOME/subspaced.service /etc/systemd/system/
sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable subspaced
sudo systemctl restart subspaced

if [ "$language" = "uk" ]; then
  echo -e '\n\e[94mСтатус ноди\e[0m\n' && sleep 1
  if [[ `service subspaced status | grep active` =~ "running" ]]; then
    echo -e "Ваша Subspace нода \e[92mвстановлена та працює\e[0m!"
    echo -e "Перевірити статус Вашої ноди можна командою \e[92mservice subspaced status\e[0m"
    echo -e "Натисніть \e[92mQ\e[0m щоб вийти з статус меню"
  else
    echo -e "Ваша Subspace нода \e[91mбула встановлена неправильно\e[39m, виконайте перевстановлення."
  fi
else
  echo -e '\n\e[94mNode Status\e[0m\n' && sleep 1
  if [[ `service subspaced status | grep active` =~ "running" ]]; then
    echo -e "Your Subspace node \e[92msuccessfully installed and running\e[0m!"
    echo -e "Check your node status: \e[92mservice subspaced status\e[0m"
    echo -e "Press \e[92mQ\e[0m to exit menu"
  else
    echo -e "Your Subspace Node \e[91mwas not installed correctly\e[39m, please reinstall."
  fi
fi