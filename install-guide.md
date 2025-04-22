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

Clone o repositório oficial com os arquivos Docker do OpenCTI, renomeie a pasta e entre no diretório para seguir com a configuração.
```bash
git clone https://github.com/OpenCTI-Platform/docker
mv docker opencti
cd opencti
```

**2. Configurar o arquivo .env**

Crie o arquivo .env com base no exemplo fornecido e edite-o com os dados necessários para o funcionamento da plataforma.
```bash
cp .env.sample .env
nano .env
```

![image](https://github.com/user-attachments/assets/9b38afe3-2eb7-48e3-9261-26e12c66321a)


Serão configuradas as seguintes variáveis para o funcionamento do OpenCTI:

| Variável                          | Descrição                                  | Exemplo                                  |
|----------------------------------|--------------------------------------------|------------------------------------------|
| `OPENCTI_ADMIN_EMAIL`            | E-mail do usuário administrador padrão     | `admin@opencti.io`                        |
| `OPENCTI_ADMIN_PASSWORD`         | Senha do usuário admin                     | `UmaSenhaForte123!`                       |
| `OPENCTI_ADMIN_TOKEN`            | Token de autenticação da API               | `e3d55ae2-4c3f-4e1f-b8e9-8f1dc7f91c23`     |
| `OPENCTI_BASE_URL`               | URL de acesso à plataforma OpenCTI         | `http://<IP-DO-SERVIDOR>:8080`            |
| `OPENCTI_HEALTHCHECK_ACCESS_KEY`| Chave usada para healthchecks da aplicação | `healthcheckkey123`                      |
| `MINIO_ROOT_PASSWORD`            | Senha de root do serviço MinIO (arquivos)  | `SenhaMinIO@123`                          |
| `RABBITMQ_DEFAULT_PASS`          | Senha padrão do serviço RabbitMQ           | `SenhaRabbit@123`                         |


Após fazer os ajustes necessários, o arquivo .env ficará assim:

![image](https://github.com/user-attachments/assets/f22407a8-fc87-4fad-af4a-9f8812e97a91)


**3. Iniciar os serviços do OpenCTI**

Com o ambiente configurado, execute o comando abaixo para subir todos os containers do OpenCTI via Docker Compose.
```bash
docker compose up -d
```

![image](https://github.com/user-attachments/assets/dc8b7e18-ccc9-48c0-b494-249c0c8b1099)

**Nota:** O processo pode levar alguns minutos na primeira execução, pois o Docker precisará baixar as imagens e realizar a configuração inicial. Aguarde até que todos os serviços estejam ativos.



## Primeiro acesso à plataforma

**1. Login de acesso**

Para consultar suas credenciais iniciais **(e-mail e senha do admin)**, abra o arquivo .env com o seguinte comando:
```bash
cat .env
```

Seu login e senha de acesso serão as duas primeiras informações do arquivo .env.

![image](https://github.com/user-attachments/assets/65bf2539-ca23-4e38-bb58-aedd142661b4)



**2. Acessar a interface web**

Abra o navegador e acesse a interface web do OpenCTI utilizando o IP da sua máquina seguido da porta 8080.
```bash
http://<IP-do-Servidor:8080>
```


**3. Login inicial**

 Utilize as credenciais que você definiu no .env para realizar o primeiro login na interface do OpenCTI.
 
![image](https://github.com/user-attachments/assets/2586658f-4d7b-4510-a327-93f518cefa62)


**4. Após o Login**

Depois de acessar o sistema, você poderá começar a explorar os recursos e customizar a plataforma conforme suas necessidades.

![image](https://github.com/user-attachments/assets/f3a49698-13aa-424b-ad18-68681b18a35c)


## Solução de Problemas
Caso a instalação não tenha ocorrido conforme esperado, verifique o seguinte:

- **Falha na conexão com a internet:** Verifique se a sua conexão está funcionando corretamente e que o servidor pode acessar os repositórios do OpenCTI.
- **Acesso à interface web:** Se você não consegue acessar a interface web, verifique se a porta 8080 está aberta no firewall do servidor.
- **Problemas com Docker:** Confirme se o Docker está em execução com **docker ps**.
- **Containers não iniciam:** Containers não iniciam: Use o comando abaixo para ver os logs e identificar possíveis erros com **docker compose logs**.












