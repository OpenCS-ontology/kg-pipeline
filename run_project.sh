for ARGUMENT in "$@"; do
    KEY=$(echo $ARGUMENT | cut -f1 -d=)

    KEY_LENGTH=${#KEY}
    VALUE="${ARGUMENT:$KEY_LENGTH+1}"

    export "$KEY"="$VALUE"
done

# echo "Pulling scraper image..."
# docker pull ghcr.io/opencs-ontology/publication-scraper:main

# echo "Pulling section and bibliography extraction image..."
# docker pull ghcr.io/opencs-ontology/section-and-bibliography-ie:main

# echo "Pulling table and figure extraction image..."
# docker pull ghcr.io/opencs-ontology/table-and-figure-ie:main

# echo "Pulling publication embeddings image..."
# docker pull ghcr.io/opencs-ontology/publication-embeddings:main

# echo "Pulling elastic search image..."
# docker pull docker.elastic.co/elasticsearch/elasticsearch:7.12.1

# echo "Pulling topical classifier image..."
# docker pull ghcr.io/opencs-ontology/topical-classifier-elastic:main

# docker compose up -d

# archives=("scpe" "csis")

# docker exec -it archives_scraper_container python3 main.py --volume $volume

# docker exec -it section_and_bibliography_container bash ./container_run.sh

# echo "Waiting 60s to let grobid server set up..."
# sleep 60

# docker exec -it table_and_figure_extraction_container bash /home/container_run.sh

# docker exec -it abstract_embedder_container python3 /home/embed_abstracts.py

docker exec -it topical_classifier_container python3 /home/pipeline.py
