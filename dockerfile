# Base oficial de desarrollo compatible con GitHub Codespaces
FROM ://microsoft.com

# Evitar diálogos interactivos durante la instalación
ENV DEBIAN_FRONTEND=noninteractive

# 1. Actualizar sistema e instalar Apache 2.4 y herramientas requeridas
RUN apt-get update && apt-get install -y --no-install-recommends \
    apache2 \
    curl \
    gnupg \
    ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Agregar repositorio oficial de Oracle para MySQL 9.7 LTS
RUN curl -fsSL https://mysql.com | gpg --dearmor -o /usr/share/keyrings/mysql-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/mysql-archive-keyring.gpg] http://mysql.com jammy mysql-9.7" > /etc/apt/sources.list.md/mysql.list

# 3. Instalar Servidor MySQL 9.7
RUN apt-get update && apt-get install -y --no-install-recommends \
    mysql-server \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Configurar Apache para que no use nombres de dominio completamente calificados en local
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Exponer puertos por documentación interna (Codespaces los gestionará vía devcontainer.json)
EXPOSE 80 3306

# Script de inicio para asegurar que ambos servicios arranquen al iniciar el Codespace
CMD ["sh", "-c", "service mysql start && apache2ctl -D FOREGROUND"]
