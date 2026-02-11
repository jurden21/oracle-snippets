> More information: https://github.com/jurden21/oracle-snippets

# Create a Docker container for Oracle Database

## Oracle Dockerfiles repository:

https://github.com/oracle/docker-images/tree/main/OracleDatabase/SingleInstance/dockerfiles

```
Usage: 
   buildContainerImage.sh -v [version] -t [image_name:tag] [-e | -s | -x | -f] [-i] [-p] [-b] [-o] [container build option]
Parameters:
   -v: version to build
   -t: image_name:tag for the generated docker image
   -e: creates image based on 'Enterprise Edition'
   -s: creates image based on 'Standard Edition 2'
   -x: creates image based on 'Express Edition'
   -f: creates images based on Database 'Free' 
   -i: ignores the MD5 checksums
   -p: creates and extends image using the patching extension
   -b: build base stage only (Used by extensions)
   -o: passes on container build option
* select one edition only: -e, -s, -x, or -f
```

## Create Instance

Build a container image for Oracle Database XE 21.3.0:

> **Note**: For non-XE versions, you may need to download the Oracle Database binaries (ZIP file) and place them in the corresponding version folder before running the build script.

```bash
./buildContainerImage.sh -v 21.3.0 -x
```

Create a Docker container:
- replace [container_name] with container name
- replace [password] with strong password
- replace [path] with a host path to database files
```bash
docker run --name [container_name] -p 1521:1521 -p 5500:5500 -e ORACLE_PWD=[password] -v [path]:/opt/oracle/oradata oracle/database:21.3.0-xe
```
Example:
```
docker run --name oracle21xe -p 1521:1521 -p 5500:5500 -e ORACLE_PWD=pass -v C:\Oracle\oracle21xe:/opt/oracle/oradata oracle/database:21.3.0-xe
```

## Check Instance

Start bash in container:
```bash
docker exec -it oracle21xe /bin/bash
```

Verify installed Oracle client:
```bash
sqlplus -V
```

## Set up a client

### JDBC 

Use JDBC connection string for Oracle XE:
```
jdbc:oracle:thin:@//localhost:1521/xepdb1
```

### Oracle client

Verify the contents of the sqlnet.ora file:
```
NAMES.DIRECTORY_PATH= (TNSNAMES)
```

Configure tnsnames.ora:
```
ORACLE21XE =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = localhost)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = xepdb1)
    )
  )
```

## Create User

Connect to the Pluggable Database (PDB) as SYSDBA:
```bash
sqlplus sys/[password]@localhost:1521/xepdb1 as sysdba
```

Create a new user `dev` for development:
```sql
create user dev identified by dev default tablespace users temporary tablespace temp quota unlimited on users;
grant resource to dev;
grant connect to dev;
grant debug connect session to dev;
```

## Additional Docker commands

Check Docker version:
```bash
docker --version
```
Run a hello-world container as a test:
```bash
docker run hello-world
```
Show a list of Docker images:
```bash
docker images
```
Show a list of Docker running containers:
```bash
docker ps
```
Get help for Docker command:
```bash
docker [command] --help
```
