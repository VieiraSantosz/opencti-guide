# !/bin/bash
#
# opencti.sh - faz a instalação da ferramenta OpenCTI (Threat Intelligence)
#
# Autor..: Wesley Santos  <wesleyv760@gmail.com>
# Auxílio: Daniel Brandão <>
#
# -------------------------------------------------------------------------------------
#
# Este programa faz a instalação da ferramenta OpenCTI (Threat Intelligence), 
# retornando o seu link de acesso, usuário e senha. 
#


# Função para exibir a barra de progresso sincronizada com a execução real do comando
progress_bar() {
    local cmd="$1"      # Comando a ser executado passado como argumento
    local log_file="$2" # Nome do arquivo onde será armazenada a saída do comando

    rm -f "$log_file" # Remove o arquivo de log anterior, caso exista
    touch "$log_file" # Cria um novo arquivo vazio para armazenar a saída do comando

    # Executa o comando fornecido em segundo plano, redirecionando sua saída para o arquivo de log
    eval "$cmd" >"$log_file" 2>&1 &
    local cmd_pid=$!  # Captura o PID (identificador do processo) do comando em execução

    local total_lines=100     # Define um valor estimado de total de linhas processadas para calcular a barra de progresso
    local current_line=0      # Inicializa a variável que irá contar as linhas processadas no log
    local elapsed_time=0      # Tempo decorrido desde o início da execução do comando
    local max_time=180        # Tempo máximo (em segundos) antes de começar a exibir avisos (2 minutos)
    local warned=0            # Contador de quantos avisos já foram emitidos
    local warning_limit=3     # Limite máximo de avisos para o usuário
    local last_warning_time=0 # Registra o tempo do último aviso exibido

    # Loop que verifica continuamente se o processo ainda está rodando
    while kill -0 $cmd_pid 2>/dev/null; do

        # Conta o número de linhas geradas no arquivo de log até o momento
        current_line=$(wc -l < "$log_file")  
        
        # Calcula a porcentagem de progresso baseado no número de linhas geradas
        local progress=$((current_line * 100 / total_lines))

        # Garante que o progresso não ultrapasse 98% (para evitar uma finalização prematura)
        if [ $progress -gt 98 ]; then progress=98; fi  

        # Calcula quantos caracteres preencher na barra de progresso
        local filled=$((progress / 2)) # A cada 2% um ponto será preenchido
        local empty=$((50 - filled))   # Espaços vazios restantes para completar a barra

        # Exibe a barra de progresso no terminal
        printf "\r["                    # Retorna ao início da linha para sobreescrever a barra de progresso anterior
        printf "%0.s." $(seq 1 $filled) # Imprime os pontos correspondentes ao progresso
        printf "%0.s " $(seq 1 $empty)  # Imprime os espaços restantes
        printf "] %d%%" "$progress"     # Exibe a porcentagem de progresso
        sleep 0.5                       # Aguarda meio segundo antes da próxima atualização

        ((elapsed_time++)) # Incrementa o tempo decorrido

        # Verifica se o tempo máximo foi atingido e controla a exibição de avisos
        if ((elapsed_time >= max_time)); then

            if ((warned < warning_limit)); then
                local current_time=$(date +%s) # Obtém o tempo atual em segundos

                if ((current_time - last_warning_time >= 180)); then  # Se já passaram 90 segundos desde o último aviso
                    printf "\n\nO processo está demorando mais que o esperado. Aguarde...\n\n"

                    last_warning_time=$current_time # Atualiza o tempo do último aviso
                    ((warned++))                    # Incrementa o contador de avisos
                fi
            fi
        fi
    done

    # Quando o processo termina, exibe a barra de progresso completa
    printf "\r[..................................................] 100%% concluído\n"
}


# Função para verificar se o script está sendo executado como root
root () {
    if [ "$(id -u)" != 0 ]; then
        clear
        echo -e "\n🚫 Atenção!!!"
        echo -e "\nPara o funcionamento desse script, necessário executar com o usuário administrador (root).\n\n"
        exit 1
    fi    
}


# Função para obter o IP da máquina
get_ip () {
    IP_LOCAL=$(hostname -I | awk '{print $1}')
}


