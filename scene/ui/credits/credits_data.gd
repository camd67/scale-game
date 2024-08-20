class_name CreditsData

static var developers := [
	["CamD67", "Programming, VFX, UI"],
	["TekTiteToe", "Audio, Programming"],
	["Imbajoe", "3D Assets, Programming"],
]

static var third_party_assets := [
	["Particle VFX textures", "Kenny Particle Pack", "kenney.nl",  "https://www.kenney.nl/assets/particle-pack"],
	["Fire Crackle SFX","TheWoodlandNomad", "freesound.org",  "https://freesound.org/people/TheWoodlandNomad/sounds/363093/"],
	["Planet textures", "https://www.solarsystemscope.com", "CC BY 4.0", "https://creativecommons.org/licenses/by/4.0/"],
	["Bodoni Moda SC", "Copyright 2020 The Bodoni Moda Project Authors", "Bodoni Github", "https://github.com/indestructible-type/Bodoni"],
	["Fredericka the Great", "Copyright (c) 2011, Tart Workshop (a DBA of Font Diner, Inc)", "FontDiner.com", "www.fontdiner.com"]
]


static func get_credits_data() -> Array:
	# Credits data will dynamically appear in the credits page of the main menu.
	# Must be two string elements, with an optional 3rd for license link and 4th for text
	var credits := []

	credits.append(["GMTK Jam Developers", ""])
	# What better way to make sure we're all equally shown first than to leave it up to RNG
	developers.shuffle()
	credits.append_array(developers)

	credits.append(["Third party assets", ""])
	credits.append_array(third_party_assets)

	return credits
