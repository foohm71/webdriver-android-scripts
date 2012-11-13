#!/bin/bash

HUB_HOST=localhost
HUB_PORT=4444
REGISTER_URL=http://${HUB_HOST}:${HUB_PORT}/grid/register

EMU_HOST=localhost
EMU_PORT=50001
JSON="{'configuration': {'registerCycle': 5000, 'hub': 'http://${HUB_HOST}:${HUB_PORT}/grid/register', 'host': '${HUB_PORT}', 'proxy': 'org.openqa.grid.selenium.proxy.DefaultRemoteProxy', 'maxSession': 1, 'port': ${EMU_PORT}, 'hubPort': ${HUB_PORT}, 'hubHost': '${HUB_HOST}', 'url': 'http://${EMU_HOST}:${EMU_PORT}', 'remoteHost': 'http://${EMU_HOST}:${EMU_PORT}', 'register': true, 'role': 'node'}, 'class': 'org.openqa.grid.common.RegistrationRequest', 'capabilities': [{'seleniumProtocol': 'WebDriver', 'platform': 'ANDROID', 'browserName': 'android', 'version': null, 'maxInstances': 1}]}"

echo $JSON

curl -X POST -d "$JSON" ${REGISTER_URL}
