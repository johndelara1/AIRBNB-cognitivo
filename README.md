# AIRBNB-cognitivo
Airbnb é um serviço online comunitário para as pessoas anunciarem, descobrirem e reservarem acomodações e meios de hospedagem.

## Usando
Para utilizar esse repositório, com  seu Rstudio instalado e entre em File -> New_Project... -> Version Control -> Git
Cole o link abaixo no Repository URL: 
Clique em Created Project

```
https://github.com/johndelara1/AIRBNB-cognitivo.git
```

Após o processo você poderá fechar a janela que aparece e pronto, esse repositório estará na sua máquina 

    docker run --rm -p "8085:8085" neowaylabs/gcloud-pubsub-emulator

## Configuration
To change the host/port the server will listen on and the directory where data files will be placed, provide the correct command line options.
The following example shows how to start the *Pub Sub* emulator to listen in `192.168.0.9:8489` and store its files in the `/pubsub` directory.

    docker run --rm neowaylabs/gcloud-pubsub-emulator start --host-port=192.168.0.9:8489 --data-dir=/pubsub

By default, the image is set to listen on `0.0.0.0:8085` and store its files in the`/data` directory.

> Notice the usage of the `PUBSUB_EMULATOR_HOST` to let the pubsub client know about the emulator.
