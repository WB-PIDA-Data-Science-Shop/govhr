# Classify free-text items against a user-supplied taxonomy using TF-IDF

Classify free-text items against a user-supplied taxonomy using TF-IDF

## Usage

``` r
classify_text(
  corpus,
  taxonomy,
  id_col = "id",
  text_col = "text",
  class_id_col = "class_id",
  class_label_col = "class_label",
  num_leaves = 1,
  method = c("tfidf_sum", "cosine"),
  max_dist = 0.1,
  string_dist = NULL,
  stopwords = NULL
)
```

## Arguments

- corpus:

  A data.frame with at minimum an id column and a text column.

- taxonomy:

  Either: - A named character vector: names = class IDs, values = class
  labels/descriptions - A data.frame with columns identified by
  \`class_id_col\` and \`class_label_col\`

- id_col:

  Name of the id column in \`corpus\`. Default "id".

- text_col:

  Name of the text column in \`corpus\`. Default "text".

- class_id_col:

  Name of the class ID column in \`taxonomy\` (if data.frame). Default
  "class_id".

- class_label_col:

  Name of the class label column in \`taxonomy\` (if data.frame).
  Default "class_label".

- num_leaves:

  Number of top-matching classes to return per item. Default 1.

- method:

  "tfidf_sum" (mirrors labourR) or "cosine" (improved,
  length-normalised). Default "tfidf_sum".

- max_dist:

  Maximum string distance for fuzzy token matching (used when
  \`string_dist\` is set).

- string_dist:

  String distance method passed to \`stringdist::amatch()\`. NULL
  disables fuzzy matching.

- stopwords:

  Character vector of stopwords to remove. NULL uses a built-in English
  set.

## Value

A data.table with columns: \<id_col\>, class_id, class_label, score
