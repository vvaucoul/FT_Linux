# FT_Linux
42 Project - Build your own linux distribution


# Tutoriel : Comment créer sa distribution Linux !

### SYSTEM HOST

* Packages requis: 
```
sudo apt-get install bash gzip binutils findutils gawk gcc libc6 grep gzip m4 make patch perl python sed tar texinfo xz-utils bison 
```
* Insérez un deuxième disque d'une taille minimum de 16Go sur la machine virtuelle.

* Formatage des partitions:
  * Pour une utilisation simplifiée, utilisez: "gparted"
  * Sinon: "fdisk"

  * 1:
    ```
    fdisk /dev/sdb
    ```
  * 2:
   ```
    g
    n default default +1M
    t 1 4
   n default default +200M
   t 2 1
   n default default +4G
   t 3 swap
   n default default default
   w
   ```
