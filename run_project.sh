for ARGUMENT in "$@"; do
    KEY=$(echo $ARGUMENT | cut -f1 -d=)

    KEY_LENGTH=${#KEY}
    VALUE="${ARGUMENT:$KEY_LENGTH+1}"

    export "$KEY"="$VALUE"
done

docker compose pull
docker compose up -d

docker exec -it archives_scraper_container python3 main.py --csis_volumes=$csis_volumes --scpe_issues=$scpe_issues

docker exec -it information_extraction_container bash /home/container_run.sh

# docker exec -it abstract_embedder_container python3 /home/embed_papers.py

# docker exec -it abstract_embedder_container python3 /home/embed_concepts.py

# docker exec -it topical_classifier_container python3 /home/pipeline.py

# docker exec -it publication_recommender_container python3 /home/similar_papers.py

# docker exec -it publication_recommender_container python3 /home/merge_graphs.py
