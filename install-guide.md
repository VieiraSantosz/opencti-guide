<h1 align="center">

[![Sem título](https://github.com/user-attachments/assets/f74dc857-6ceb-412a-9286-3d957354ac13)](https://filigran.io/solutions/open-cti/)

Guia de Instalação do OpenCTI

</h1>

<h4 align="center">

Instruções para a instalação do OpenCTI e o primeiro acesso à plataforma.

</h4>

## Pré-Requisitos

Antes de iniciar a instalação, verifique se o seu servidor atende aos seguintes requisitos:

- **Sistema operacional:** Ubuntu e Debian
- **Mínimo de disco:** 32 GB
- **Mínimo de memória RAM:** 8 GB
- **Mínimo de CPU:** 4 CPU


## Instalação do Docker

**1. Atualizar o servidor**

Antes de iniciar a instalação, certifique-se de que o servidor está atualizado. Isso garante que os pacotes necessários sejam instalados corretamente.
```bash
sudo apt update && sudo apt upgrade -y
```

**2. Adicionar a chave GPG oficial do Docker**

Essa chave é usada para verificar a autenticidade dos pacotes baixados do repositório oficial do Docker.
```bash
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
```

**3. Adicionar o repositório do Docker**

Adiciona o repositório oficial do Docker à lista de fontes do apt para que os pacotes possam ser instalados corretamente.
```bash
echo \
   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
   $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

**4. Instalar o Docker e seus plugins**

Com o repositório adicionado, você pode instalar o Docker Engine e os plugins necessários para utilizar o Docker Compose.
```bash
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
```
**Nota**: Verifique se o serviço do Docker está ativo com **sudo systemctl status docker**.


## Instalação do OpenCTI

**1. Baixar e configurar o projeto OpenCTI**

```bash
git clone https://github.com/OpenCTI-Platform/docker
mv docker opencti
cd opencti
```

**2. Configurar o arquivo .env**

```bash
cp .env.sample .env
nano .env
```

![image](https://github.com/user-attachments/assets/9b38afe3-2eb7-48e3-9261-26e12c66321a)


Serão configuradas as seguintes variáveis para o funcionamento do OpenCTI:

- OPENCTI_ADMIN_PASSWORD = changeme
- OPENCTI_ADMIN_TOKEN = ChangeMe_UUIDv4
- OPENCTI_BASE_URL = http://localhost:8080
- OPENCTI_HEALTHCHECK_ACCESS_KEY = changeme
- MINIO_ROOT_PASSWORD = changeme
- RABBITMQ_DEFAULT_PASS = changeme

Ajuste que precisam ser feitos:

- changeme: trocar por uma senha segura.
- ChangeMe_UUIDv4: trocar por um UUID.
- Localhost: trocar o localhost pelo IP do seu servidor

Após fazer os ajustes necessários, o arquivo .env ficará assim:

![image](https://github.com/user-attachments/assets/0b942c85-8bab-4528-ac33-12203ea63ba3)


**3. Iniciar os serviços do OpenCTI**



## Primeiro acesso à plataforma

**1. Login de acesso**

Para saber seu login de acesso, realize o seguinte comandos dentro do diretório do opencti:
```bash
cat .env
```

Seu login e senha de acesso será as duas primeiras informações do arquivo .env



**2. Acessar a interface web**
Após a instalação, abra o seu navegador e insira a seguinte URL para acessar a plataforma do OpenCTI:
```bash
http://<IP-do-Servidor:8080>
```
**Nota:** Caso você esteja acessando a plataforma remotamente, substitua o **localhost** pelo endereço IP ou nome de domínio do servidor onde o OpenCTI foi instalado.


**3. Login de inicial**

Utilize as credenciais fornecidas dentro do diretório do opencti para realizar o login na plataforma.

![image](https://github.com/user-attachments/assets/2586658f-4d7b-4510-a327-93f518cefa62)


**4. Após o Login**

Depois de realizar o login, você estará pronto para começar a explorar e configurar a plataforma OpenCTI.

![image](https://github.com/user-attachments/assets/f3a49698-13aa-424b-ad18-68681b18a35c)















