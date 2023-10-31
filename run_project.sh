for ARGUMENT in "$@"; do
    KEY=$(echo $ARGUMENT | cut -f1 -d=)

    KEY_LENGTH=${#KEY}
    VALUE="${ARGUMENT:$KEY_LENGTH+1}"

    export "$KEY"="$VALUE"
done

cp ./merge_ttl_files.py ./table_and_figure_extract/merge_ttl_files.py
cp ./merge_ttl_files.py ./section_and_bibliography_extraction/merge_ttl_files.py

docker compose up -d

archives=("scpe" "csis")

for archive in "${archives[@]}"; do
    sudo rm -rf ./scraper/output/pdfs/$archive/*
    sudo rm -rf ./scraper/output/ttls/$archive/*
    sudo rm -rf ./table_and_figure_extract/output/$archive/*
    sudo rm -rf ./section_and_bibliography_extraction/output/$archive/*
done

docker exec -it archives_scraper_container python3 main.py --volume $volume

docker exec -it section_and_bibliography_container rm -rf /input_pdf_files
docker exec -it section_and_bibliography_container mkdir /input_pdf_files

for archive in "${archives[@]}"; do
    docker exec -it section_and_bibliography_container mkdir /home/input_ttl_files/$archive
    docker cp ./scraper/output/ttls/$archive/ section_and_bibliography_container:/home/input_ttl_files
    docker cp ./scraper/output/pdfs/$archive/ section_and_bibliography_container:/input_pdf_files
done

docker exec -it section_and_bibliography_container bash ./container_run.sh

echo "Waiting 60s to let grobid server set up..."
sleep 60

docker exec -it table_and_figure_extraction_container rm -rf /input_pdf_files
docker exec -it table_and_figure_extraction_container mkdir /input_pdf_files

for archive in "${archives[@]}"; do
    docker cp ./section_and_bibliography_extraction/output/$archive/ table_and_figure_extraction_container:/home/input_ttl_files
    docker cp ./scraper/output/pdfs/$archive/ table_and_figure_extraction_container:/input_pdf_files
done

docker exec -it table_and_figure_extraction_container bash /home/container_run.sh

for archive in "${archives[@]}"; do
    docker cp ./section_and_bibliography_extraction/output/$archive abstract_embedder_container:home/input_ttl_files
done

docker exec -it abstract_embedder_container python3 /home/embed_abstracts.py