# Função para escrever o banner no início da instalação
banner () {
    clear
    echo "

      /######                                 /######  /######## /######
     /##__  ##                               /##__  ##|__  ##__/|_  ##_/
    | ##  \ ##  /######   /######  /####### | ##  \__/   | ##     | ##  
    | ##  | ## /##__  ## /##__  ##| ##__  ##| ##         | ##     | ##  
    | ##  | ##| ##  \ ##| ########| ##  \ ##| ##         | ##     | ##  
    | ##  | ##| ##  | ##| ##_____/| ##  | ##| ##    ##   | ##     | ##  
    |  ######/| #######/|  #######| ##  | ##|  ######/   | ##    /######
     \______/ | ##____/  \_______/|__/  |__/ \______/    |__/   |______/
              | ##                                              
              | ##                                       𝑀𝒶𝒹𝑒 𝐵𝓎: 𝒲 𝑒𝓈𝓁𝑒𝓎 𝒮𝒶𝓃𝓉𝑜𝓈       
              |__/"
}


# Função para verificar os requisitos mínimos do Sistema Operacional
check_system_minimum () {
    echo ""

    # Verifica a distribuição do sistema operacional 
    source /etc/os-release
    OS_NAME=$ID
    VERIFY_OS=false

    sleep 1.5
    if [ "$OS_NAME" == "ubuntu" ] || [ "$OS_NAME" == "debian" ]; then
        VERIFY_OS=true
        echo "✅ Sistema Operacional..........: $OS_NAME"
    else 
        echo "❌ Sistema Operacional..........: $OS_NAME"
    fi


    # Verifica a quantidade de núcleos do sistema operacional  
    CPU_MIN=4 
    CPU_COUNT=$(nproc)
    VERIFY_CPU=false

    sleep 1.5
    if [ "$CPU_COUNT" -ge "$CPU_MIN" ]; then
        VERIFY_CPU=true
        echo "✅ CPU..........................: $CPU_COUNT núcleos"        
    else 
        echo "❌ CPU..........................: $CPU_COUNT núcleos"
    fi


    # Verifica a quantidade de RAM do sistema operacional  
    RAM_MIN=8
    RAM_TOTAL=$(free -g | awk '/Mem:/ {print $2}')
    VERIFY_RAM=false

    sleep 1.5
    if [ "$RAM_TOTAL" -ge "$RAM_MIN" ]; then
        VERIFY_RAM=true
        echo "✅ RAM..........................: $RAM_TOTAL GB"
    else 
        echo "❌ RAM..........................: $RAM_TOTAL GB"
    fi


    # Verifica a quantidade de DISCO do sistema operacional  
    DISK_MIN=32
    DISK_AVAILABLE=$(df --output=avail -BG / | tail -1 | awk '{print substr($1, 1, length($1)-1)}')     
    VERIFY_DISK=false

    sleep 1.5
    if [ "$DISK_AVAILABLE" -ge "$DISK_MIN" ]; then
        VERIFY_DISK=true
        echo "✅ DISCO........................: $DISK_AVAILABLE GB"
    else 
        echo "❌ DISCO........................: $DISK_AVAILABLE GB"
    fi


    # Informa os requisitos mínimos necessários para instalação 
    sleep 1.5 
    if [ "$VERIFY_OS" = "false" ] || [ "$VERIFY_CPU" = "false" ] || [ "$VERIFY_RAM" = "false" ] || [ "$VERIFY_DISK" = "false" ]; then
        echo -e "\n\nSeu sistema operacional não possui os requisitos mínimos necessários para instalação."
        echo -e "\n\nOs requisitos mínimos são os seguintes:\n"
        echo "Distribuição do Sistema Operacional: Debian ou Ubuntu"
        echo "CPU................................: $CPU_MIN núcleos"
        echo "RAM................................: $RAM_MIN GB"
        echo "Disco Disponível...................: $DISK_MIN GB"
        echo -e "\n\n--------------------------------------------------------------------------------\n\n"
        exit 1

    else
        echo -e "\n\nSeu sistema operacional possui todos os requisitos mínimos necessários para instalação."
        echo -e "\nSua instalação irá começar em:\n"
        
        for i in $(seq 5 -1 1); do
            echo "$i"
            sleep 1
        done
        sleep 1
    fi
}


