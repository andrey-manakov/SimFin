#!/bin/bash
# cp .jazzy_for_main.yaml .jazzy.yaml
jazzy --config .jazzy_for_main.yaml
# cp .jazzy_for_tests.yaml .jazzy.yaml
jazzy --config .jazzy_for_tests.yaml
# cp .jazzy_for_uitests.yaml .jazzy.yaml
# jazzy --config .jazzy_for_uitests.yaml
# cp .jazzy_for_main.yaml .jazzy.yaml