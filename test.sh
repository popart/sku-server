curl -i -X GET http://localhost:3000/
curl -i -X POST \
  -d "{\"description\": \"shoeA\",
       \"color\": \"colorA\",
       \"size\": \"sizeA\",
       \"photo\": \"jpgA\"
      }" \
  http://localhost:3000/readbodyJSON
