FROM marqoai/marqo:2.8

WORKDIR /app

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY ./preload-marqo-model.sh preload-marqo-model.sh
RUN ./preload-marqo-model.sh

CMD [""]
ENTRYPOINT ./run_marqo.sh
