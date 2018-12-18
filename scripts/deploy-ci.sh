#!/bin/sh

echo "{\"token\":\"${OPENODE_TOKEN}\",\"site_name\":\"eerf\",\"instance_type\":\"server\"}" > .openode

openode locations

openode status

openode sync-n-reload
