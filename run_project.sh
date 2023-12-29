for ARGUMENT in "$@"; do
    KEY=$(echo $ARGUMENT | cut -f1 -d=)

    KEY_LENGTH=${#KEY}
    VALUE="${ARGUMENT:$KEY_LENGTH+1}"

    export "$KEY"="$VALUE"
done

docker compose pull
docker compose up -d

docker exec -it archives_scraper_container python3 main.py --csis_volumes=$csis_volumes --scpe_issues=$scpe_issues
docker cp archives_scraper_container:/scraper/output/ .
rsync -a ./output/ ./scraper_output/ && rm -rf ./output

docker exec -it information_extraction_container bash /home/container_run.sh
docker cp information_extraction_container:/home/final_ttls_for_every_run/ .
rsync -a ./final_ttls_for_every_run/ ./info_extractor_output/ && rm -rf ./final_ttls_for_every_run

docker exec -it abstract_embedder_container python3 /home/embed_papers.py
docker cp abstract_embedder_container:/home/output_ttl_files/ .
rsync -a ./output_ttl_files/ ./embedder_output/ && rm -rf ./output_ttl_files

docker exec -it abstract_embedder_container python3 /home/embed_concepts.py

docker exec -it topical_classifier_container python3 /home/pipeline.py
docker cp topical_classifier_container:/home/output/ .
rsync -a ./output/ ./classifier_output/ && rm -rf ./output

docker exec -it publication_recommender_container python3 /home/similar_papers.py

docker exec -it publication_recommender_container python3 /home/merge_graphs.py
docker cp publication_recommender_container:/home/output/ .
rsync -a ./output/ ./final_output/ && rm -rf ./output

