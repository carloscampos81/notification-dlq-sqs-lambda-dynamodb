#!/usr/bin/env bash
pip3 install -r requirements.txt --target ./package

cd package
zip -r ../my-deployment-package.zip .

cd ..
zip -r my-deployment-package.zip . -x package/\*
