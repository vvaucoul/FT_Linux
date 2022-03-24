# FT_Linux
42 Project - Build your own linux distribution

# Tutoriel : Comment créer sa distribution Linux !
### SYSTEM HOST
* Packages requis: 
```
sudo apt-get install bash gzip binutils findutils gawk gcc libc6 grep gzip m4 make patch perl python sed tar texinfo xz-utils bison 
```
* Insérez un deuxième disque d'une taille minimum de 16Go sur la machine virtuelle.
* 
### Formatage des partitions:
* Pour une utilisation simplifiée, utilisez: "gparted"
* Sinon: "fdisk"
	* ``` fdisk /dev/sdb ```
	*
		```
		g
		n default default +1M
		t 4
		n default default +200M
		t 2 1
		n default default +4G
		t 3 19
		n default default default
		w
		```
	*
		```
		lsblk -o NAME,UUID,FSTYPE,MOUNTPOINT,SIZE /dev/sdb
		```
		![image](https://user-images.githubusercontent.com/66129673/159988917-09102775-f316-4450-ad3e-c4380cc78a4d.png)
	
	*
		```
		sudo mkfs -v -t ext2 /dev/sdb2
		sudo mkfs -v -t ext4 /dev/sdb4
		sudo mkswap /dev/sdb3
		```
	*
		```
		lsblk -o NAME,UUID,FSTYPE,MOUNTPOINT,SIZE /dev/sdb
		```
		![image](https://user-images.githubusercontent.com/66129673/159989405-029b43c5-8936-43a5-9637-a5a00fb7bf5c.png)

### Variable LFS:

*
	```
	echo "export LFS=/mnt/lfs" >> /etc/bash.bashrc
	source /etc/environment
	export LFS=/mnt/lfs
	env | grep LFS
	```

### Montage des partitions:

*
	```
	mkdir -pv $LFS
	mkdir -pv $LFS/boot
	mount -v -t ext4 /dev/sdb4 $LFS
	mount -v -t ext2 /dev/sdb2 $LFS/boot
	/sbin/swapon -v /dev/sdb3
	```

*
	```
	lsblk -o NAME,UUID,FSTYPE,MOUNTPOINT,SIZE /dev/sdb
	```
	
	![image](https://user-images.githubusercontent.com/66129673/159990170-12cf05fd-6b14-4560-b0f8-12e44817e8cb.png)

*
	```
	mount -v --bind /dev $LFS/dev
	mount -v --bind /dev/pts $LFS/dev/pts
	mount -vt proc proc $LFS/proc
	mount -vt sysfs sysfs $LFS/sys
	mount -vt tmpfs tmpfs $LFS/run
	if [ -h $LFS/dev/shm ]; then
 		mkdir -pv $LFS/$(readlink $LFS/dev/shm)
	fi
	```

### Kernel Compilation:

*
	```
	sudo apt-get install libncurses-dev flex bison openssl libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev autoconf
	cd $HOME
	wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.4.187.tar.xz
	tar xvf linux-5.4.187.tar.xz
	cd linux-5.4.187
	make defconfig
	make menuconfig
	```
* Placez votre login dans la version locale du kernel.
> General setup ---> local version ---> "mettez votre login ici avec un -"
```
make -j04
```

"04" correspond au nombre de coeurs utilisés lors de la compilation. Libre à vous de changer ce nombre.
La compilation dure en moyenne 10 minutes
