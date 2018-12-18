#!/bin/sh

echo "{\"token\":\"${OPENODE_TOKEN}\",\"site_name\":\"eerf\",\"instance_type\":\"server\"}" > .openode

openode status #deploy -t ${OPENODE_TOKEN} -s eerf
