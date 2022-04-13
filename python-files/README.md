# processamento-filas-dlq-lambda

Function Lambda para leitura e processamento das mensagens das filas de DLQ.

# Explicação do processo de geração do Zip

Para gerar o pacote Zip a ser usado no Deployment é preciso seguir um dos passos:

Dependências: Python 3.9 / Zip (cmd)


1. Geração via sh (Mais prático) 

- Abrir o terminal na raiz do projeto e executar o sh (package.sh) que gerará um .zip na raiz do projeto.

```
sh package.sh
```



2. Passo a passo:

- Abrir o terminal na raiz do projeto e executar o comando para baixar o pacote de dependências descritas no requirements.txt:

```
pip3 install -r requirements.txt --target ./package
```

- O comando criará uma pasta package na raiz do projeto com as dependências necessárias.

- Entraremos na pasta 'package' e iremos comprimir o conteúdo dela para um zip na raiz do projeto:

```
cd package
zip -r ../my-deployment-package.zip .
```

- Agora voltaremos diretório principal do projeto e a partir do zip criado no comando anterior, adicionaremos o restante dos arquivos e finalizaremos o Zip final (não sendo necessária a pasta package):

```
cd ..
zip -r my-deployment-package.zip . -x package/\*
```

- Arquivo pronto para ser submetido.
