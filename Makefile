# Python code locations
app_code = helloworld/*.py
test_code = tests/*.py
package_name = "hello-hello"


test: clean codelint seclint unittest

# clean artifacts between runs
clean:
	rm -rf __pycache__
	rm -rf .eggs
	rm -rf *.egg-info
	rm -rf .coverage
	rm -rf dist
	rm -rf .pytest_cache
	pip uninstall $(package_name)

# Static analysis with prospector for Python code
codelint: 
	@printf "\n\n\033[0;32m** Static code analysis (prospector) **\n\n\033[0m"
	prospector $(app_code) $(test_code)

# Static security analysis for Python code
seclint:
	@printf "\n\n\033[0;32m** Static code security analysis (bandit) **\n\n\033[0m"
	bandit $(app_code)

# Unit test with pytest
unittest:
	@printf "\n\n\033[0;32m** Unit testing (pytest) **\n\n\033[0m"
	python -m pytest -s -vvv tests/

