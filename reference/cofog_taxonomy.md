# COFOG Functional Classification Taxonomy

A lookup table containing the first-level Classification of the
Functions of Government (COFOG) taxonomy used by \`govhrcast\` to
classify government establishments according to their primary functional
responsibilities.

## Usage

``` r
data(cofog_taxonomy)
```

## Format

A data frame with 10 rows and 3 variables:

- class_id:

  Character. Two-digit COFOG class identifier (e.g., \`"01"\`,
  \`"02"\`).

- class_label:

  Character. Name of the first-level COFOG function.

- description:

  Character. Collection of keywords and descriptive terms associated
  with each COFOG function. These are intended to support rule-based and
  machine-assisted classification of government establishments.

The ten first-level COFOG functions are:

1.  General Public Services

2.  Defence

3.  Public Order and Safety

4.  Economic Affairs

5.  Environmental Protection

6.  Housing and Community Amenities

7.  Health

8.  Recreation, Culture and Religion

9.  Education

10. Social Protection

## Source

United Nations. \*Classification of the Functions of Government
(COFOG)\*; International Monetary Fund. \*Government Finance Statistics
Manual 2014\*.

## Details

The dataset includes the ten top-level COFOG classes defined by the
International Monetary Fund (IMF) Government Finance Statistics Manual
and the United Nations Classification of the Functions of Government,
together with descriptive keyword dictionaries that facilitate automated
establishment classification during HRMIS harmonization.

This dataset is intended primarily for internal use by the establishment
harmonization workflow, where establishment names are mapped to
functional classifications using keyword matching and other natural
language processing methods. Users may also employ the taxonomy directly
when developing custom classification rules or validating automated
classifications in general.

## See also

[`dictionary`](https://wb-pida-data-science-shop.github.io/govhr/reference/dictionary.md),
