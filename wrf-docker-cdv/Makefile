criar-diretorios:
	@ bash ./scripts/utilidades.sh criar-diretorios

gdrive:
	@ bash ./scripts/gdrive.sh instalar

gdrive-auth:
	@ bash ./scripts/gdrive.sh autenticar

gdrive-download:
	@ bash ./scripts/gdrive.sh download downloads

fonte-download:
	@ bash ./scripts/fonte.sh

pre-build:
	@ bash ./scripts/pre-build.sh

pre-build-gdrive:
	@ make criar-diretorios
	@ make gdrive-download downloads
	@ bash ./scripts/utilidades.sh renomear-arquivos-diretorio downloads
	@ make pre-build

pre-build-fonte:
	@ make criar-diretorios
	@ make fonte-download
	@ bash ./scripts/utilidades.sh renomear-arquivos-diretorio downloads
	@ make pre-build
