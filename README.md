# Swift Vapor AWS

```swift
sudo apt update -y
sudo apt upgrade -y
sudo apt-get install htop -y
sudo apt-get install git clang libicu-dev libpython2.7 -y
sudo apt-get install postgresql supervisor nginx git-lfs -y
sudo apt update -y
sudo apt upgrade -y
echo "##### APT Install List #####"
dpkg -l | grep -E "git|git-lfs|clang|libicu-dev|libpython2.7|postgresql|supervisor|nginx|htop"

echo "##### Install Swift #####"
wget https://download.swift.org/swift-5.6.1-release/ubuntu1804/swift-5.6.1-RELEASE/swift-5.6.1-RELEASE-ubuntu18.04.tar.gz
tar xzf swift-5.6.1-RELEASE-ubuntu18.04.tar.gz
sudo mv swift-5.6.1-RELEASE-ubuntu18.04 /usr/share/swift
echo "export PATH=/usr/share/swift/usr/bin:$PATH" >> ~/.bashrc
echo 'export VISUAL="vim"' >> ~/.bashrc
echo 'export EDITOR="$VISUAL"' >> ~/.bashrc
source .bashrc
echo "##### Swift Version #####"
swift --version

echo "##### Install Vapor #####"
git clone https://github.com/vapor/toolbox.git
cd toolbox
make install
echo "##### Vapor Version #####"
vapor --version

vapor new {APPNAME}
cd {APPNAME}

// 메모리 이슈
// 스왑 비활성화
sudo swapoff /swapfile
// 스왑 메모리 조정
sudo fallocate -l 1GiB /swapfile
// 스왑 파일 메모리 및 디스크 용량 확인
ls -la /
df -h
// 권한 설정
sudo chmod 600 /swapfile
// swap file 생성
sudo mkswap /swapfile
// 스왑 메모리 활성화
sudo swapon /swapfile
// 확인
free -m

vapor build
//or
vapor run serve 

// 확인
ulimit -a
// 한번에 open 할 수 있는 파일 수 올려줘야한다.
ulimit -n 65536
```

```swift
// Nginx 설정 (포워딩)
/etc/nignx/sites-available/default

sudo vi

...
server_name _;
        try_files $uri @proxy;
        location @proxy {
                proxy_pass http://127.0.0.1:8080;
                proxy_pass_header Server;
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_pass_header Server;
                proxy_connect_timeout 3s;
                proxy_read_timeout 10s;
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                #try_files $uri $uri/ =404;
        }
}
..
// nginx 재시작
sudo systemctl restart nginx

```

## postgreSQL

ubuntu - password

```swift
// 사용자 변경
sudo su - postgres 

// DBMS 실행
postgres@~$ psql 

postgres=# \l // List of databases
postgres=# \du // List of Roles
postgres=# \d // List of Relations
postgres=# SELECT * FROM PG_USER; // User 조회
postgres=# \q // exit
postgres=# \c [db_name] // DB 위치 변경
// vapor
postgres=# CREATE USER {USERNAME} SUPERUSER; // SUPERUSER role User 생성
// USER Role 추가
postgres=# ALTER ROLE {USERNAME} CREATEDB REPLICATION CREATEROLE BYPASSRLS;

postgres=# CREATE DATABASE {DATABASE_NAME}; // vapordb

// Postgresql Relation 못찾을 때 & Model 추가해서 Migrate해야할 때
vapor run migrate

// Migrate 취소할 때
vapor run migrate --revert
// Migration의 revert 함수가 호출된다.
```

## URL Routing

- grouping 없이 사용하기

```swift
routes.METHOD("{PAHT}", use: Response)

ex)
routes.get("getMethod", use: getResponse)
-> Request URL: Domain/getMethod
```

- grouping하기

```swift
// grouped
let groupedPath = routes.grouped("grouped")
groupedPath.get("getGroupedPath", use: getResponse)
-> Request URL: Domain/grouped/getGroupedPath

groupedPath.post(use: postResponse)
-> Request URL: Domain/grouped

//group
routes.group("group") { group in
    group.get(use: getResponse)
    // -> Request URL: Domain/group

    group.delete("deleeteGroupPath", use: deleteResponse)
    // -> Request URL: Domain/group/deleeteGroupPath
}

```
