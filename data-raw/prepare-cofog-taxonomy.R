cofog_taxonomy <- data.frame(
  class_id = c(
    "01", "02", "03", "04", "05", "06", "07", "08", "09", "10"
  ),
  class_label = c(
    "General Public Services",
    "Defence",
    "Public Order and Safety",
    "Economic Affairs",
    "Environmental Protection",
    "Housing and Community Amenities",
    "Health",
    "Recreation, Culture and Religion",
    "Education",
    "Social Protection"
  ),
  description = c(
    # 01 General Public Services
    "executive legislative organs financial fiscal affairs external affairs
     foreign economic aid general services basic research public debt
     ombudsman controller audit planning management modernization
     communication regulatory general administration government office
     governor vice governor military office transfers between levels of government",

    # 02 Defence
    "military defence armed forces civil defence foreign military aid
     national security army navy air force",

    # 03 Public Order and Safety
    "police services fire protection fire brigade law courts prisons
     penitentiary justice civil defense security violence prevention
     resocialization correctional detention",

    # 04 Economic Affairs
    "general economic commercial labour affairs agriculture forestry
     fishing hunting aquaculture livestock fuel energy mining manufacturing
     construction transport roads transit communication other industries
     tourism trade labor employment innovation technology metrology quality
     standards land reform supply engineering urban development consumer
     protection foment rural development institute",

    # 05 Environmental Protection
    "waste management waste water pollution abatement biodiversity landscape
     ecology water resources natural resources sustainability conservation
     environmental institute",

    # 06 Housing and Community Amenities
    "housing development community development water supply street lighting
     urban housing amenities",

    # 07 Health
    "medical products appliances equipment outpatient services hospital
     services public health sanitation nursing clinical care health sciences
     health assistance servants employees",

    # 08 Recreation, Culture and Religion
    "recreational sporting services cultural services broadcasting publishing
     religious community sport leisure youth theater arts heritage museum
     library entertainment palmares institute",

    # 09 Education
    "pre-primary primary secondary post-secondary tertiary education
     university learning professional training research science higher
     education teaching school institute university health sciences",

    # 10 Social Protection
    "sickness disability old age survivors family children unemployment
     housing social exclusion pension retirement retirees welfare assistance
     social inclusion women citizenship human rights poverty vulnerability
     resocialization"
  ),
  stringsAsFactors = FALSE
)

# ── Save for lazy-loading in your package ─────────────────────────────────────

# Option A: as internal package data (accessible via govhr::cofog_taxonomy)
usethis::use_data(cofog_taxonomy, overwrite = TRUE)

