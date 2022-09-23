#! /bin/bash


sh CreateResourceGroup.sh
sh CreateContainerAppEnvironment.sh testappenv rg-container-webapp
sh CreateAndUploadWebImage.sh rg-container-webapp lolregistry2423
sh CreateContainerApp.sh rg-container-webapp lolregistry2423 testappenv