# Função para verificar se existem algum serviço do OpenCTI (Threat Intelligence)
opencti_services () {

    # Busca por serviços do OpenCTI (Threat Intelligence)
    SERVICES=$(sudo find / -type d -name "opencti*" 2>/dev/null)

    # Verifica se encontrou algum serviço do OpenCTI (Threat Intelligence)
    if [ -n "$SERVICES" ]; then
        echo -e "\n\n⚠️ Foram encontrados serviços do OpenCTI (Threat Intelligence) ativo na sua máquina."
        echo -e "\nDeseja seguir com a instalação?"
        echo -e "OBS: O instalador irá remover o OpenCTI existente e instalar um novo."
        echo -e "\n(1) Seguir com a instalação"
        echo "(2) Não realizar a instalação"

        # Captura a escolha do usuário
        echo ""
        read -p "Escolha uma opção (1 ou 2): " OPC

        if [ "$OPC" == "1" ]; then
            echo -e "\n\nRemovendo OpenCTI (Threat Intelligence) existente"
            opencti_remove

            echo -e "\n\nInstalando os pacotes do novo OpenCTI (Threat Intelligence)"
            opencti_packages

            echo -e "\n\nInicinado os serviços do novo OpenCTI (Threat Intelligence)\n"
            opencti_server
        
        elif [ "$OPC" == "2" ]; then
            echo -e "\n\nNão foi realizada a instalação do OpenCTI (Threat Intelligence)"
            echo -e "\n\n-----------------------------------------------------------------------\n\n"
            exit 1
        
        else
            echo -e "\n\n🚫 Por favor, selecione uma opção válida!!!"
            opencti_services
        fi

    else
        echo -e "\n\nInstalando os pacotes do OpenCTI (Threat Intelligence)"
        opencti_packages

        echo -e "\n\nInicinado os serviços do OpenCTI (Threat Intelligence)\n"
        opencti_server
    fi
}


# Função para remover/desisntalar o OpenCTI (Threat Intelligence)
opencti_remove () {
    path_cti=$(find / -type f -name "docker-compose.dev.yml" | grep "opencti" | xargs -I {} dirname {})

    cd $path_cti 2>/dev/null
    progress_bar "docker compose down" "/tmp/docker_down_log"
    sudo rm -rf $path_cti 2>/dev/null
}


# Função para criar o diretório da ferramenta
opencti_diretory () {
    cd /
    git clone https://github.com/OpenCTI-Platform/docker 2> /dev/null

    mv docker opencti
    cd opencti
}


# Função para instalar os pacotes do Docker
opencti_packages () {
    progress_bar "sudo apt-get install ca-certificates curl" "/tmp/apt_certificates_log"

    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
     
    progress_bar "sudo apt-get update && \
                  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y" "/tmp/apt_docker_log"
}


#Função para congifurar o OpenCTI (Threat Intelligence) e ativar os serviços 
opencti_server () {
    opencti_diretory

    ARQUIVO=".env"
    UUIDv4=$(cat /proc/sys/kernel/random/uuid)
    password=$(openssl rand -base64 16 | cut -c1-16)
    get_ip

    cp .env.sample .env

    sed -i "s|changeme|${password}|g" "$ARQUIVO" && \
    sed -i "s|ChangeMe_UUIDv4|${UUIDv4}|g" "$ARQUIVO" && \
    sed -i "s|localhost|${IP_LOCAL}|g" "$ARQUIVO" && \
    sleep 1
    
    docker compose up -d
}


# Função para mostrar os acessos do OpenCTI (Threat Intelligence)
opencti_acess () {
    get_ip

    user=$(grep "OPENCTI_ADMIN_EMAIL=" .env | cut -d '=' -f2)
    pass=$(grep "OPENCTI_ADMIN_PASSWORD=" .env | cut -d '=' -f2)

    echo -e "\n\nAcesso ao OpenCTI (Threat Intelligence):"
    echo -e "\nLink de acesso: http://${IP_LOCAL}:8080"
    echo -e "User..........: $user"
    echo -e "Senha.........: $password"
}


#################################################################################################################################


### Parte 1 - Validar se o Sistema Operacional atende os requisitos mínimos necessários

root
banner

echo -e "\n\n----- Verificando se seu Sistema Operacional atende os requisitos mínimos ------"
check_system_minimum
echo -e "\n\n--------------------------------------------------------------------------------"

############################################################


### Parte 2 - Instalar o Docker e o OpenCTI (Threat Intelligence)

banner

echo -e "\n\n------------ 1. Instalando o OpenCTI (Threat Intelligence) ------------"
sleep 2
opencti_services
echo -e "\n\n------- Instalação do OpenCTI (Threat Intelligence) finalizada --------"

############################################################


### Parte 3 - Acesso ao servidor OpenCTI
echo -e "\n\n\n\n\n-------------------------- Acesso ao OpenCTI --------------------------"
sleep 2

opencti_acess
echo -e "\n\nArquivos de instalação do OpenCTI estão localizados dentro do diretório raiz em: /opencti"

echo -e "\n\n-----------------------------------------------------------------------\n\n"

############################################################
