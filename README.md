# FT_Linux
42 Project - Build your own linux distribution


# Tutoriel : Comment créer sa distribution Linux !

### SYSTEM HOST

##### Packages requis: 
```
sudo apt-get install bash gzip binutils findutils gawk gcc libc6 grep gzip m4 make patch perl python sed tar texinfo xz-utils bison 
```
* Insérez un deuxième disque d'une taille minimum de 16Go sur la machine virtuelle.

##### Formatage des partitions:
  * Pour une utilisation simplifiée, utilisez: "gparted"
  * Sinon: "fdisk"

 	 * 1: ``` fdisk /dev/sdb ```
 	 * 2:
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
	* 3:
		```
		lsblk -o NAME,UUID,FSTYPE,MOUNTPOINT,SIZE /dev/sdb
		```
		![image](https://user-images.githubusercontent.com/66129673/159988917-09102775-f316-4450-ad3e-c4380cc78a4d.png)
	* 4:
		```
		sudo mkfs -v -t ext2 /dev/sdb2
		sudo mkfs -v -t ext4 /dev/sdb4
		sudo mkswap /dev/sdb3
		```
	* 5: 
		```
		lsblk -o NAME,UUID,FSTYPE,MOUNTPOINT,SIZE /dev/sdb
		```
		![image](https://user-images.githubusercontent.com/66129673/159989405-029b43c5-8936-43a5-9637-a5a00fb7bf5c.png)

