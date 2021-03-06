# LAMMOC WRFv4

Automação de instalação do modelo WRFv4

## :warning: Pré-requisitos

- [Docker](https://docs.docker.com/get-docker/)
- Linux ou Windows 10 (com WSL)

Apenas sistemas 64 bits são suportados por conta do Docker.

Acesse [aqui](https://docs.docker.com/config/daemon/systemd/#runtime-directory-and-storage-driver) para configurar o storage driver que será ocupado pelas imagens, containers e volumes em uma outra partição.
É ideal que o docker esteja no mesmo nível que o wrf-docker após o download para operacionalização do modelo.

## :hot_face: TL;DR

É possível instalar com arquivos hospedados no Google Drive:

```bash
make gdrive && make gdrive-auth && make pre-build-gdrive
docker build . -t wrflammoc:0.1.0
```

Ou instalar obtendo os arquivos da fonte:

```bash
make pre-build-fonte
docker build . -t wrflammoc:0.1.0
```

## :bulb: O que está implementado

:white_check_mark: WRF-v4 (operacional)  
:white_check_mark: WPS  
:white_check_mark: ARWpost  
:white_check_mark: download das dependências via Google Drive  
:white_check_mark: download (alternativo) das dependência a partir da fonte  
:white_check_mark: download dos dados geográficos  
:white_check_mark: estruturação do volume com os dados de entrada (GFS) e mudanças nos namelists  
:white_check_mark: estruturação do volume com as saídas do modelo para pós-processamento gráfico  

## :wrench: Preparação

Esta seção cuidará das instruções de download dos arquivos necessários para a instalação do modelo, da preparação da estrutura de diretórios e outras eventuais necessidades prévias à instalação.

Essencialmente todas as ações do manual estarão abstraídas em makefiles e scripts bash. Se quiser, pode olhar as coisas lá no `Makefile` e no diretório `scripts` para garantir que não vou usar seu computador para minerar criptomoedas.

### Iniciando

Crie os diretórios do projeto:

```bash
make organizar-diretorios
```

### Dependências do projeto

As seguintes dependências serão utilizadas na instalação do modelo:

- [zlib 1.2.7](https://github.com/madler/zlib/releases/tag/v1.2.7)
- [NetCDF-c 4.1.3](https://github.com/Unidata/netcdf-c/releases/tag/netcdf-4.1.3)
- [Jasper 1.900.1](https://github.com/jasper-software/jasper/releases/tag/version-1.900.1)
- [Libpng 1.2.59](https://github.com/glennrp/libpng/releases/tag/v1.2.59)
- [MPICH 3.0.4](https://www.mpich.org/static/downloads/3.0.4/mpich-3.0.4.tar.gz)

O modelo e ferramentas associadas podem ser encontrados no diretório `wrf`, pois o link de download oficial não é aberto.

- [WRF v4](https://github.com/wrf-model/WRF/releases/tag/v4.0)

### Downloads (via Google Drive)

Todo o necessário deve estar hospedado no seu Google Drive ou em uma pasta compartilhada com você. Veja a próxima seção se você não quiser baixar os arquivos através do Google Drive.

A automação com Google Drive utiliza o [Gdrive](https://github.com/prasmussen/gdrive). O Gdrive é uma ferramenta para facilitar o download (via linha de comando) de arquivos hospedados no Google Drive.

```bash
make gdrive
```

Para autorizar a ferramenta a utilizar sua conta Google, execute:

```bash
make gdrive-auth
```

Um link será gerado na tela. Clique (segurando ctrl). Autorize. Copie e cole o código solicitado no terminal. Após autenticar, execute:

```bash
make gdrive-download
```

### Downloads (sem Google Drive)

O download das dependências também pode ser feito através dos repositórios originais correspondentes. Para baixar todas, execute:

```bash
make source-download
```

### Pre-build

A função abaixo irá realizar as etapas de preparação prévias à montagem da imagem Docker: distribuir os arquivos baixados nos diretórios esperados, descompactar e limpar os resíduos.

```bash
make pre-build
```

O script irá procurar os seguintes arquivos localmente (caso não-sensitivo).

- wrf\*
- wps\*
- arw\*
- zlib\*
- netcdf\*
- jasper\*
- libpng\*
- mpich\*

O download dos dados geográficos necessários para rodar o modelo é executado nesta etapa. A criação dos volumes para comunicação entre a máquina host e o container também.

### Estrutura de diretórios

Após a execução do script de preparação, você deve ter uma estrutura de diretórios assim:

```bash
.
├── paralelo
│   ├── WRF (ou WRF-4.0 pela opção de download da fonte)
│   ├── WPS
│   ├── GEOG_files
│   ├── ARWPost
│   └── bibliotecas
│       ├── jasper-1.900.1
│       ├── libpng-1.2.50
│       ├── mpich-3.0.4
│       ├── netcdf-4.1.3
│       └── zlib-1.2.7
└── scripts
```

Caso não tenha, volte por que algo capotou.

## :whale: Criando o container

### Build

Se as etapas anteiores foram bem-sucedidas, basta agora construir a imagem do container.

```bash
docker build . -t wrflammoc:0.1.0
```

O processo de construção da imagem deverá levar algo entre 15 e 30 minutos por conta do processo de compilação do modelo. Vai lá pegar um cafézinho...

Se tudo der certo (e provavelmente vai dar, por que é Linux), você deve receber esta mensagem no fim do processo:

![mensagem_final_compilacao_wrf](https://user-images.githubusercontent.com/12076399/126083031-2ef3a98e-b6ce-4ebc-8cd8-f0c6474e6d74.png)

Se a compilação do WPS for bem sucedida, serão criados três executáveis no diretório WPS:
geogrid.exe -> geogrid/src/geogrid.exe
ungrib.exe -> ungrib/src/ungrib.exe
metgrid.exe -> metgrid/src/metgrid.exe

### Execução

Após a construção da imagem do modelo compilado, o container pode ser executado. Para linkar com os dados geográficos, os dados de entrada do GFS e os scripts de operacionalização, é necessário especificar o volume no momento da execução. Também são especificados os volumes com as saídas (de relatórios e as saídas do modelo e do ARWPost, caso seja de interesse fazer o pós processamento gráfico no GrADs)

```bash
sudo docker run -v /home/lammoc/docker/volumes/GEOG_volume:/paralelo/GEOG_files -v /home/lammoc/docker/volumes/GFS_volume:/paralelo/WRF/GFS -v /home/lammoc/docker/volumes/WRF_out_volume:/paralelo/WRF/WRF_out -v /home/lammoc/docker/volumes/namelist_volume:/paralelo/namelists -v /home/lammoc/docker/volumes/relatorio_volume:/paralelo/relatorios --name WRF_container -it wrflammoc:0.1.0 bash

# o bash padrão é utilizado para fins de inspeção e _debugging_, para executar o container em modo interativo com terminal (recomendado)
```


Para operacionalização do modelo:

```bash
sudo docker exec -i WRF_container bash < exec_container.sh
```

Necessário atualizar os namelists do volume para atender a condiguração desejada de rodada.

## :construction_worker: Desenvolvimento

Os scripts bash seguem as diretrizes do guia de [estilo do Google](https://google.github.io/styleguide/shellguide.html).

As tags do projeto seguem o [versionamento semântico](https://semver.org/lang/pt-BR/).

### Como contribuir

O fluxo de contribuição é o clássico `fork -> clone -> edit -> pull request`.

- Crie um fork do repositório.

- Clone o repositório:

```bash
git clone ericmiguel/lammoc-wrf
```

- Crie uma branch para guardar suas alterações:

```bash
cd lammoc-wrf
git checkout -b nome-da-branch
```

- Faça o commit das suas alterações:

```bash
git add arquivos-alterados
git commit -m "sua mensagem de commit"
```

- Envia seu pull request ao repositório principal para avaliação.

Se você não está habituado a este fluxo, veja este [repositório](https://github.com/firstcontributions/first-contributions) para instruções mais detalhadas.
