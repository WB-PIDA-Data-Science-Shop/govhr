# govhr 0.3.4
This release:
- Improves the documentation of functions and articles associated with `govhr`.
- Adds more indicators to `wwbi`, including the wagebill as a share of GDP.

# govhr 0.3.3
This release:
- Ports a set of functionalities from `govhrapp` into `govhr`. This include functions that project retirements, compute compression ratios, among others.

# govhr 0.3.2
This release: 
- Further updates and additions to the movement functions and unit tests to support indicator generation for the govhrapp

# govhr 0.3.1
This release: 
- Updates the movement functions and unit tests to be more robust to changes in the harmonization dictionary and
lazy-loaded objects.

# govhr 0.3.0
This release:

- Updates the standard dictionary by including a new allowance module.
- Adds a new function, `classify_text`, to classify a vector of characters against a taxonomy. Built for COFOG but generalizable to other taxonomies.
- Update lazy-loaded data for the harmonized data, using the updated dictionary.

# govhr 0.2.2

This release: 

- Adds a new function to compute deflated wages.
- Updates the `macro_indicators` dataset.

# govhr 0.2.1

This release:

- Adds functions compute tenure. In particular, tenure at the personnel level for an entire panel dataset.

# govhr 0.2.0

This release:

- Updates the dictionary, creating a novel convention for the establishment module. For example, modules are now classified according to their level, such as `adm1` for ministries.
