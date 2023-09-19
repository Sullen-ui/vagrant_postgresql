#!/bin/bash
sudo dnf -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-9-x86_64/pgdg-redhat-repo-latest.noarch.rpm
sudo dnf update -y
sudo dnf -y module disable postgresql


sudo dnf -y install postgresql15-server
sudo /usr/pgsql-15/bin/postgresql-15-setup initdb

sudo systemctl enable postgresql-15
sudo systemctl start postgresql-15
sudo systemctl status postgresql-15

# Устанавливаем пароль для пользователя postgres
echo "Setting password for postgres user"
cd /
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'Verysecurepass1';"

# Создаем новую базу данных
echo "Creating a new PostgreSQL database"
sudo -u postgres createdb main_db

# Создаем нового пользователя и даем ему доступ к базе данных
echo "Creating a new PostgreSQL user and granting access to the database"
sudo -u postgres psql -c "CREATE USER db_user WITH PASSWORD 'db_user';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE main_db TO db_user;"

#!/bin/bash

# Имя базы данных
DB_NAME="main_db"

# Имя пользователя PostgreSQL
DB_USER="db_user"

# Подсеть или IP-адрес, с которого будет разрешен доступ
ALLOWED_NETWORK="192.168.33.0/24"

# Пароль для пользователя PostgreSQL
DB_PASSWORD="db_user"

# Обновляем PostgreSQL pg_hba.conf
echo "host    main_db    db_user    192.168.33.0/24    md5" | sudo tee -a /var/lib/pgsql/15/data/pg_hba.conf > /dev/null

# Перезапускаем PostgreSQL
sudo systemctl restart postgresql-15

# Настройка брандмауэра (Firewalld)
echo "Configuring firewall (Firewalld)"
sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="192.168.33.0/24" port port="5432" protocol="tcp" accept'
sudo systemctl reload firewalld

echo "PostgreSQL access has been configured. Database: $DB_NAME, User: $DB_USER, Allowed Network: $ALLOWED_NETWORK"

