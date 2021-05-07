# Python code locations
app_code = helloworld/*.py
test_code = tests/*.py
package_name = "hello-hello"
dev_reqs_in = dev-requirements.in
dev_reqs = dev-requirements.txt

all: clean test build

test: clean codelint seclint unittest

# Build the package
build: clean 
	@printf "\n\n\033[0;32m** Packaging (dist) **\n\n\033[0m"
	python setup.py sdist
	pip install -e .
	twine check dist/*

# clean artifacts between runs
clean:
	rm -rf __pycache__
	rm -rf .eggs
	rm -rf *.egg-info
	rm -rf .coverage
	rm -rf dist
	rm -rf .pytest_cache
	rm -rf build
	pip uninstall $(package_name)

# Static analysis with prospector for Python code
codelint: compile-dev-deps
	@printf "\n\n\033[0;32m** Static code analysis (prospector) **\n\n\033[0m"
	prospector $(app_code) $(test_code)

# Static security analysis for Python code
seclint: compile-dev-deps
	@printf "\n\n\033[0;32m** Static code security analysis (bandit) **\n\n\033[0m"
	bandit $(app_code)

# Unit test with pytest
unittest: compile-dev-deps
	@printf "\n\n\033[0;32m** Unit testing (pytest) **\n\n\033[0m"
	python -m pytest -s -vvv tests/

# Compile the dev dependencies.
compile-dev-deps:
	pip-compile $(dev_reqs_in) --output-file ./$(dev_reqs)

package:
	twine upload --repository testpypi dist/*
	twine upload dist/*