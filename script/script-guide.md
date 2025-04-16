<h1 align="center">

[![Sem título](https://github.com/user-attachments/assets/f74dc857-6ceb-412a-9286-3d957354ac13)](https://filigran.io/solutions/open-cti/)

Script para Instalação do OpenCTI

</h1>

<h4 align="center">

Instruções para executar o script install_opencti.sh e o primeiro acesso à plataforma. 

</h4>

## Pré-Requisitos

Antes de executar o script, verifique se o seu servidor atende aos seguintes requisitos:

- **Sistema operacional:** Ubuntu e Debian
- **Mínimo de disco:** 32 GB
- **Mínimo de memória RAM:** 8 GB
- **Mínimo de CPU:** 4 CPU


## Execução do Script
**1. Atualizar o servidor**

Antes de executar o script, certifique-se de que o servidor está atualizado. Isso garante que os pacotes necessários sejam instalados corretamente.
```bash
sudo apt update && sudo apt upgrade -y
```

**2. Clone o repositório**

Clone o repositório onde o script de instalação está armazenado.
```bash
git clone https://github.com/VieiraSantosz/opencti-guide.git
```

**3. Navegar até o diretório do script**

Acesse a pasta onde o script foi clonado.
```bash
cd opencti-guide/script
```

**4. Conceder permissões para o script**

Antes de executar o script, é necessário garantir que ele tenha permissões de execução.
```bash
chmod +x install_opencti.sh
```

**5. Executar o script de instalação**

Agora, execute o script para iniciar a instalação do Grafana.
```bash
./install_opencti.sh
```

![image](https://github.com/user-attachments/assets/591a0515-d089-4160-9973-c1244d96d68f)


Após a instalação, o script fornecerá o link de acesso à interface web. Guarde essa informação, pois você precisará dela para acessar a plataforma do OpenCTI.

![image](https://github.com/user-attachments/assets/21a42705-db4f-40b7-b0cd-a09d8e2610ec)




## Primeiro acesso à plataforma
**1. Acessar a interface web**

Depois que os serviços estiverem ativos, abra o navegador e acesse a interface web do OpenCTI utilizando o IP da sua máquina seguido da porta 8080.
```bash
http://<IP-do-Servidor:8080>
```

**2. Login inicial**

 Utilize as credenciais fornecidas pelo script para realizar o primeiro login na interface do OpenCTI.
 
![image](https://github.com/user-attachments/assets/2586658f-4d7b-4510-a327-93f518cefa62)


**3. Após o Login**

Depois de acessar o sistema, você poderá começar a explorar os recursos e customizar a plataforma conforme suas necessidades.

![image](https://github.com/user-attachments/assets/f3a49698-13aa-424b-ad18-68681b18a35c)


## Solução de Problemas
Caso a instalação não tenha ocorrido conforme esperado, verifique o seguinte:

- **Falha na conexão com a internet:** Verifique se a sua conexão está funcionando corretamente e que o servidor pode acessar os repositórios do Grafana.
- **Acesso à interface web:** Se você não consegue acessar a interface web, verifique se a porta 8080 está aberta no firewall do servidor.
- **Problemas com Docker:** Confirme se o Docker está em execução com **docker ps**.
- **Containers não iniciam:** Containers não iniciam: Use o comando abaixo para ver os logs e identificar possíveis erros com **docker compose logs**.
