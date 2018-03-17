#!bin/bash
echo "Enter proxy address. Press Enter without typing anything if automatic."
read address
if [ "$address" != ""  ]; then
	echo "Enter proxy port."
	read port
	#echo "$address:$port"
else
	port=""
fi
echo "Enter username. Press Enter without typing anything if none."
read username
if [ "$username" != "" ]; then
	echo "Enter password"
	read -s password
	base="$username:$password@"
else
	base=""
fi
if [ "$address" != "" ]; then
  echo 1
	echo "Acquire::http::proxy \"http://$base$address:$port/\";" > /etc/apt/apt.conf
	echo "Acquire::https::proxy \"https://$base$address:$port/\";" >> /etc/apt/apt.conf
	echo "Acquire::ftp::proxy \"ftp://$base$address:$port/\";" >> /etc/apt/apt.conf
	npm config --global set proxy "http://$base$address:$port/"
  npm config --global set http-proxy "http://$base$address:$port/"
	npm config --global set https-proxy "http://$base$address:$port/"
  npm config --global set registry http://registry.npmjs.org/
  npm set --global strict-ssl false
  gsettings set org.gnome.system.proxy mode "manual"
  gsettings set org.gnome.system.proxy.http host $address
  gsettings set org.gnome.system.proxy.http port $port
  gsettings set org.gnome.system.proxy.https host $address
  gsettings set org.gnome.system.proxy.https port $port
  gsettings set org.gnome.system.proxy.ftp host $address
  gsettings set org.gnome.system.proxy.ftp port $port
  git config --global https.proxy http://$base$address:$port/
  git config --global http.proxy http://$base$address:$port/

else
  echo 2
	echo "Acquire::http::proxy \"false\";" > /etc/apt/apt.conf
	echo "Acquire::https::proxy \"false\";" >> /etc/apt/apt.conf
	echo "Acquire::ftp::proxy \"false\";" >> /etc/apt/apt.conf
	npm config delete proxy
	npm config delete https-proxy
  gsettings set org.gnome.system.proxy mode "none"
  git config --global --unset https.proxy
  git config --global --unset http.proxy
fi