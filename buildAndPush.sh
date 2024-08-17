#!/usr/bin/env bash
set -euo pipefail


if [[ ! $(godot --version) =~ ^4\.3 ]]; then
	echo "This project must be built with godot 4.3 on your path."
	echo "Please add it to your path then re-run this script."
	echo
	echo "Did you set the executable name to be 'godot' and place that on your path?"
	exit 1
fi

echo "---------- Building and exporting game via godot ---------"
echo
godot --headless --export-release "web" export/web/index.html

echo
echo "---------- Push via butler to itch ---------"
echo
butler push export/web camd67/scale-game:html