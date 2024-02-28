# wakamiti-learning
Windows:
docker run --rm -v "%cd%:/wakamiti" wakamiti/wakamiti:2.3.3
Linux:
docker run --rm -v "$(pwd)/wakamiti:/wakamiti" --add-host=host.docker.internal:host-gateway wakamiti/wakamiti:2.3.3