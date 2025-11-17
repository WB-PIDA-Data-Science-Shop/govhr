################################################################################
############ PREPARING THE LOGO FOR THIS AWESOME PACKAGE LEH-GO ################
################################################################################

# install.packages("hexSticker")
library(hexSticker)
library(cropcircles)
library(ggpath)


#### lets view the image
image_path <- "spielplatz/logo/govhrlogo.png"


img_cropped <- hex_crop(images = image_path,
                        border_colour = "#083D77",
                        border_size = 20,
                        just = "center")

### lets plot it
ggplot() +
  geom_from_path(aes(0.5, 0.5, path = img_cropped)) +
  theme_void() +
  coord_fixed()
ggsave("spielplatz/logo/govhr.png", height = 6, width = 6)
