printf "Is it running?\n"
curl -i -X GET http://localhost:3000/

printf "\n\nDoes it parse JSON?\n"
curl -i -X POST \
  -d "{\"description\": \"shoeA\",
       \"color\": \"colorA\",
       \"size\": \"sizeA\",
       \"photo\": \"jpgA\"
      }" \
  http://localhost:3000/shoe/create

printf "\n\nDoes it except bad JSON?\n"
# missing comma
curl -i -X POST \
  -d "{\"description\": \"shoeA\"
       \"color\": \"colorA\",
       \"size\": \"sizeA\",
       \"photo\": \"jpgA\"
      }" \
  http://localhost:3000/shoe/create

printf "\n\n"
